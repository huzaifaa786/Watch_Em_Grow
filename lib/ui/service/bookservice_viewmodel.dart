import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:mipromo/api/database_api.dart';
import 'package:mipromo/app/app.router.dart';
import 'package:mipromo/api/paypal_api.dart';
import 'package:mipromo/app/app.locator.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/models/order.dart';
import 'package:mipromo/models/shop.dart';
import 'package:mipromo/models/shop_service.dart';
import 'package:mipromo/ui/shared/helpers/enums.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;

class BookServiceViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _databaseApi = locator<DatabaseApi>();
  final _paypalApi = locator<PaypalApi>();
  final _dialogService = locator<DialogService>();

  String? accessToken;
  String? checkoutUrl;
  String? executeUrl;
  String? paymentId;
  bool isWebviewLoading = true;

  final AppUser user;
  //final Order order;
  final ShopService service;

  BookServiceViewModel(this.user, this.service);
  void init() {
    setBusy(true);
    Future.delayed(Duration.zero, () async {
      try {
        accessToken = await _paypalApi.getAccessToken();
        if (accessToken != null) {
          final transactions = getOrderParams();
          final res = await _paypalApi.createPaypalPayment(transactions, accessToken!);
          if (res != null) {
            checkoutUrl = res["approvalUrl"];
            executeUrl = res["executeUrl"];
            paymentId = res['id'];
          }
          notifyListeners();
          setBusy(false);
        }
      } catch (e) {
        _dialogService.showCustomDialog(variant: AlertType.error, title: 'Error', description: e.toString());
      }
    });
  }

  Future navigateToOrderDetailView(Order order) async {
    final shopId = order.service.shopId;
    if (shopId.isNotEmpty) {
      _databaseApi.getShop(shopId).then((shopData) {
        _navigationService.navigateTo(
          Routes.orderDetailView,
          arguments: OrderDetailViewArguments(
            order: order,
            color: shopData.color,
            currentUser: user,
            fontStyle: shopData.fontStyle,
          ),
        );
      });
    }
  }

  NavigationDecision handleWebViewUrlAService(NavigationRequest request) {
    if (request.url.contains(PaypalApi.returnURL)) {
      final uri = Uri.parse(request.url);
      final payerID = uri.queryParameters['PayerID'];
      if (payerID != null) {
        _paypalApi.capturePayment(paymentId!, accessToken!).then((response) async {
          if (response['statusCode'] != 201) {
            _dialogService.showCustomDialog(
              variant: AlertType.error,
              title: response['message'] as String,
            );
            return;
          }
          final capture = response['purchase_units'][0]['payments']['captures'][0];

          final String captureId = capture['id'] as String;
          final String timeString = capture['update_time'] as String;
          final String orderId = DateTime.now().microsecondsSinceEpoch.toString();
          final order = Order(
            type: OrderType.service,
            orderId: orderId,
            paymentId: paymentId,
            shopId: service.shopId,
            captureId: captureId,
            service: service,
            userId: user.id,
            status: OrderStatus.bookRequested,
            rate: 0,
            name: user.fullName,
            address: user.address,
            postCode: user.postCode,
            time: DateTime.parse(timeString).microsecondsSinceEpoch,
          );
          _databaseApi.createOrder(order).then((value) async {
            var token = await _databaseApi.getToken(order.service.ownerId);
            if (token != null) {
              Shop shopDetails = await _databaseApi.getShop(order.service.shopId);
              var test = _databaseApi.postNotification(
                  orderID: order.orderId,
                  title: 'New Booking',
                  body:
                      '${order.name} has booked ${order.service.name}(£${order.service.price}) from ${shopDetails.name}',
                  forRole: 'order',
                  userID: '',
                  receiverToken: token.toString());

              Map<String, dynamic> postMap = {
                "userId": user.id,
                "orderID": order.orderId,
                "title": 'New Booking',
                "body": '${order.name} has booked ${order.service.name}(£${order.service.price})',
                "id": DateTime.now().millisecondsSinceEpoch.toString(),
                "read": false,
                "image": user.imageUrl,
                "time": DateTime.now().millisecondsSinceEpoch.toString(),
                "sound": "default"
              };

              _databaseApi.postNotificationCollection(shopDetails.ownerId, postMap);
            }

            if (await _navigationService.navigateTo(Routes.orderSuccessView) == true) {
              _navigationService.back();
              _navigationService.back();
              navigateToOrderDetailView(order);
            } else {
              _navigationService.back();
              _navigationService.back();
            }

            /*final response = await _dialogService.showConfirmationDialog(
              title: 'Success',
              description:
                  'Thank you\nWe’ll keep your funds safe until you’ve confirmed that you have received the service',
              confirmationTitle: 'View Order',
              cancelTitle: 'Close',
            );
            if (response?.confirmed ?? false) {
              _navigationService.back();
              _navigationService.back();
              navigateToOrderDetailView(order);
            } else {
              _navigationService.back();
              _navigationService.back();
            }*/
          }, onError: (error) async {
            await _dialogService.showCustomDialog(
              variant: AlertType.error,
              title: 'Payment failed',
              description: error.toString(),
            );
            _navigationService.back();
          });

          /*final shopDetails = await _databaseApi.getShop(order.shopId);
          final paypalEmail = await _databaseApi.getSellerPaypal(shopDetails.ownerId);
          print(paypalEmail.toString());
          final accessToken = await _paypalApi.getAccessToken();
          final response2 = await _paypalApi.paySellerPayment(paypalEmail.toString(), order, accessToken!);
          if (response2['statusCode'] == 201) {
            _databaseApi
                .completeOrder(order,
                DateTime.parse(timeString).microsecondsSinceEpoch)
                .then((value) async {
              final response = await _dialogService.showConfirmationDialog(
                title: 'Success',
                description: 'Payment is completed.',
                confirmationTitle: 'View Order',
                cancelTitle: 'Close',
              );
              if (response?.confirmed ?? false) {
                _navigationService.back();
                _navigationService.back();
                navigateToOrderDetailView(order);
              } else {
                _navigationService.back();
                _navigationService.back();
              }
            });
          }else{
            await _dialogService.showCustomDialog(
              variant: AlertType.error,
              title: 'Payment failed',
              description: error.toString(),
            );
          }*/

          /*_databaseApi
              .completeOrder(order,
              DateTime.parse(timeString).microsecondsSinceEpoch)
              .then((value) async {
            final response = await _dialogService.showConfirmationDialog(
              title: 'Success',
              description: 'Payment is completed.',
              confirmationTitle: 'View Order',
              cancelTitle: 'Close',
            );
            if (response?.confirmed ?? false) {
              _navigationService.back();
              _navigationService.back();
              navigateToOrderDetailView(order);
            } else {
              _navigationService.back();
              _navigationService.back();
            }
          }, onError: (error) async {
            await _dialogService.showCustomDialog(
              variant: AlertType.error,
              title: 'Payment failed',
              description: error.toString(),
            );
            _navigationService.back();
          });*/
        });
      } else {
        _navigationService.back();
      }
    } else if (request.url.contains(PaypalApi.cancelURL)) {
      _navigationService.back();
    }
    return NavigationDecision.navigate;
  }

  Map<String, dynamic> getOrderParams() {
    final Map<String, dynamic> temp = {
      "intent": "CAPTURE",
      // "payer": {"payment_method": "paypal"},
      'purchase_units': [
        {
          'amount': {'value': service.price.toString(), 'currency_code': 'GBP'}
        }
      ],
      'application_context': {
        'return_url': PaypalApi.returnURL,
        'cancel_url': PaypalApi.cancelURL,
      }
    };
    return temp;
  }

  void setIsWebviewLoading({required bool loading}) {
    isWebviewLoading = loading;
    notifyListeners();
  }


  //////////////////Stripe Payment///////////////////////////
  
// Future<Map<String, dynamic>> _createTestPaymentSheet() async {
//     final url = Uri.parse('http://attn.tritec.store/api/create/intent');
//     final response = await http.post(
//       url,
//       headers: {
//         'Content-Type': 'application/json',
//       },
//       body: json.encode({
//         'a': 'a',
//         'price' :'100'
//       }),
//     );
//     final body = json.decode(response.body);

//     // if (body['error'] != null) {
//     //   throw Exception(body['error']);
//     // }
//     print(body);
//     // return body['intent'];
//   }

  // Future<void> initPaymentSheet() async {
  //   try {
  //     // 1. create payment intent on the server
  //     final data = await _createTestPaymentSheet();

  //     // create some billingdetails
  //     final billingDetails = BillingDetails(
  //       name: 'Flutter Stripe',
  //       email: 'email@stripe.com',
  //       phone: '+48888000888',
  //       address: Address(
  //         city: 'Houston',
  //         country: 'US',
  //         line1: '1459  Circle Drive',
  //         line2: '',
  //         state: 'Texas',
  //         postalCode: '77063',
  //       ),
  //     ); // mocked data for tests

  //     // 2. initialize the payment sheet
  //     await Stripe.instance.initPaymentSheet(
  //       paymentSheetParameters: SetupPaymentSheetParameters(
  //         // Main params
  //         // paymentIntentClientSecret: data['client_secret'],
  //         merchantDisplayName: 'Flutter Stripe Store Demo',
  //         // Customer params
  //         // customerId: data['customer'],
  //         // customerEphemeralKeySecret: data['ephemeralKey'],
  //         // Extra params
  //         applePay: true,
  //         googlePay: true,
  //         style: ThemeMode.dark,
  //         // billingDetails: billingDetails,
  //         testEnv: true,
  //         merchantCountryCode: 'DE',
  //       ),
  //     );
  //     // setState(() {
  //     //   step = 1;
  //     // });
  //   } catch (e) {
  //     // ScaffoldMessenger.of(context).showSnackBar(
  //     //   SnackBar(content: Text('Error: $e')),
  //     // );
  //     rethrow;
  //   }
  // }

  Future<void> confirmPayment() async {
    print("Asdfasdfsdfasfd");
    try {
      // 3. display the payment sheet.
      await Stripe.instance.presentPaymentSheet();

      // setState(() {
      //   step = 0;
      // });

      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text('Payment succesfully completed'),
      //   ),
      // );
    } on Exception catch (e) {
      if (e is StripeException) {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Error from Stripe: ${e.error.localizedMessage}'),
        //   ),
        // );
      } else {
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text('Unforeseen error: ${e}'),
        //   ),
        // );
      }
    }
  }

 


}
