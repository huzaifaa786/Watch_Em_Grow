import 'dart:async';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:mipromo/api/database_api.dart';
import 'package:mipromo/app/app.locator.dart';
import 'package:mipromo/app/app.router.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/models/shop.dart';
import 'package:logger/logger.dart';
import 'package:mipromo/models/shop_service.dart';
import 'package:mipromo/ui/home/category_item.dart';
import 'package:stacked/stacked.dart';
import 'dart:developer';
import 'package:stacked_services/stacked_services.dart';


class MyFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    return true;
  }
}
class HomeViewModel extends BaseViewModel with WidgetsBindingObserver{
  void initialise() {
    WidgetsBinding.instance!.addObserver(this);
  }
      @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print('resumed');
        initDynamicLinks();
    }
  }
  final _navigationService = locator<NavigationService>();
  final _databaseApi = locator<DatabaseApi>();

  late StreamSubscription<List<AppUser>> _ownersSubscription;
  late StreamSubscription<List<Shop>> _shopsSubscription;
  late StreamSubscription<List<ShopService>> _servicesSubscription;

  List<AppUser> allSellers = [];
  List<Shop> allShops = [];
  List<Shop> featuredShops = [];
  List<Shop> bestSellers = [];
  List<String> allShopIds = [];
  List<ShopService> allServices = [];
    var logger = Logger(filter: MyFilter());
 final initialLinkNotifier = ValueNotifier<String?>(null);
 
  initDynamicLinks() async {
  log('inside dynamic link');
  await Future.delayed(Duration(seconds: 1));
  FirebaseDynamicLinks.instance.onLink(onSuccess: (PendingDynamicLinkData? dynamicLink) async {
      log('dfgdfg');
      log(dynamicLink.toString());
      _handleDynamicLink(dynamicLink!);
    },
    onError: (OnLinkErrorException e) async {
      log('onLinkError###################');
      log(e.message.toString());
    });
    final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink();
    print(data);
    if (data != null) {
      _handleDynamicLink(data);
    }
     
  }

  _handleDynamicLink(PendingDynamicLinkData data) async {
    log("handling ************");
    final Uri deepLink = data.link;
    var shopId = deepLink.pathSegments[0];
    logger.d(shopId.toString());

    if (deepLink == null) {
      return;
    }
    
    var mshop = allShops.singleWhere((shop) => shop.id.contains(shopId));
    var mowner = allSellers.singleWhere(
      (owner) => owner.shopId.contains(mshop.id),
    );
    logger.d(mshop.toString());
    logger.d(mowner.toString());
    await navigateToShopView(shop: mshop, owner: mowner);
  }

  void init() {
    setBusy(true);
    initialise();
    _ownersSubscription = _databaseApi.listenShopOwners().listen(
      (sellers) async {
        allSellers = sellers;
        notifyListeners();

        if (allSellers.isNotEmpty) {
          featuredShops = await _databaseApi.getFeaturedShops();
          bestSellers = await _databaseApi.getBestSellers();
          notifyListeners();
          //_shopsSubscription = _databaseApi.getFeaturedShops().listen(
          _shopsSubscription = _databaseApi.listenShops().listen(
            (shops) {
              allShops = shops;
              notifyListeners();

              if (allShops.isNotEmpty) {
                allShopIds = allShops.map((shop) => shop.id).toList();

                _servicesSubscription = _databaseApi.listenAllServices().listen(
                  (servicesData) {
                    allServices = servicesData;
                    notifyListeners();
                    setBusy(false);
                  },
                );
              } else {
                setBusy(false);
              }
            },
          );
          await initDynamicLinks();
        } else {
          setBusy(false);
        }
      },
    );
  }

  Future<void> reload() async {
    await _databaseApi.getShopOwners().then((sellers) {
      if (allSellers != sellers) {
        allSellers = sellers;
        notifyListeners();
      }
    }).whenComplete(() async {
      await _databaseApi.getShops().then((shops) async {
        if (allShops != shops) {
          allShops = shops;
          notifyListeners();

          if (allShops.isNotEmpty) {
            if (allShopIds != allShops.map((shop) => shop.id).toList()) {
              allShopIds = allShops.map((shop) => shop.id).toList();
            }
          }

          await _databaseApi.getAllServices().then((services) async {
            if (allServices != services) {
              allServices = services;
              notifyListeners();
            }
          });
        }
      });
    });
  }

  Future navigateToCategoryView(
    String category,   
  ) async {
    await _navigationService.navigateTo(
      Routes.categoryView,
      arguments: CategoryViewArguments(
        category: category,
        categoryShops: allShops.where((shop) => shop.category.toLowerCase() == category.replaceAll('\n', ' ').toLowerCase()).toList(),
        allOtherShops: allShops.where((shop) => shop.category.toLowerCase() != category.replaceAll('\n', ' ').toLowerCase()).toList(),
        allSellers: allSellers,
        allServices: allServices,
      ),
    );
  }

  Future navigateToShopView({
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

  List<CategoryItem> categories = [
    CategoryItem(
      name: "Outware",
      imageUrl: "assets/images/category/outware.jpg",
    ),
    CategoryItem(
      name: "Tops",
      imageUrl: "assets/images/category/top.jpg",
    ),
    CategoryItem(
      name: "Bottom",
      imageUrl: "assets/images/category/bottom.jpg",
    ),
    
    // CategoryItem(
    //   name: "Clothing Brands",
    //   imageUrl: "assets/images/category/clothing.jpeg",
    // ),
    CategoryItem(
      name: "Footwear",
      imageUrl: "assets/images/category/bottom.jpeg",
    ),
    CategoryItem(
      name: "Accessories",
      imageUrl: "assets/images/category/accessories.jpeg",
    ),
    // CategoryItem(
    //   name: "Photography & Videography",
    //   imageUrl: "assets/images/category/photography.jpeg",
    // ),
    // CategoryItem(
    //   name: "Aesthetics",
    //   imageUrl: "assets/images/category/aesthetic.jpeg",
    // ),
    // CategoryItem(
    //   name: "Barber Shop",
    //   imageUrl: "assets/images/category/barber.jpeg",
    // ),
    // CategoryItem(
    //   name: "Piercings",
    //   imageUrl: "assets/images/category/Piercing.jpeg",
    // ),
    CategoryItem(
      name: "Other",
      imageUrl: "assets/images/category/other.png",
    ),
  ];

  @override
  void dispose() {
    _ownersSubscription.cancel();
    _shopsSubscription.cancel();
    _servicesSubscription.cancel();
    super.dispose();
  }
}
