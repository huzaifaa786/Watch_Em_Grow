import 'dart:async';
import 'dart:developer';

import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mipromo/api/database_api.dart';
import 'package:mipromo/api/storage_api.dart';
import 'package:mipromo/app/app.locator.dart';
import 'package:mipromo/app/app.router.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/models/order.dart';
import 'package:mipromo/models/shop.dart';
import 'package:mipromo/models/shop_service.dart';
import 'package:mipromo/services/user_service.dart';
import 'package:mipromo/ui/shared/helpers/data_models.dart';
import 'package:mipromo/ui/shared/helpers/enums.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:video_player/video_player.dart';

class ServiceViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _databaseApi = locator<DatabaseApi>();
  final _storageApi = locator<StorageApi>();
  final _userService = locator<UserService>();

  late ShopService service;
  late Shop shop;
  late AppUser shopowner;

  int? selectedSize;
  int selectedSizeIndex = -1;
  bool isApiRunning = false;
  String? username;
 
  double aspectRatio = 1;
  double imageRatio = 1;
  bool isMuted = false;

  PageController viewController = PageController();
  int selectedIndex = 0;
  List imagesCount = [];

  void getSelectedSize(int size) {
    selectedSize = size;
    notifyListeners();
  }

  late AppUser user;



  Future<void> init(ShopService cService) async {
    setBusy(true);

    viewController.addListener(() {
      if (viewController.page!.round() != selectedIndex) {
        selectedIndex = viewController.page!.round();
        notifyListeners();
        return;
      }
    });

    await _userService.syncUser();
    user = _userService.currentUser;
    service = cService;
    if (service.ownerId != null) {
      await getshopservice(service);
    }
    if (service.shopId != null) {
      await getshop(service);
    }
    if (service.imageUrl1 != null) {
      imagesCount.add(true);
    }
    if (service.imageUrl2 != null) {
      imagesCount.add(true);
    }
    if (service.imageUrl3 != null) {
      imagesCount.add(true);
    }
    if (service.videoUrl != null) {
      imagesCount.add(true);
    }
    // if(imagesCount.length < 2){
    //   imagesCount.clear();
    // }
    notifyListeners();
    
    setBusy(false);
  }

  

  Future navigateToBuyServiceView() async {
   
    if (await _navigationService.navigateTo(Routes.inputAddressView) == true) {
      await _navigationService.replaceWith(
        Routes.buyServiceView,
        arguments: BuyServiceViewArguments(
          user: user,
          service: service,
          selectedSize: selectedSize,
        ),
      );
    }
  }

  onSizeSelected(int index) {
    selectedSizeIndex = index;
    selectedSize = index;
    notifyListeners();
  }

  getshopservice(ShopService index) async {
    await _databaseApi.getUser(index.ownerId).then((Shopdata) => shopowner = Shopdata);
    notifyListeners();
  }

  getshop(ShopService index) async {
    shop = await _databaseApi.getShop(index.shopId);
    notifyListeners();
  }

  Future<void> updateChat(String receiverId) async {
    isApiRunning = true;
    notifyListeners();
    await init(service).whenComplete(
      () async {
        await _databaseApi.getUser(receiverId).then((receiver) {
          isApiRunning = false;
          notifyListeners();
          _navigationService.replaceWith(
            Routes.messagesView,
            arguments: MessagesViewArguments(
              currentUser: user,
              receiver: receiver,
            ),
          );
        });
      },
    );

    /*await _databaseApi
        .updateChatIds(
      userId: user.id,
      receiverId: receiverId,
    )
        .whenComplete(
          () async {
        await init(service).whenComplete(
              () async {
                await _databaseApi
                    .getUser(receiverId).then((receiver){
                  isApiRunning = false;
                  notifyListeners();
                  _navigationService.navigateTo(
                    Routes.messagesView,
                    arguments: MessagesViewArguments(
                      currentUser: user,
                      receiver: receiver,
                    ),
                  );
                });
          },
        );
      },
    );*/

    /*await _databaseApi
        .updateChatIds(
      userId: user.id,
      recieverId: recieverId,
    )
        .whenComplete(
      () async {
        await init(service).whenComplete(
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
    );*/
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

  Future showBookConfirmationDialog() async {}

  Future bookService() async {
    final dialogResponse = await _dialogService.showConfirmationDialog(
      title: 'Have you arranged a date?',
      description: 'By booking a visit you agree to the processing of your personal data',
      confirmationTitle: 'Arrange Date',
      cancelTitle: 'Close',
    );

    if (dialogResponse?.confirmed ?? false) {
      // if (await _navigationService.navigateTo(Routes.inputAddressView) == true) {
      await _navigationService.replaceWith(
        Routes.bookingView,
        arguments: BookingViewArguments(
          user: user,
          service: service,
        ),
      );
      // }

      /*final timeNow = DateTime.now();
      final String orderId = timeNow.microsecondsSinceEpoch.toString();
      final order = Order(
        type: OrderType.service,
        orderId: orderId,
        shopId: service.shopId,
        service: service,
        userId: user.id,
        status: OrderStatus.bookRequested,
        time: timeNow.microsecondsSinceEpoch,
      );
      isApiRunning = true;
      notifyListeners();
      _databaseApi.createOrder(order).then((value) async {
        isApiRunning = false;
        notifyListeners();
        final response = await _dialogService.showConfirmationDialog(
          title: 'Success',
          description: 'You are waiting for approval from seller.',
          confirmationTitle: 'View Order',
          cancelTitle: 'Close',
        );
        if (response?.confirmed ?? false) {
          _navigationService.back();
          navigateToOrderDetailView(order);
        } else {
          _navigationService.back();
        }
      }, onError: (error) async {
        isApiRunning = false;
        notifyListeners();
        await _dialogService.showCustomDialog(
          variant: AlertType.error,
          title: 'Request failed',
          description: error.toString(),
        );
        _navigationService.back();
      });*/
    }
  }

  Future<void> isBuyServiceFormValidate() async {
    if (selectedSize == null) {
      await _dialogService.showCustomDialog(
        variant: AlertType.error,
        title: 'Size not selected',
        description: 'Please select a size',
      );
    } else {
      navigateToBuyServiceView();
    }
  }

  Future<void> deleteService(ShopService service) async {
    final response = await _dialogService.showCustomDialog(
      variant: AlertType.error,
      mainButtonTitle: 'Delete',
      barrierDismissible: true,
      barrierLabel: 'delete',
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

  Future<void> navigateToDirectChatView(String receiverId) async {
    isApiRunning = true;
    notifyListeners();
    await _databaseApi.getUser(receiverId).then((receiver) {
      isApiRunning = false;
      notifyListeners();
      _navigationService.replaceWith(
        Routes.messagesView,
        arguments: MessagesViewArguments(
          currentUser: user,
          receiver: receiver,
        ),
      );
    });
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


}
