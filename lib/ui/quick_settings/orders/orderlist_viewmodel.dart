import 'dart:async';
import 'package:mipromo/app/app.router.dart';
import 'package:mipromo/api/database_api.dart';
import 'package:mipromo/app/app.locator.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/models/order.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class BoughtOrderListViewModel extends BaseViewModel {
  final _databaseApi = locator<DatabaseApi>();
  final _navigationService = locator<NavigationService>();
  late StreamSubscription<List<Order>> _orderSubscription;
  late AppUser _currentUser;
  List<Order> orders = [];

  AppUser get currentUser => _currentUser;
  Future<void> init({required AppUser currentUser}) async {
    setBusy(true);
    _currentUser = currentUser;
    if (_currentUser.id.isNotEmpty) {
      _orderSubscription =
          _databaseApi.listenOrdersByUserId(_currentUser.id).listen((cOrders) {
        orders = cOrders;
        notifyListeners();
        setBusy(false);
      });
      return;
    }
    setBusy(false);
  }

  Future navigateToOrderDetailView(Order order) async {
    final shopId = order.service.shopId;
    if (shopId.isNotEmpty) {
      _databaseApi.getShop(shopId).then((shopData) {
        _navigationService.navigateTo(Routes.orderDetailView,
            arguments: OrderDetailViewArguments(
                order: order,
                color: shopData.color,
                currentUser: _currentUser,
                fontStyle: shopData.fontStyle));
      });
    }
  }

  @override
  void dispose() {
    _orderSubscription.cancel();
    super.dispose();
  }
}

class SoldOrderListViewModel extends BaseViewModel {
  final _databaseApi = locator<DatabaseApi>();
  final _navigationService = locator<NavigationService>();
  late StreamSubscription<List<Order>> _orderSubscription;
  late AppUser _currentUser;
  List<Order> orders = [];

  AppUser get currentUser => _currentUser;
  Future<void> init({required AppUser currentUser}) async {
    setBusy(true);
    _currentUser = currentUser;
    if (_currentUser.id.isNotEmpty) {
      _orderSubscription = _databaseApi
          .listenOrdersByShopId(_currentUser.shopId)
          .listen((cOrders) {
        orders = cOrders;

        notifyListeners();
        setBusy(false);
      });
      return;
    }
    setBusy(false);
  }

  Future navigateToOrderDetailView(Order order) async {
    final shopId = order.service.shopId;
    if (shopId.isNotEmpty) {
      _databaseApi.getShop(shopId).then((shopData) {
        _navigationService.navigateTo(Routes.orderDetailView,
            arguments: OrderDetailViewArguments(
                order: order,
                color: shopData.color,
                currentUser: _currentUser,
                fontStyle: shopData.fontStyle));
      });
    }
  }

  @override
  void dispose() {
    _orderSubscription.cancel();
    super.dispose();
  }
}
