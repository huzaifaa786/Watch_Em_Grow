import 'dart:async';
import 'dart:io' show Platform;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mipromo/models/order.dart';
import 'package:mipromo/ui/shared/helpers/enums.dart';
import 'package:mipromo/api/database_api.dart';
import 'package:mipromo/app/app.locator.dart';
import 'package:mipromo/app/app.router.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/services/user_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../app/app.locator.dart';

class MainViewModel extends BaseViewModel {
  final _databaseApi = locator<DatabaseApi>();
  final _userService = locator<UserService>();
  final _dialogService = locator<DialogService>();
  final _navigationService = locator<NavigationService>();
  List<Notification> notifications = [];
  late final StreamSubscription<List<Notification>> _notificationsSubscription;
  late PageController pageController;
  late AppUser _currentUser;
  AppUser get currentUser => _currentUser;
  int badgeCnt = 0;
  int chatCount = 0;
  int currentIndex = 0;
  int firstIndex = 0;
  bool showOnce = true;

  Future navigateToOrderDetailView(Order order) async {
    final shopId = order.service.shopId;
    if (shopId.isNotEmpty) {
      _databaseApi.getShop(shopId).then((shopData) {
        _navigationService.navigateTo(Routes.orderDetailView,
            arguments: OrderDetailViewArguments(
                order: order, color: shopData.color, currentUser: _currentUser, fontStyle: shopData.fontStyle));
      });
    }
  }

  Future<void> navigateToMessagesView(
    AppUser currentUser,
    AppUser receiver,
  ) async {
    await _navigationService.navigateTo(
      Routes.messagesView,
      arguments: MessagesViewArguments(
        currentUser: currentUser,
        receiver: receiver,
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

  Future onDidReceiveLocalNotification(int id, String? title, String? body, String? payload) async {
    onNavigationIconTap(2);
    pageController.jumpToPage(2);
  }

  Future selectNotification(String? payload) async {
    if (payload != null && payload.isNotEmpty) {
      String temp = payload.substring(1, payload.length - 1);
      print(temp);
      var dataSp = temp.split(',');
      Map<String, String> mapData = Map();
      dataSp.forEach((element) => mapData.addAll({
            element.split(':')[0].trim(): element.split(':')[1].trim()
          })); //mapData[element.split(':')[0]] = element.split(':')[1]);
      print(mapData['forRole']);
      print(mapData['userID'].toString());
      if (mapData['forRole'] == 'order') {
        _databaseApi.getOrder(mapData['orderId']!).then((order) => navigateToOrderDetailView(order));
      } else if (mapData['forRole'] == 'message') {
        final result = await _userService.syncUser();
        notifyListeners();
        _databaseApi.getUser(mapData['userID']!).then((receiver) async {
          navigateToMessagesView(currentUser, receiver);
        });
      } else if (mapData['forRole'] == 'follow') {
        final result = await _userService.syncUser();
        notifyListeners();
        _databaseApi.getUser(mapData['userID']!).then((user) async {
          if (user.shopId.isEmpty) {
            navigateToBuyerView(owner: user);
          } else {
            navigateToShopView(user);
          }
        });
      } else {
        print("shop/user not found!!!!!!!!!");
      }
    }
  }

  Future<void> notificationInit() async {
    final FirebaseMessaging messaging = FirebaseMessaging.instance;
    final NotificationSettings settings = await messaging.requestPermission();
    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      await _dialogService.showCustomDialog(
        variant: AlertType.warning,
        title: 'Notification permission denied',
      );
    }
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
    final RemoteMessage? initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) {
      //final orderId = initialMessage.data['orderId'] as String?;
      //selectNotification(orderId);
    }
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      //final orderId = message.data['orderId'] as String?;
      selectNotification(message.data.toString());
    });
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_notification');
    final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: selectNotification);

    if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.max, priority: Priority.high, showWhen: false);
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      final RemoteNotification? notification = message.notification;
      final AndroidNotification? android = message.notification?.android;

      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      if (notification != null && android != null) {
        if (Platform.isAndroid) {
          await flutterLocalNotificationsPlugin.show(0, notification.title, notification.body, platformChannelSpecifics,
              //payload: message.data['orderId'].toString()
              payload: message.data.toString());
        }
      }
      FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
        final RemoteNotification? notification = message.notification;
        final AndroidNotification? android = message.notification?.android;

        // If `onMessage` is triggered with a notification, construct our own
        // local notification to show to users using the created channel.
        if (notification != null && android != null) {
          if (Platform.isAndroid) {
            await flutterLocalNotificationsPlugin.show(
                0, notification.title, notification.body, platformChannelSpecifics,
                //payload: message.data['orderId'].toString()
                payload: message.data.toString());
          }
        }
      });
    });
  }

  void onNavigationIconTap(int index) {
    currentIndex = index;
    notifyListeners();
  }

  void changeFirstIndex() {
    firstIndex = 0;
    notifyListeners();
  }

  Future<void> changeShowOnce() async {
    showOnce = false;
    notifyListeners();
  }

  Future<void> init(int index) async {
    setBusy(true);
    notificationInit();

    await _userService.updateToken();
    final result = await _userService.syncUser();
    if (!result) {
      _navigationService.replaceWith(Routes.landingView);
      return;
    }
    _databaseApi.listenUser(_userService.currentUser.id).listen(
      (user) {
        _currentUser = user;
        notifyListeners();
        setBusy(false);
      },
    );
    if (index == 3) {
      onNavigationIconTap(3);
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        pageController.jumpToPage(3);
      });
    }

    _databaseApi.listenNewNotifications(_userService.currentUser.id).listen((notifications) {
      badgeCnt = notifications.where((element) => element.read == 'false').length;
      print('notifications************************');
      print(notifications[16].body);
      print(notifications[0].body);
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _notificationsSubscription.cancel();
    super.dispose();
  }
}
