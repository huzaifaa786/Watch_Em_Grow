import 'dart:async';
import 'package:intl/intl.dart';
import 'package:mipromo/app/app.router.dart';
import 'package:mipromo/api/database_api.dart';
import 'package:mipromo/app/app.locator.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/models/order.dart';
import 'package:mipromo/ui/quick_settings/orders/orderlist_view.dart';
import 'package:mipromo/ui/shared/helpers/enums.dart';
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
      _orderSubscription = _databaseApi.listenOrdersByUserId(_currentUser.id).listen((cOrders) {
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
                order: order, color: shopData.color, currentUser: _currentUser, fontStyle: shopData.fontStyle));
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
  late Map<DateTime, List<Order>> selectedEvents;

  AppUser get currentUser => _currentUser;
  Future<void> init({required AppUser currentUser}) async {
    setBusy(true);
    selectedEvents = {};

    _currentUser = currentUser;
    if (_currentUser.id.isNotEmpty) {
      _orderSubscription = _databaseApi.listenOrdersByShopId(_currentUser.shopId).listen((cOrders) {
        orders = cOrders;
        for (var i = 0; i < orders.length; i++) {
          DateTime? date;
            date = DateTime.fromMicrosecondsSinceEpoch(orders[i].bookingStart!, isUtc: true);
         var newDate =  DateTime.utc(date.year, date.month, date.day, 0, 0, 0);
    
          if (selectedEvents[newDate] != null) {
            selectedEvents[newDate]!.add(orders[i]);
          } else {
            selectedEvents[DateTime.parse('${newDate}')] = [orders[i]];
          }
        }
        print(selectedEvents);
        notifyListeners();
        setBusy(false);
      });
      return;
    }
    setBusy(false);
  }

  List<Order> getEventsfromDay(DateTime date) {
    // print('date hamari type ki huwi');
    // print(selectedEvents);
    print(date.runtimeType);
    print(selectedEvents);
    return selectedEvents[date] ?? [];
  }

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

  @override
  void dispose() {
    _orderSubscription.cancel();

    super.dispose();
  }
}
