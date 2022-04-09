import 'dart:convert';

import 'package:mipromo/api/auth_api.dart';
import 'package:mipromo/api/database_api.dart';
import 'package:mipromo/app/app.locator.dart';
import 'package:mipromo/app/app.router.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/models/follow.dart';
import 'package:mipromo/models/shop.dart';
import 'package:mipromo/models/shop_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SearchViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _databaseApi = locator<DatabaseApi>();

  List<Shop> searchedShops = [];
  List<Shop> followingShops = [];
  List<Shop> otherShops = [];

  List<Shop>? allShops;
  List<Follow> _follows = [];
  List<String> ids = [];
  List<AppUser> users = [];
  List<AppUser>? shopOwners;
  List<ShopService>? allServices;

  void init() async {
    setBusy(true);

    _listenAllShops();
    _listenShopOwners();
    _listenAllServices();
    _getFollowers();
    
    setBusy(false);
  
  }

  void _listenAllShops() {
    _databaseApi.listenShops().listen(
      (shopsData) {
        allShops = shopsData;
       
        for (var user in users) {
          for (var shop in allShops! ) {
            if (user.shopId == shop.id) {
               followingShops.add(shop);
            }
          }
          
        }
        print('other shops');
        print(otherShops);
    //      otherShops = allShops!;
    //         for (var elem in followingShops) {
    // otherShops.remove(elem);
  // }
        
         searchedShops =followingShops;
        //  followingShops.addAll(otherShops);
        notifyListeners();
      },
    );

  }
Future navigateToShopView1({
    required Shop shop,
    required AppUser owner,
  }) async {
    await _navigationService.navigateTo(
      Routes.sellerProfileView,
      arguments: SellerProfileViewArguments(
        seller: owner,
      ),
    );
  }
   void _getFollowers() async {
    var user = AuthApi().currentUser;
    _follows = await _databaseApi.getFollowing(user!.uid);
     if (_follows.isNotEmpty) {
      ids = _follows.map((e) => e.id).toList();
      
      _databaseApi.listenChatUsers(ids).listen(
        (usersData) {
          users = usersData;
          notifyListeners();
          setBusy(false);
        },

      );
     

    } else {
      setBusy(false);
    }
  }

  void _listenShopOwners() {
    _databaseApi.listenShopOwners().listen(
      (users) {
        shopOwners = users;
        notifyListeners();
      },
    );
  }

  void _listenAllServices() {
    _databaseApi.listenAllServices().listen(
      (servicesData) {
        allServices = servicesData;
        notifyListeners();
      },
    );
  }

  void onSearchTextChanged(String text) {
    searchedShops = [];
    notifyListeners();
    print('********************************');
    print(allShops);
    if (text.isEmpty) {
      searchedShops = allShops!;
      notifyListeners();
      return;
    }

    // ignore: avoid_function_literals_in_foreach_calls
    allShops!.forEach((shop) {
      if (shop.name.trim().replaceAll(' ', '').toLowerCase().contains(text.trim().replaceAll(' ', '').toLowerCase())) {
        searchedShops.add(shop);
        notifyListeners();
        return;
      } else {
        searchedShops.remove(shop);
        notifyListeners();
        if (text.isEmpty) {
          searchedShops = allShops!;

          notifyListeners();
          return;
        }
        return;
      }
    });
  }

  Future navigateToShopView({
    required Shop shop,
    required AppUser owner,
    required List<ShopService> services,
  }) async {
    await _navigationService.navigateTo(
      Routes.sellerProfileView,
      arguments: SellerProfileViewArguments(
        seller: owner,
      ),
    );
  }
}
