import 'dart:async';

import 'package:mipromo/api/database_api.dart';
import 'package:mipromo/app/app.locator.dart';
import 'package:mipromo/app/app.router.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/models/follow.dart';
import 'package:mipromo/services/user_service.dart';
import 'package:mipromo/ui/shared/helpers/data_models.dart';
import 'package:mipromo/ui/shared/helpers/enums.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class BuyerProfileViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _userService = locator<UserService>();
  final _databaseApi = locator<DatabaseApi>();

  late StreamSubscription<List<Follow>> _followSubscription;

  List<String> currentfollowingIds = [];
  late AppUser _currentUser;
  AppUser get currentUser => _currentUser;

  late AppUser otherUser;
  bool unfollowed = false;
  bool isApiLoading = false;

  bool unfollowed2 = false;

  Future<void> init(AppUser user) async {
    setBusy(true);
    await _userService.syncUser();
    _currentUser = _userService.currentUser;
    otherUser = user;
    print(otherUser.id);
    notifyListeners();

    if (_currentUser.id.isNotEmpty) {
      _followSubscription =
          _databaseApi.listenFollowings(_currentUser.id).listen(
        (f) {
          currentfollowingIds = f.map((e) => e.id).toList();
          notifyListeners();

          if (currentfollowingIds.contains(user.id)) {
            unfollowed2 = true;
          } else {
            unfollowed2 = false;
          }
        },
      );
    }

    if (_currentUser.id.isNotEmpty) {
      _followSubscription =
          _databaseApi.listenFollowings(_currentUser.id).listen(
        (f) {
          currentfollowingIds = f.map((e) => e.id).toList();
          notifyListeners();
        },
      );
    }

    setBusy(false);
  }

  backToNotifications() {
    print("Unfollowed2 -> " + unfollowed2.toString());

    _navigationService.back(result: unfollowed2);
  }

  Future<void> navigateToEditProfile(AppUser user) async {
    if (await _navigationService.navigateTo(
          Routes.buyerEditProfileView,
          arguments: BuyerEditProfileViewArguments(user: user),
        ) ==
        true) {
      setBusy(true);
      await _userService.syncUser();
      _currentUser = _userService.currentUser;
      notifyListeners();
      setBusy(false);
    }
  }

  Future showCreateSellerProfileDialog(AppUser user) async {
    final response = await _dialogService.showCustomDialog(
      variant: AlertType.info,
      title: 'Create Seller Account',
      description: 'To open a shop you have to create a seller account first.',
      mainButtonTitle: 'Create Seller Account',
      customData: CustomDialogData(
        isConfirmationDialog: true,
      ),
    );

    if (response != null && response.confirmed) {
      /*if(await _navigationService.navigateTo(
          Routes.sellerSignupView,
        arguments: SellerSignupViewArguments(user: user),
      ) == true){
        print('Form Validation Done.........');
      }*/

      await _navigationService.navigateTo(
        Routes.sellerSignupView,
        arguments: SellerSignupViewArguments(user: user),
      );
    }
  }

  Future<void> navigateToBuyerSettingsView() async {
    _navigationService.back();
    await _navigationService.navigateTo(Routes.settingsView);
  }

  Future<void> navigateToContactUsView() async {
    _navigationService.back();
    await _navigationService.navigateTo(Routes.contactUs);
  }

  Future<void> navigateToFollowersView(String id) async {
    await _navigationService.navigateTo(
      Routes.followersView,
      arguments: FollowersViewArguments(
        sellerId: id,
      ),
    );
  }

  Future<void> navigateToFollowingView(String id) async {
    await _navigationService.navigateTo(
      Routes.followingView,
      arguments: FollowingViewArguments(
        sellerId: id,
      ),
    );
  }

  Future<void> navigateToOrders() async {
    _navigationService.back();
    await _navigationService.navigateTo(Routes.ordersBuyerView);
  }

  Future<void> follow(String sellerId) async {
    isApiLoading = true;
    notifyListeners();
    await _databaseApi
        .follow(
      currentUserId: _currentUser.id,
      userId: sellerId,
    )
        .whenComplete(
      () async {
        var user = await _databaseApi.getUser(sellerId);
        if (user != null) {
          Map<String, dynamic> postMap = {
            "userId": _currentUser.id,
            "title": 'New follower',
            "body": '${_currentUser.username} followed you',
            "id": DateTime.now().millisecondsSinceEpoch.toString(),
            "read": false,
            "image": _currentUser.imageUrl,
            "time": DateTime.now().millisecondsSinceEpoch.toString(),
            "sound": "default"
          };

          _databaseApi.postNotificationCollection(sellerId, postMap);

          await _databaseApi.postNotification(
              orderID: '',
              title: 'Followers',
              body: '${_currentUser.username} followed you',
              forRole: 'follow',
              userID: _currentUser.id,
              receiverToken: user.token!);
        }
        unfollowed2 = true;
        isApiLoading = false;
        notifyListeners();
      },
    ).catchError((error) {
      isApiLoading = false;
      notifyListeners();
      print(error.toString());
    });
  }

  Future<void> unfollow(String sellerId) async {
    isApiLoading = true;
    notifyListeners();
    await _databaseApi
        .unfollow(
      currentUserId: _currentUser.id,
      userId: sellerId,
    )
        .whenComplete(
      () async {
        var user = await _databaseApi.getUser(sellerId);
        if (user != null) {
          Map<String, dynamic> postMap = {
            "userId": _currentUser.id,
            "title": '',
            "body": '${_currentUser.username} unfollowed you',
            "id": DateTime.now().millisecondsSinceEpoch.toString(),
            "read": false,
            "image": _currentUser.imageUrl,
            "time": DateTime.now().millisecondsSinceEpoch.toString(),
            "sound": "default"
          };

          _databaseApi.postNotificationCollection(sellerId, postMap);

          await _databaseApi.postNotification(
              orderID: '',
              title: 'Followers',
              body: '${_currentUser.username} unfollowed you',
              forRole: 'follow',
              userID: _currentUser.id,
              receiverToken: user.token!);
        }

        final follows = await _databaseApi.getFollowing(_currentUser.id);

        final ids = follows.map((e) => e.id).toList();

        if (ids != currentfollowingIds) {
          currentfollowingIds = ids;
        }
        unfollowed2 = false;
        isApiLoading = false;
        notifyListeners();
      },
    ).catchError((error) {
      isApiLoading = false;
      notifyListeners();
      print(error.toString());
    });
  }
}
