import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mipromo/api/database_api.dart';
import 'package:mipromo/api/paypal_api.dart';
import 'package:mipromo/api/storage_api.dart';
import 'package:mipromo/api/stripe_api.dart';
import 'package:mipromo/app/app.locator.dart';
import 'package:mipromo/app/app.router.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/models/book_service.dart';
import 'package:mipromo/models/order.dart';
import 'package:mipromo/models/shop.dart';
import 'package:mipromo/models/shop_service.dart';
import 'package:mipromo/services/user_service.dart';
import 'package:mipromo/ui/shared/helpers/data_models.dart';
import 'package:mipromo/ui/shared/helpers/enums.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OrderDetailViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _databaseApi = locator<DatabaseApi>();
  final _paypalApi = locator<PaypalApi>();
  final _stripeApi = StripeApi();
  final _storageApi = locator<StorageApi>();
  final _userService = locator<UserService>();
  late Order order;
  late ShopService service;
  int? selectedSize;
  bool isApiLoading = false;
  double rating = 0;

  late AppUser shopOwner;
  late AppUser buyer;
  late Shop shopDetails;
  late BookkingService bookkingService;
  String shopImage =
      'https://firebasestorage.googleapis.com/v0/b/mipromo-03.appspot.com/o/profileImages%2FiBrUYThY0WcbsJNMCkVHIb7Et3I3%2FPI._iBrUYThY0WcbsJNMCkVHIb7Et3I3?alt=media&token=680bd701-405e-428e-879b-efbd7fecb970';

  bool isLoading = false;
  bool isRatingLoading = false;

  late double processingFee;

  void getSelectedSize(int size) {
    selectedSize = size;
    notifyListeners();
  }

  late AppUser user;

  Future<void> init(ShopService cService, Order cOrder) async {
    setBusy(true);
    await _userService.syncUser();
    user = _userService.currentUser;
    order = cOrder;
    service = cService;
    getShopOwner();
  }

  void updateRating(double rate) {
    rating = rate;
    notifyListeners();
  }

  void getShopOwner() async {
    shopOwner = await _databaseApi.getUser(order.service.ownerId);
    shopDetails = await _databaseApi.getShop(order.shopId);
    buyer = await _databaseApi.getUser(order.userId);
    processingFee = await _databaseApi.getProcessingFee();
    if (order.bookkingId != null)
      bookkingService = await _databaseApi.getBooking(order.bookkingId!);
    notifyListeners();
    setBusy(false);
  }

  void updateOrder(String orderID) async {
    isApiLoading = true;
    notifyListeners();
    order = await _databaseApi.getOrder(orderID);
    isApiLoading = false;
    notifyListeners();
  }

  Future navigateToShopView(
    AppUser owner,
  ) async {
    await _navigationService.navigateTo(
      Routes.sellerProfileView,
      arguments: SellerProfileViewArguments(
        seller: owner,
      ),
    );
  }

  Future navigateToBuyerView({
    required AppUser owner,
  }) async {
    await _navigationService.navigateTo(
      Routes.buyerProfileView,
      arguments: BuyerProfileViewArguments(
        user: owner,
      ),
    );
  }

  // Future navigateToBookServiceView(Order order) async {
  //   await _navigationService.navigateTo(Routes.bookServiceView,
  //       arguments: BookServiceViewArguments(user: user, service: service));
  // }

  Future<void> updateChat(String recieverId) async {
    await _databaseApi
        .updateChatIds(
      userId: user.id,
      receiverId: recieverId,
    )
        .whenComplete(
      () async {
        init(service, order).whenComplete(
          () async {
            await _navigationService.navigateTo(
              Routes.chatsView,
              arguments: ChatsViewArguments(
                currentUser: user,
                onMainView: false,
              ),
            );
          },
        );
      },
    );
  }

  Future<void> deleteService(ShopService service) async {
    final response = await _dialogService.showCustomDialog(
      variant: AlertType.error,
      title: 'Delete Service?',
      description: 'Are you sure, you want to delete this Service.',
      customData: CustomDialogData(
        isConfirmationDialog: true,
      ),
    );

    if (response != null && response.confirmed) {
      setBusy(true);
      await Future.wait(
        [
          _databaseApi.deleteService(service.id),
          _storageApi.deleteServiceImage(service.id, service.imageId1!),
        ],
      ).whenComplete(() {
        setBusy(false);
        _navigationService.back();
      });
    }
  }

  Future<void> navigateToChatsView() async {
    _navigationService.back();
    await _navigationService.navigateTo(
      Routes.chatsView,
      arguments: ChatsViewArguments(
        currentUser: user,
        onMainView: false,
      ),
    );
  }

  Future handleRefund(Order order) async {
    try {
      isApiLoading = true;
      notifyListeners();
      final accessToken = await _paypalApi.getAccessToken();
      final response;
      if (order.paymentMethod == MPaymentMethod.paypal) {
        response = await _paypalApi.refundPayment(order, accessToken!);
      } else {
        response = await _stripeApi.refundPayment(order);
      }
      if (response['statusCode'] == 201 || response['id'] != null) {
        isApiLoading = false;
        notifyListeners();
        _databaseApi
            .refundOrder(order, DateTime.now().microsecondsSinceEpoch)
            .then((value) async {
          var token = await _databaseApi.getToken(order.userId);
          if (token != null) {
            Shop shopDetails = await _databaseApi.getShop(order.service.shopId);
            var test = _databaseApi.postNotification(
                orderID: order.orderId,
                title: 'Order has been cancelled',
                body:
                    '${shopDetails.name} has cancelled ${order.service.name}(£${order.service.price})',
                forRole: 'order',
                userID: '',
                receiverToken: token.toString());

            Map<String, dynamic> postMap = {
              "userId": user.id,
              "orderID": order.orderId,
              "title": 'Order has been cancelled',
              "body":
                  '${shopDetails.name} has cancelled ${order.service.name}(£${order.service.price})',
              "id": DateTime.now().millisecondsSinceEpoch.toString(),
              "read": false,
              "image": user.imageUrl,
              "time": DateTime.now().millisecondsSinceEpoch.toString(),
              "sound": "default"
            };

            _databaseApi.postNotificationCollection(order.userId, postMap);
          }

          await _dialogService.showCustomDialog(
              variant: AlertType.success,
              title: 'Success',
              description: 'Order is cancelled');
          _navigationService.back();
        });
      } else {
        isApiLoading = false;
        notifyListeners();
        _dialogService.showCustomDialog(
            variant: AlertType.error,
            title: 'Error',
            description: response['message'] as String);
      }
    } catch (exception) {
      isApiLoading = false;
      notifyListeners();
      _dialogService.showCustomDialog(
          variant: AlertType.error,
          title: 'Error',
          description: exception.toString());
    }
  }

  Future handleRefundCase(Order order, BuildContext context) async {
    showDialog(context);
    /*try {
      isApiLoading = true;
        notifyListeners();
        _databaseApi
            .refundCaseOpen(order, DateTime.now().microsecondsSinceEpoch)
            .then((value) async {
          isApiLoading = false;
          notifyListeners();
          await _dialogService.showCustomDialog(
              variant: AlertType.success,
              title: 'Refund case opened',
              description: "Sorry for inconvenience, You'll be contacted as soon as possible.");
          _navigationService.back();
        });

    } catch (exception) {
      isApiLoading = false;
      notifyListeners();
      _dialogService.showCustomDialog(
          variant: AlertType.error,
          title: 'Error',
          description: exception.toString());
    }*/
  }

  void showDialog(BuildContext context) {
    TextEditingController _reasonCont = new TextEditingController();
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black54,
      transitionDuration: Duration(milliseconds: 200),
      context: context,
      pageBuilder: (_, __, ___) {
        return Material(
          color: Colors.transparent,
          child: Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Container(
                height: 190,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  color: Color(0xFF424242),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Refund Case',
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Default'),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          'Please write dispute reason: ',
                          style: TextStyle(
                              decoration: TextDecoration.none,
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Default'),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Container(
                      height: 90,
                      padding: EdgeInsets.only(left: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Color(0x60A09C9C))),
                      child: TextField(
                        maxLines: 4,
                        controller: _reasonCont,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Write reason',
                          hintStyle: TextStyle(color: Colors.white),
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              _navigationService.back();
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontSize: 14,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Default'),
                            ),
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          InkWell(
                            onTap: () {
                              if (_reasonCont.text.isNotEmpty) {
                                _navigationService.back();
                                try {
                                  isApiLoading = true;
                                  notifyListeners();
                                  _databaseApi
                                      .refundCaseOpen(_reasonCont.text, order,
                                          DateTime.now().microsecondsSinceEpoch)
                                      .then((value) async {
                                    isApiLoading = false;
                                    notifyListeners();
                                    await _dialogService.showCustomDialog(
                                        variant: AlertType.success,
                                        title: 'Refund case opened',
                                        description:
                                            "Sorry for inconvenience, You'll be contacted as soon as possible.");
                                    _navigationService.back();
                                  });
                                } catch (exception) {
                                  isApiLoading = false;
                                  notifyListeners();
                                  _dialogService.showCustomDialog(
                                      variant: AlertType.error,
                                      title: 'Error',
                                      description: exception.toString());
                                }
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Please write the reason",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 3,
                                    backgroundColor: Colors.black87,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              }
                            },
                            child: Text(
                              'Submit',
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Default'),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: anim,
            curve: Curves.easeIn,
          ),
          child: child,
        );
      },
    );
  }

  Future handleCancelRefundCase(Order order) async {
    final dialogResponse = await _dialogService.showConfirmationDialog(
      title: 'Do you want to close this refund case ?',
      confirmationTitle: 'Close case',
      cancelTitle: 'Back',
    );
    if (dialogResponse?.confirmed ?? false) {
      try {
        isApiLoading = true;
        notifyListeners();
        _databaseApi
            .refundCaseClose(order, DateTime.now().microsecondsSinceEpoch)
            .then((value) async {
          isApiLoading = false;
          notifyListeners();
          await _dialogService.showCustomDialog(
              variant: AlertType.success,
              title: 'Refund case closed',
              description: "Thank you for using our service.");
          _navigationService.back();
        });
      } catch (exception) {
        isApiLoading = false;
        notifyListeners();
        _dialogService.showCustomDialog(
            variant: AlertType.error,
            title: 'Error',
            description: exception.toString());
      }
    }
  }

  Future handleRequestRefund(Order order) async {
    final dialogResponse = await _dialogService.showConfirmationDialog(
      title: 'You should message your seller before requesting',
      confirmationTitle: 'Request Refund',
      cancelTitle: 'Close',
    );

    if (dialogResponse?.confirmed ?? false) {
      try {
        isApiLoading = true;
        notifyListeners();
        final accessToken = await _paypalApi.getAccessToken();
        final response;
        if (order.paymentMethod == MPaymentMethod.paypal) {
          response = await _paypalApi.refundPayment(order, accessToken!);
        } else {
          response = await _stripeApi.refundPayment(order);
        }
        if (response['statusCode'] == 201 || response['id'] != null) {
          isApiLoading = false;
          notifyListeners();
          _databaseApi
              .refundOrder(order, DateTime.now().microsecondsSinceEpoch)
              .then((value) async {
            await _dialogService.showCustomDialog(
                variant: AlertType.success,
                title: 'Success',
                description: 'Payment is refunded.');
            _navigationService.back();
          });
        } else {
          isApiLoading = false;
          notifyListeners();
          _dialogService.showCustomDialog(
              variant: AlertType.error,
              title: 'Error',
              description: response['message'] as String);
        }
      } catch (exception) {
        isApiLoading = false;
        notifyListeners();
        _dialogService.showCustomDialog(
            variant: AlertType.error,
            title: 'Error',
            description: exception.toString());
      }

      /*isApiLoading = true;
      notifyListeners();
      _databaseApi
          .requestRefundOrder(order, DateTime.now().microsecondsSinceEpoch)
          .then((value) async {
        isApiLoading = false;
        await _dialogService.showCustomDialog(
            variant: AlertType.success,
            title: 'Success',
            description: 'Refund is requested.');
        _navigationService.back();
      }, onError: (exception) {
        isApiLoading = false;
        notifyListeners();
        _dialogService.showCustomDialog(
            variant: AlertType.error,
            title: 'Error',
            description: exception.toString());
      });*/
    }
  }

  Future handleCancelRefund(Order order) async {
    final dialogResponse = await _dialogService.showConfirmationDialog(
      title: 'Are you sure you want to cancel and refund?',
      confirmationTitle: 'Request Refund',
      cancelTitle: 'Close',
    );

    if (dialogResponse?.confirmed ?? false) {
      try {
        isApiLoading = true;
        notifyListeners();
        final accessToken = await _paypalApi.getAccessToken();
        final response;
        if (order.paymentMethod == MPaymentMethod.paypal) {
          response = await _paypalApi.refundPayment(order, accessToken!);
        } else {
          response = await _stripeApi.refundPayment(order);
        }
        if (response['statusCode'] == 201 || response['id'] != null) {
          isApiLoading = false;
          notifyListeners();
          _databaseApi
              .refundOrder(order, DateTime.now().microsecondsSinceEpoch)
              .then((value) async {
            var token = await _databaseApi.getToken(order.service.ownerId);
            if (token != null) {
              Shop shopDetails =
                  await _databaseApi.getShop(order.service.shopId);
              var test = _databaseApi.postNotification(
                  orderID: order.orderId,
                  title: 'Order has been cancelled',
                  body:
                      '${order.service.name}(£${order.service.price}) on ${shopDetails.name} by ${order.name}',
                  forRole: 'order',
                  userID: '',
                  receiverToken: token.toString());

              Map<String, dynamic> postMap = {
                "userId": user.id,
                "orderID": order.orderId,
                "title": 'Order has been cancelled',
                "body":
                    '${order.service.name}(£${order.service.price}) on ${shopDetails.name} by ${order.name}',
                "id": DateTime.now().millisecondsSinceEpoch.toString(),
                "read": false,
                "image": user.imageUrl,
                "time": DateTime.now().millisecondsSinceEpoch.toString(),
                "sound": "default"
              };

              _databaseApi.postNotificationCollection(
                  shopDetails.ownerId, postMap);
            }
            await _dialogService.showCustomDialog(
                variant: AlertType.success,
                title: 'Success',
                description: 'Payment is refunded.');
            _navigationService.back();
          });
        } else {
          isApiLoading = false;
          notifyListeners();
          _dialogService.showCustomDialog(
              variant: AlertType.error,
              title: 'Error',
              description: response['message'] as String);
        }
      } catch (exception) {
        isApiLoading = false;
        notifyListeners();
        _dialogService.showCustomDialog(
            variant: AlertType.error,
            title: 'Error',
            description: exception.toString());
      }
    }
  }

  Future handleRequestReceivedProduct(Order order) async {
    final DialogResponse? dialogResponse =
        await _dialogService.showCustomDialog(
      variant: AlertType.error,
      title: 'Are you sure',
      description: 'Have you received your product?',
      mainButtonTitle: 'Product received',
      secondaryButtonTitle: "Close",
      customData: CustomDialogData(
        isConfirmationDialog: true,
      ),
    );

    if (dialogResponse?.confirmed ?? false) {
      try {
        isApiLoading = true;
        notifyListeners();
        final shopDetails = await _databaseApi.getShop(order.shopId);
        final paypalEmail =
            await _databaseApi.getSellerPaypal(shopDetails.ownerId);
        final accessToken = await _paypalApi.getAccessToken();
        final response = await _paypalApi.payProductSellerPayment(
            paypalEmail.toString(), order, processingFee, accessToken!);
        if (response['statusCode'] == 201) {
          final String timeString = DateTime.now().toString();
          _databaseApi
              .completeOrder(
                  order, DateTime.parse(timeString).microsecondsSinceEpoch)
              .then((value) async {
            _databaseApi
                .updateTotalSaleCount(order.service.ownerId)
                .then((value) async {
              ///Notification
              var token = await _databaseApi.getToken(order.service.ownerId);
              if (token != null) {
                var test = _databaseApi.postNotification(
                    orderID: order.orderId,
                    title: 'Order Completed',
                    body:
                        '${order.name} received ${order.service.name}(£${order.service.price}) from ${shopDetails.name}',
                    forRole: 'order',
                    userID: '',
                    receiverToken: token.toString());

                Map<String, dynamic> postMap = {
                  "userId": user.id,
                  "orderID": order.orderId,
                  "title": 'Order Completed',
                  "body":
                      '${order.name} received ${order.service.name}(£${order.service.price}) from ${shopDetails.name}',
                  "id": DateTime.now().millisecondsSinceEpoch.toString(),
                  "read": false,
                  "image": user.imageUrl,
                  "time": DateTime.now().millisecondsSinceEpoch.toString(),
                  "sound": "default"
                };

                _databaseApi.postNotificationCollection(
                    shopDetails.ownerId, postMap);
              }
              isApiLoading = false;
              notifyListeners();
              await _dialogService.showCustomDialog(
                variant: AlertType.success,
                title: 'Order Completed',
                description: 'Thank you for using our service',
              );
              _navigationService.back();
            });
          });
        } else {
          isApiLoading = false;
          notifyListeners();
          _dialogService.showCustomDialog(
              variant: AlertType.error,
              title: 'Error',
              description: response['message'] as String);
        }
      } catch (exception) {
        isApiLoading = false;
        notifyListeners();
        _dialogService.showCustomDialog(
            variant: AlertType.error,
            title: 'Error',
            description: exception.toString());
      }
    }
  }

  Future handleRequestReceivedService(Order order) async {
    final DialogResponse? dialogResponse =
        await _dialogService.showCustomDialog(
      variant: AlertType.error,
      title: 'Are you sure',
      description: 'Have you received your service?',
      mainButtonTitle: 'service received',
      secondaryButtonTitle: "Close",
      customData: CustomDialogData(
        isConfirmationDialog: true,
      ),
    );

    if (dialogResponse?.confirmed ?? false) {
      try {
        isApiLoading = true;
        notifyListeners();

        final String timeString = DateTime.now().toString();
        _databaseApi
            .completeOrder(
                order, DateTime.parse(timeString).microsecondsSinceEpoch)
            .then((value) async {
          _databaseApi
              .updateTotalSaleCount(order.service.ownerId)
              .then((value) async {
            var token = await _databaseApi.getToken(order.service.ownerId);
            if (token != null) {
              var test = _databaseApi.postNotification(
                  orderID: order.orderId,
                  title: 'Booking completed',
                  body:
                      '${order.name} has received ${order.service.name}(£${order.service.price}) from ${shopDetails.name}',
                  forRole: 'order',
                  userID: '',
                  receiverToken: token.toString());

              Map<String, dynamic> postMap = {
                "userId": user.id,
                "orderID": order.orderId,
                "title": 'Booking completed',
                "body":
                    '${order.name} has received ${order.service.name}(£${order.service.price}) from ${shopDetails.name}',
                "id": DateTime.now().millisecondsSinceEpoch.toString(),
                "read": false,
                "image": user.imageUrl,
                "time": DateTime.now().millisecondsSinceEpoch.toString(),
                "sound": "default"
              };

              _databaseApi.postNotificationCollection(
                  shopDetails.ownerId, postMap);
            }
            isApiLoading = false;
            notifyListeners();
            await _dialogService.showCustomDialog(
              variant: AlertType.success,
              title: 'Service Completed',
              description: 'Thank you for using our service',
            );
            _navigationService.back();
          });
        });
      } catch (exception) {
        isApiLoading = false;
        notifyListeners();
        _dialogService.showCustomDialog(
            variant: AlertType.error,
            title: 'Error',
            description: exception.toString());
      }
    }
  }

  Future handleMakeCancel(Order order) async {
    final dialogResponse = await _dialogService.showConfirmationDialog(
      title: 'Are you sure?',
      confirmationTitle: 'Cancel appointment',
      cancelTitle: 'Close',
    );

    if (dialogResponse?.confirmed ?? false) {
      isApiLoading = true;
      notifyListeners();
      final accessToken = await _paypalApi.getAccessToken();
      final response;
      if (order.paymentMethod == MPaymentMethod.paypal) {
        response = await _paypalApi.refundPayment(order, accessToken!);
      } else {
        response = await _stripeApi.refundPayment(order);
      }
      if (response['statusCode'] == 201 || response['id'] != null) {
        _databaseApi
            .cancelOrder(order, DateTime.now().microsecondsSinceEpoch)
            .then((value) async {
          var token;
          if (user.id == order.service.ownerId) {
            token = await _databaseApi.getToken(order.userId);
          } else {
            token = await _databaseApi.getToken(order.service.ownerId);
          }

          if (token != null) {
            Shop shopDetails = await _databaseApi.getShop(order.service.shopId);
            String body;
            if (user.id == order.service.ownerId) {
              body =
                  '${shopDetails.name} has cancelled ${order.service.name}(£${order.service.price})';
            } else {
              body =
                  '${order.name} has cancelled ${order.service.name}(£${order.service.price}) from ${shopDetails.name}';
            }
            var test = _databaseApi.postNotification(
                orderID: order.orderId,
                title: 'Booking has been cancelled',
                body: body,
                forRole: 'order',
                userID: '',
                receiverToken: token.toString());

            Map<String, dynamic> postMap = {
              "userId": user.id,
              "orderID": order.orderId,
              "title": 'Booking has been cancelled',
              "body": body,
              "id": DateTime.now().millisecondsSinceEpoch.toString(),
              "read": false,
              "image": user.imageUrl,
              "time": DateTime.now().millisecondsSinceEpoch.toString(),
              "sound": "default"
            };

            _databaseApi.postNotificationCollection(order.userId, postMap);
          }
          isApiLoading = false;
          await _dialogService.showCustomDialog(
              variant: AlertType.success,
              title: 'Success',
              description: 'Booking is cancelled.');
          _navigationService.back();
        }, onError: (exception) {
          isApiLoading = false;
          notifyListeners();
          _dialogService.showCustomDialog(
              variant: AlertType.error,
              title: 'Error',
              description: exception.toString());
        });
      }
    }
  }

  Future handleCancelNoRefund(Order order) async {
    final dialogResponse = await _dialogService.showConfirmationDialog(
      title: 'Are you sure?',
      confirmationTitle: 'Cancel appointment',
      cancelTitle: 'Close',
    );

    if (dialogResponse?.confirmed ?? false) {
      isApiLoading = true;
      notifyListeners();
      _databaseApi
          .cancelOrder(order, DateTime.now().microsecondsSinceEpoch)
          .then((value) async {
        var token;
        if (user.id == order.service.ownerId) {
          token = await _databaseApi.getToken(order.userId);
        } else {
          token = await _databaseApi.getToken(order.service.ownerId);
        }

        if (token != null) {
          Shop shopDetails = await _databaseApi.getShop(order.service.shopId);
          String body;
          if (user.id == order.service.ownerId) {
            body =
                '${shopDetails.name} has cancelled ${order.service.name}(£${order.service.price})';
          } else {
            body =
                '${order.name} has cancelled ${order.service.name}(£${order.service.price}) from ${shopDetails.name}';
          }
          var test = _databaseApi.postNotification(
              orderID: order.orderId,
              title: 'Booking has been cancelled',
              body: body,
              forRole: 'order',
              userID: '',
              receiverToken: token.toString());

          Map<String, dynamic> postMap = {
            "userId": user.id,
            "orderID": order.orderId,
            "title": 'Booking has been cancelled',
            "body": body,
            "id": DateTime.now().millisecondsSinceEpoch.toString(),
            "read": false,
            "image": user.imageUrl,
            "time": DateTime.now().millisecondsSinceEpoch.toString(),
            "sound": "default"
          };

          _databaseApi.postNotificationCollection(order.userId, postMap);
        }
        isApiLoading = false;
        await _dialogService.showCustomDialog(
            variant: AlertType.success,
            title: 'Success',
            description: 'Booking is cancelled.');
        _navigationService.back();
      }, onError: (exception) {
        isApiLoading = false;
        notifyListeners();
        _dialogService.showCustomDialog(
            variant: AlertType.error,
            title: 'Error',
            description: exception.toString());
      });
    }
  }

  Future handleApproveAppointment(Order order) async {
    isApiLoading = true;
    notifyListeners();
    final shopDetails = await _databaseApi.getShop(order.shopId);

    final response;
    if (order.paymentMethod == MPaymentMethod.paypal) {
      final paypalEmail =
          await _databaseApi.getSellerPaypal(shopDetails.ownerId);
      final accessToken = await _paypalApi.getAccessToken();
      response = await _paypalApi.paySellerPayment(
          paypalEmail.toString(), order, processingFee, accessToken!);
    } else {
      final account = await _databaseApi.getSellerStripe(order.service.ownerId);
      response =
          await _stripeApi.paySellerPayment(order, processingFee, account);
    }

    if (response['statusCode'] == 201 || response['id'] != null) {
      return _databaseApi
          .approveAppointment(order, DateTime.now().microsecondsSinceEpoch)
          .then((value) async {
        var token = await _databaseApi.getToken(order.userId);
        if (token != null) {
          Shop shopDetails = await _databaseApi.getShop(order.service.shopId);
          var test = _databaseApi.postNotification(
              orderID: order.orderId,
              title: 'Appointment Approved',
              body:
                  'Your appointment of ${order.service.name}(£${order.service.price}) has been approved by ${shopDetails.name}',
              forRole: 'order',
              userID: '',
              receiverToken: token.toString());

          Map<String, dynamic> postMap = {
            "userId": user.id,
            "orderID": order.orderId,
            "title": 'Appointment Approved',
            "body":
                'Your appointment of ${order.service.name}(£${order.service.price}) has been approved by ${shopDetails.name}',
            "id": DateTime.now().millisecondsSinceEpoch.toString(),
            "read": false,
            "image": user.imageUrl,
            "time": DateTime.now().millisecondsSinceEpoch.toString(),
            "sound": "default"
          };
          Map<String, dynamic> mpostMap = {
            "userId": user.id,
            "orderID": order.orderId,
            "title": 'Appointment Approved',
            "body":
                'You Approved ${order.service.name}(£${order.service.price}), you have received deposit amount',
            "id": DateTime.now().millisecondsSinceEpoch.toString(),
            "read": false,
            "image": user.imageUrl,
            "time": DateTime.now().millisecondsSinceEpoch.toString(),
            "sound": "default"
          };
          _databaseApi.updateBooking(order.bookkingId!);
          _databaseApi.postNotificationCollection(order.userId, postMap);
          _databaseApi.postNotificationCollection(
              order.service.ownerId, mpostMap);
        }
        isApiLoading = false;
        await _dialogService.showCustomDialog(
            variant: AlertType.success,
            title: 'Success',
            description: 'Appointment is approved.');
        _navigationService.back();
      }, onError: (exception) {
        isApiLoading = false;
        notifyListeners();
        _dialogService.showCustomDialog(
            variant: AlertType.error,
            title: 'Error',
            description: exception.toString());
      });
    }
  }

  Future handleMakeCompleted(Order order) async {
    isApiLoading = true;
    notifyListeners();
    _databaseApi
        .completeOrder(order, DateTime.now().microsecondsSinceEpoch)
        .then((value) async {
      _databaseApi
          .updateTotalSaleCount(order.service.ownerId)
          .then((value) async {
        isApiLoading = false;
        await _dialogService.showCustomDialog(
            variant: AlertType.success,
            title: 'Success',
            description: 'Order is completed.');
        _navigationService.back();
      });
    }, onError: (exception) {
      isApiLoading = false;
      notifyListeners();
      _dialogService.showCustomDialog(
          variant: AlertType.error,
          title: 'Error',
          description: exception.toString());
    });
  }

  Future<void> setRating(Order order) async {
    if (rating == 0) {
      Fluttertoast.showToast(
          msg: "Choose stars first",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      isRatingLoading = true;
      notifyListeners();
      final shopDetails = await _databaseApi.getShop(order.shopId);
      double previousRating = shopDetails.rating;
      int totalRatings = shopDetails.ratingCount;
      double newRating = 0.0;
      if (totalRatings == 0) {
        totalRatings += 1;
        newRating =
            double.parse(((previousRating + rating) / 1).toStringAsFixed(1));
      } else {
        totalRatings += 1;
        newRating =
            double.parse(((previousRating + rating) / 2).toStringAsFixed(1));
      }
      await _databaseApi.rateOrder(int.parse(rating.toStringAsFixed(0)), order);
      _databaseApi.rateShop(newRating, totalRatings, order).then((value) async {
        ///Rating notification
        var token = await _databaseApi.getToken(order.service.ownerId);
        if (token != null) {
          var test = _databaseApi.postNotification(
              orderID: order.orderId,
              title: 'New Review',
              body: '${order.name} rated your service',
              forRole: 'order',
              userID: '',
              receiverToken: token.toString());

          // Map<String, dynamic> postMap = {
          //   "userId": user.id,
          //   "orderID": order.orderId,
          //   "title": 'New Review',
          //   "body": '${order.name} rated your service',
          //   "id": DateTime.now().millisecondsSinceEpoch.toString(),
          //   "read": false,
          //   "image": user.imageUrl,
          //   "time": DateTime.now().millisecondsSinceEpoch.toString(),
          //   "sound": "default"
          // };
          //
          // _databaseApi.postNotificationCollection(shopDetails.ownerId, postMap);
        }
        isRatingLoading = false;
        notifyListeners();
        await _dialogService.showCustomDialog(
            variant: AlertType.success,
            title: 'Success',
            description: 'Rated Successfully');
        _navigationService.back();
      }, onError: (exception) {
        isApiLoading = false;
        notifyListeners();
        _dialogService.showCustomDialog(
            variant: AlertType.error,
            title: 'Error',
            description: exception.toString());
      });
    }
  }

  Future handleRateMyApp() async {
    final dialogResponse = await _dialogService.showConfirmationDialog(
      title: 'Do you want to rate?',
      confirmationTitle: 'Rate',
      cancelTitle: 'Cancel',
    );
    if (dialogResponse?.confirmed ?? false) {}
  }
}
