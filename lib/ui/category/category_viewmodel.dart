import 'package:mipromo/app/app.locator.dart';
import 'package:mipromo/app/app.router.dart';
import 'package:mipromo/models/shop.dart';
import 'package:mipromo/models/shop_service.dart';
import 'package:mipromo/ui/shared/helpers/constants.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CategoryViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  List<Shop> shops = [];
  List<Shop> chachedShops = [];

  List<String> searchedLocations = [];

  CategorySortBy sortBy = CategorySortBy.featured;

  String filteredLocation = '';


  void init(List<Shop> categoryShops) {
    setBusy(true);
    shops = categoryShops;
    chachedShops = categoryShops;
    notifyListeners();
    setBusy(false);
  }

  void toggleSort(CategorySortBy? categorySortBy) {
    sortBy = categorySortBy!;
    notifyListeners();
  }

  void sort() {
    if (sortBy == CategorySortBy.ratings) {
      shops.sort((a, b) => a.rating.compareTo(b.rating));
      notifyListeners();
    } else if (sortBy == CategorySortBy.priceRangeLowToHigh) {
      shops.sort((a, b) => a.lowestPrice.compareTo(b.lowestPrice));
      notifyListeners();
    } else if (sortBy == CategorySortBy.priceRangeHighToLow) {
      shops.sort((a, b) => b.lowestPrice.compareTo(a.lowestPrice));
      notifyListeners();
    } else {}
    _navigationService.back();
  }

  Future navigateToServiceView(
      ShopService service, int color, String font) async {
    await _navigationService.navigateTo(
      Routes.serviceView,
      arguments: ServiceViewArguments(
        service: service,
        color: color,
        fontStyle: font,
      ),
    );
  }

  void onLocationsSearchTextChanged(String text) {
    searchedLocations.clear();
    if (text.isEmpty) {
      notifyListeners();
      return;
    }

    // ignore: avoid_function_literals_in_foreach_calls
    Constants.allLocations.forEach((location) {
      if (location.toLowerCase().contains(text.toLowerCase())) {
        searchedLocations.add(location);
        notifyListeners();
        return;
      }
    });
  }
}

enum CategorySortBy {
  featured,
  priceRangeLowToHigh,
  priceRangeHighToLow,
  ratings
}
