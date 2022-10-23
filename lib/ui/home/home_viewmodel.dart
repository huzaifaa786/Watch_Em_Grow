import 'dart:async';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:mipromo/api/database_api.dart';
import 'package:mipromo/app/app.locator.dart';
import 'package:mipromo/app/app.router.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/models/shop.dart';
import 'package:mipromo/models/shop_service.dart';
import 'package:mipromo/ui/home/category_item.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
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

  initDynamicLinks() async {
    final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink();
    if (data != null) {
      _handleDynamicLink(data);
    }
    FirebaseDynamicLinks.instance.onLink(onSuccess: (PendingDynamicLinkData? dynamicLink) async {
      _handleDynamicLink(dynamicLink!);
    }, onError: (OnLinkErrorException e) async {
      print('onLinkError');
      print(e.message);
    });
  }

  _handleDynamicLink(PendingDynamicLinkData data) async {
    final Uri deepLink = data.link;
    var shopId = deepLink.pathSegments[0];

    if (deepLink == null) {
      return;
    }
    var mshop = allShops.singleWhere((shop) => shop.id.contains(shopId));
    var mowner = allSellers.singleWhere(
      (owner) => owner.shopId.contains(mshop.id),
    );
    navigateToShopView(shop: mshop, owner: mowner);
  }

  void init() {
    setBusy(true);
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
        categoryShops: allShops.where((shop) => shop.category == category).toList(),
        allOtherShops: allShops.where((shop) => shop.category != category).toList(),
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
      name: "Nails",
      imageUrl: "assets/images/category/nails.jpeg",
    ),
    CategoryItem(
      name: "Hair\nSaloons",
      imageUrl: "assets/images/category/hair.jpg",
    ),
    CategoryItem(
      name: "Makeup Services",
      imageUrl: "assets/images/category/makeup.jpg",
    ),
    CategoryItem(
      name: "Eyelash Extensions",
      imageUrl: "assets/images/category/lashes.jpg",
    ),
    CategoryItem(
      name: "Clothing Brands",
      imageUrl: "assets/images/category/clothing.jpeg",
    ),
    CategoryItem(
      name: "Footwear & Resellers",
      imageUrl: "assets/images/category/trainers.jpeg",
    ),
    CategoryItem(
      name: "Accessories",
      imageUrl: "assets/images/category/accessories.jpeg",
    ),
    CategoryItem(
      name: "Photography & Videography",
      imageUrl: "assets/images/category/photography.jpeg",
    ),
    CategoryItem(
      name: "Aesthetics",
      imageUrl: "assets/images/category/aesthetic.jpeg",
    ),
    CategoryItem(
      name: "Barber Shop",
      imageUrl: "assets/images/category/barber.jpeg",
    ),
    CategoryItem(
      name: "Piercings",
      imageUrl: "assets/images/category/Piercing.jpeg",
    ),
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
