import 'dart:async';

import 'package:mipromo/api/database_api.dart';
import 'package:mipromo/app/app.locator.dart';
import 'package:mipromo/app/app.router.dart';
import 'package:mipromo/models/follow.dart';
import 'package:mipromo/models/shop.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/models/notification.dart';
import 'package:mipromo/models/order.dart';
import 'package:mipromo/services/user_service.dart';
import 'package:mipromo/ui/notifications/notification_model.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class NotificationsViewModel extends BaseViewModel {
  final _databaseApi = locator<DatabaseApi>();
  final _navigationService = locator<NavigationService>();
  final _userService = locator<UserService>();
  List<Notification> notifications = [];
  List<NotificationModel> newNotifications = [];

  List<String> currentfollowingIds = [];
  bool unfollowed = false;
  late StreamSubscription<List<Follow>> _followSubscription;

  late final StreamSubscription<List<Notification>> _notificationsSubscription;
  late final StreamSubscription<List<NotificationModel>> _newNotificationsSubscription;

  List<AppUser> users = [];
  List<Order> orders = [];
  List<Follow> followings = [];
  List<bool> isFollowing = [];

  late AppUser currentUser;
  bool isLoading = false;

  Future<void> init(String userId) async {
    setBusy(true);
    await _userService.syncUser();
    currentUser = _userService.currentUser;
    notifyListeners();
    followings = await _databaseApi.getFollowing(currentUser.id);
    _newNotificationsSubscription = _databaseApi.listenNewNotifications(userId).listen((notifications) {
      newNotifications = notifications;
      
      isFollowing = List.filled(newNotifications.length, false);

      for (int i = 0; i < newNotifications.length; i++) {
        if (newNotifications[i].orderID == 'null') {
          for (int j = 0; j < followings.length; j++) {
            if (newNotifications[i].userId == followings[j].id) {
              isFollowing[i] = true;
            }
          }
        }
      }
      notifyListeners();
      setBusy(false);
    });

    if (currentUser.id.isNotEmpty) {
      _followSubscription = _databaseApi.listenFollowings(currentUser.id).listen(
        (f) {
          currentfollowingIds = f.map((e) => e.id).toList();
          notifyListeners();
        },
      );
    }
    /*_notificationsSubscription =
        _databaseApi.listenNotifications(userId).listen((notifications) {
      this.notifications = notifications;
      // getData();
      setBusy(false);
      notifyListeners();
    });*/
  }

  getMyFollowing() async {
    followings.clear();
    followings = await _databaseApi.getFollowing(currentUser.id);
    notifyListeners();
  }

  bool checkFollowing(String userId, int index) {
    bool isFollowing = false;
    for (var item in followings) {
      if (item.id == userId) {
        isFollowing = true;
      }
    }
    return isFollowing;
  }

  navigateTo(String userId, int index) async {
    isLoading = true;
    notifyListeners();
    AppUser user = await _databaseApi.getUser(userId);
    if (user.shopId.isNotEmpty) {
      toSellerProfile(user, index);
    } else {
      toBuyerProfile(user);
    }
  }

  navigateToOrder(String orderId) async {
    isLoading = true;
    notifyListeners();
    Order orderDetail = await _databaseApi.getOrder(orderId);
    if (orderDetail != null) {
      navigateToOrderDetailView(orderDetail);
    }
  }

  Future<void> toSellerProfile(AppUser receiver, int index) async {
    isLoading = false;
    notifyListeners();
    if (await _navigationService.navigateTo(
          Routes.sellerProfileView,
          arguments: SellerProfileViewArguments(
            seller: receiver,
          ),
        ) ==
        true) {
      for (int i = 0; i < newNotifications.length; i++) {
        if (newNotifications[i].orderID == 'null') {
          for (int j = 0; j < followings.length; j++) {
            if (newNotifications[i].userId == followings[j].id) {
              isFollowing[i] = true;
            }
          }
        }
      }

      // isFollowing[index] = true;
    } else {
      for (int i = 0; i < newNotifications.length; i++) {
        if (newNotifications[i].orderID == 'null') {
          for (int j = 0; j < followings.length; j++) {
            if (newNotifications[i].userId == followings[j].id) {
              isFollowing[i] = false;
            }
          }
        }
      }
      // isFollowing[index] = false;
    }
    notifyListeners();
  }

  Future<void> toBuyerProfile(AppUser receiver) async {
    isLoading = false;
    notifyListeners();
    if (await _navigationService.navigateTo(
          Routes.buyerProfileView,
          arguments: BuyerProfileViewArguments(user: receiver),
        ) ==
        true) {
      for (int i = 0; i < newNotifications.length; i++) {
        if (newNotifications[i].orderID == 'null') {
          for (int j = 0; j < followings.length; j++) {
            if (newNotifications[i].userId == followings[j].id) {
              isFollowing[i] = true;
            }
          }
        }
      }
    } else {
      for (int i = 0; i < newNotifications.length; i++) {
        if (newNotifications[i].orderID == 'null') {
          for (int j = 0; j < followings.length; j++) {
            if (newNotifications[i].userId == followings[j].id) {
              isFollowing[i] = false;
            }
          }
        }
      }
    }
    notifyListeners();
  }

  Future navigateToOrderDetailView(Order order) async {
    final shopId = order.service.shopId;
    if (shopId.isNotEmpty) {
      _databaseApi.getShop(shopId).then((shopData) {
        isLoading = false;
        notifyListeners();
        _navigationService.navigateTo(Routes.orderDetailView,
            arguments: OrderDetailViewArguments(
                order: order, color: shopData.color, currentUser: currentUser, fontStyle: shopData.fontStyle));
      });
    }
  }

  Future<void> follow(String sellerId, int index) async {
    isLoading = true;
    notifyListeners();
    await _databaseApi
        .follow(
      currentUserId: currentUser.id,
      userId: sellerId,
    )
        .whenComplete(() async {
      var user = await _databaseApi.getUser(sellerId);
      if (user != null) {
        Map<String, dynamic> postMap = {
          "userId": currentUser.id,
          "title": 'New follower',
          "body": '${currentUser.username} followed you',
          "id": DateTime.now().millisecondsSinceEpoch.toString(),
          "read": false,
          "image": currentUser.imageUrl,
          "time": DateTime.now().millisecondsSinceEpoch.toString(),
          "sound": "default"
        };

        _databaseApi.postNotificationCollection(sellerId, postMap);

        await _databaseApi.postNotification(
            orderID: '',
            title: 'Followers',
            body: '${currentUser.username} followed you',
            forRole: 'follow',
            userID: currentUser.id,
            receiverToken: user.token!);
      }
      followings = await _databaseApi.getFollowing(currentUser.id);

      for (int i = 0; i < newNotifications.length; i++) {
        if (newNotifications[i].orderID == 'null') {
          for (int j = 0; j < followings.length; j++) {
            if (newNotifications[i].userId == followings[j].id) {
              isFollowing[i] = true;
            }
          }
        }
      }

      isLoading = false;
      notifyListeners();
    }).catchError((error) {
      isLoading = false;
      notifyListeners();
      print(error.toString());
    });
  }

  Future<void> unfollow(String sellerId, int index) async {
    isLoading = true;
    notifyListeners();
    await _databaseApi
        .unfollow(
      currentUserId: currentUser.id,
      userId: sellerId,
    )
        .whenComplete(
      () async {
        for (int i = 0; i < newNotifications.length; i++) {
          if (newNotifications[i].orderID == 'null') {
            for (int j = 0; j < followings.length; j++) {
              if (newNotifications[i].userId == followings[j].id) {
                isFollowing[i] = false;
              }
            }
          }
        }
        // isFollowing[index] = false;
        var user = await _databaseApi.getUser(sellerId);
        if (user != null) {
          Map<String, dynamic> postMap = {
            "userId": currentUser.id,
            "title": '',
            "body": '${currentUser.username} unfollowed you',
            "id": DateTime.now().millisecondsSinceEpoch.toString(),
            "read": false,
            "image": currentUser.imageUrl,
            "time": DateTime.now().millisecondsSinceEpoch.toString(),
            "sound": "default"
          };

          // _databaseApi.postNotificationCollection(sellerId, postMap);

          // await _databaseApi.postNotification(
          //     orderID: '',
          //     title: 'Followers',
          //     body: '${currentUser.username} unfollowed you',
          //     forRole: 'follow',
          //     userID: currentUser.id,
          //     receiverToken: user.token!);
        }

        final follows = await _databaseApi.getFollowing(currentUser.id);

        final ids = follows.map((e) => e.id).toList();

        if (ids != currentfollowingIds) {
          currentfollowingIds = ids;
        }
        // print("currentfollowingIds $currentfollowingIds");
        isLoading = false;
        notifyListeners();
      },
    ).catchError((error) {
      isLoading = false;
      notifyListeners();
      print(error.toString());
    });
  }

  @override
  void dispose() {
    // _notificationsSubscription.cancel();
    _newNotificationsSubscription.cancel();
    super.dispose();
  }

  void readNotification(String uid, String id) {
    _databaseApi.readNotification(uid, id);
  }
}
