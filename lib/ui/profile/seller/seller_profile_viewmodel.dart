import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mipromo/api/database_api.dart';
import 'package:mipromo/app/app.locator.dart';
import 'package:mipromo/app/app.router.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/models/follow.dart';
import 'package:mipromo/models/shop.dart';
import 'package:mipromo/models/shop_service.dart';
import 'package:mipromo/services/user_service.dart';
import 'package:mipromo/ui/shared/helpers/constants.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.router.dart';

class SellerProfileViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _snackbarService = locator<SnackbarService>();
  final _databaseApi = locator<DatabaseApi>();
  final _userService = locator<UserService>();

  late StreamSubscription<List<Follow>> _followSubscription;
  late StreamSubscription<Shop> _shopSubscription;
  late StreamSubscription<List<ShopService>> _servicesSubscription;

  bool isApiLoading = false;
  late AppUser _currentUser;
  AppUser get currentUser => _currentUser;

  Shop? _shop;
  Shop? get shop => _shop;

  List<ShopService> services = [];
  List<String> currentfollowingIds = [];

  bool unfollowed = false;
  bool unfollowed2 = false;

  bool selectReport = false;

  List<String> reportTypes = [
    "It's spam",
    " Nudity or sexual activity",
    "I just don't like it",
    "Hate speech or symbols",
    "Violence or dangerous organisation",
    "Bullying or harassment",
    "False information",
    "Scam or fraud",
    "Suicide or self-injury",
    "Sale of illegal or regulated goods"
  ];
  Future<void> init(String shopId, AppUser seller) async {
    setBusy(true);
    await _userService.syncUser();
    _currentUser = _userService.currentUser;
    notifyListeners();

    if (_currentUser.id.isNotEmpty) {
      _followSubscription = _databaseApi.listenFollowings(_currentUser.id).listen(
        (f) {
          currentfollowingIds = f.map((e) => e.id).toList();
          notifyListeners();

          if (currentfollowingIds.contains(seller.id)) {
            unfollowed2 = true;
          } else {
            unfollowed2 = false;
          }
        },
      );
    }

    if (shopId.isNotEmpty) {
      _shopSubscription = _databaseApi.listenShop(shopId).listen(
        (shopData) {
          _shop = shopData;
          notifyListeners();

          if (_shop!.hasService) {
            _servicesSubscription = _databaseApi.listenShopServices(shopId).listen(
              (servicesData) {
                services = servicesData;
                print('services**********');
                print(services);
                for (var ser in services) {
                  log(ser.toString());
                }
                notifyListeners();
                setBusy(false);
              },
            );
          } else {
            setBusy(false);
          }
        },
      );
    } else {
      setBusy(false);
    }
  }

  Future<void> navigateToEditProfile() async {
    if (await _navigationService.navigateTo(
          Routes.sellerEditProfileView,
          arguments: SellerEditProfileViewArguments(user: currentUser),
        ) ==
        true) {
      setBusy(true);
      await _userService.syncUser();
      _currentUser = _userService.currentUser;
      notifyListeners();
      setBusy(false);
    }
    /*await _navigationService.navigateTo(
      Routes.sellerEditProfileView,
      arguments: SellerEditProfileViewArguments(user: currentUser),
    );*/
  }

  Future<void> navigateToCreateShopView() async {
    await _navigationService.navigateTo(
      Routes.createShopView,
      arguments: CreateShopViewArguments(user: currentUser),
    );
  }

  backToNotifications() {
    print("Unfollowed2 -> " + unfollowed2.toString());

    _navigationService.back(result: unfollowed2);
  }

  Future<void> navigateToCreateServiceView(Shop shop) async {
    await _navigationService.navigateTo(
      Routes.createServiceView,
      arguments: CreateServiceViewArguments(
        user: currentUser,
        shop: shop,
      ),
    );
  }

  Future<void> navigateToServiceView(
    ShopService service,
    int color,
    String fontStyle,
  ) async {
    await _navigationService.navigateTo(
      Routes.serviceView,
      arguments: ServiceViewArguments(
        service: service,
        color: color,
        fontStyle: fontStyle,
      ),
    );
  }

  Future<void> navigateToSellerSettingsView() async {
    _navigationService.back();
    await _navigationService.navigateTo(Routes.settingsView);
  }

  Future<void> navigateToEarningsView(AppUser user) async {
    _navigationService.back();
    await _navigationService.navigateTo(
      Routes.earningsView,
      arguments: EarningsViewArguments(
        user: user,
      ),
    );
  }

  Future sendReportRequest(String type) async {
    _navigationService.back();
    isApiLoading = true;
    notifyListeners();
    _databaseApi.sendReport(_currentUser, _shop, type).then((value) {
      isApiLoading = false;
      notifyListeners();
      return true;
    });
  }

  Future handleReport(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.9,
            decoration: BoxDecoration(
              color: Color(0xFF313131),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 5,
                      width: 35,
                      decoration: BoxDecoration(color: Color(0xFF6B6969), borderRadius: BorderRadius.circular(55)),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Report",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Divider(),
                SizedBox(height: 5),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Why are you reporting this post?",
                        style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Your report is anonymous, except if you're reporting an intellectual property infringement. If someone is in immediate danger, call the local emergency services - don't wait.",
                          maxLines: 6,
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[400]),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Divider(),
                Flexible(
                  child: ListView.builder(
                    itemCount: reportTypes.length,
                    // shrinkWrap: true,
                    // physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          InkWell(
                            onTap: () async {
                              selectReport = true;
                              await sendReportRequest(reportTypes[index]);
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    reportTypes[index],
                                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, color: Colors.white),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    color: Colors.white,
                                    size: 16,
                                  )
                                ],
                              ),
                            ),
                          ),
                          Divider()
                        ],
                      );
                    },
                  ),
                )
              ],
            ),
          );
        });
  }

  Future reportedDone(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              color: Color(0xFF313131),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 5,
                        width: 35,
                        decoration: BoxDecoration(color: Color(0xFF6B6969), borderRadius: BorderRadius.circular(55)),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: h * 0.07,
                          width: h * 0.07,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(55),
                              border: Border.all(color: Colors.white, width: 2)),
                          child: Icon(
                            Icons.done,
                            size: h * 0.05,
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Thanks for letting us know",
                          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Your feedback is important in helping us keep this community safe",
                            maxLines: 6,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[400]),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: h * 0.20),
                  Divider(),
                  InkWell(
                    onTap: () {
                      _navigationService.back();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Container(
                          height: h * 0.05,
                          width: double.infinity,
                          decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(8)),
                          child: Center(
                            child: Text(
                              "Next",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.white),
                            ),
                          )),
                    ),
                  ),
                  SizedBox(height: h * 0.01),
                ],
              ),
            ),
          );
        });
  }

  Future<void> navigateToOrdersView() async {
    _navigationService.back();
    await _navigationService.navigateTo(Routes.ordersView);
  }

  void showCodeCopiedSnackbar() {
    _snackbarService.showSnackbar(
      message: 'Referral Code Copied',
    );
  }

  Future<void> navigateToFollowersView(String sellerId) async {
    await _navigationService
        .navigateTo(
      Routes.followersView,
      arguments: FollowersViewArguments(
        sellerId: sellerId,
      ),
    )!
        .then((value) async {
      setBusy(true);
      await _userService.syncUser();
      _currentUser = _userService.currentUser;
      if (_currentUser.shopId.isNotEmpty) {
        _shopSubscription = _databaseApi.listenShop(_currentUser.shopId).listen(
          (shopData) {
            _shop = shopData;
            notifyListeners();

            if (_shop!.hasService) {
              _servicesSubscription = _databaseApi.listenShopServices(_currentUser.shopId).listen(
                (servicesData) {
                  services = servicesData;
                  notifyListeners();
                  setBusy(false);
                },
              );
            } else {
              setBusy(false);
            }
          },
        );
      } else {
        setBusy(false);
      }
      notifyListeners();
      setBusy(false);
    });
  }

  Future<void> navigateToFollowingView(String sellerId) async {
    await _navigationService
        .navigateTo(
      Routes.followingView,
      arguments: FollowingViewArguments(sellerId: sellerId),
    )!
        .then((value) async {
      setBusy(true);
      await _userService.syncUser();
      _currentUser = _userService.currentUser;
      if (_currentUser.shopId.isNotEmpty) {
        _shopSubscription = _databaseApi.listenShop(_currentUser.shopId).listen(
          (shopData) {
            _shop = shopData;
            notifyListeners();

            if (_shop!.hasService) {
              _servicesSubscription = _databaseApi.listenShopServices(_currentUser.shopId).listen(
                (servicesData) {
                  services = servicesData;
                  notifyListeners();
                  setBusy(false);
                },
              );
            } else {
              setBusy(false);
            }
          },
        );
      } else {
        setBusy(false);
      }
      notifyListeners();
      setBusy(false);
    });
  }

  Future<void> follow(String sellerId) async {
    isApiLoading = true;
    notifyListeners();
    await _databaseApi
        .follow(
      currentUserId: _currentUser.id,
      userId: sellerId,
    )
        .whenComplete(() async {
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
    }).catchError((error) {
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

          // _databaseApi.postNotificationCollection(sellerId, postMap);

          // await _databaseApi.postNotification(
          //     orderID: '',
          //     title: 'Followers',
          //     body: '${_currentUser.username} unfollowed you',
          //     forRole: 'follow',
          //     userID: _currentUser.id,
          //     receiverToken: user.token!);
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

  Future<void> navigateToContactUsView() async {
    _navigationService.back();
    await _navigationService.navigateTo(Routes.contactUs);
  }

  Future<void> navigateToEditShopView() async {
    await _navigationService.navigateTo(
      Routes.editShopView,
      arguments: EditShopViewArguments(
        shop: _shop!,
      ),
    );
  }

  @override
  void dispose() {
    _followSubscription.cancel();
    _shopSubscription.cancel();
    _servicesSubscription.cancel();
    super.dispose();
  }
}
