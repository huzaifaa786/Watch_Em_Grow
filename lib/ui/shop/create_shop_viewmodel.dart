import 'package:mipromo/api/database_api.dart';
import 'package:mipromo/app/app.locator.dart';
import 'package:mipromo/app/app.router.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/models/shop.dart';
import 'package:mipromo/ui/shared/helpers/alerts.dart';
import 'package:mipromo/ui/shared/helpers/constants.dart';
import 'package:mipromo/ui/shared/helpers/validators.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:uuid/uuid.dart';

class CreateShopViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _databaseApi = locator<DatabaseApi>();

  final _shopId = const Uuid().v4();

  late AppUser currentUser;

  List<String> searchedLocations = [];

  bool hasBorough = false;

  void init(AppUser user) {
    setBusy(true);

    currentUser = user;
    notifyListeners();

    setBusy(false);
  }

  String shopName = "";

  String description = "";

  String? selectedCategory;
  String? selectedLocation;
  String? selectedBorough;

  String address = "";

  String selectedFontStyle = "Default";

  bool autoValidate = false;

  List<int> colors = [
    0xff828CFC,
    0xffFF9E9E,
    0xff5ECBD9,
    0xffA6A6A6,
    0xffFAC770,
    0xfff69e7b,
    0xfff67280,
    0xffc06c84,
    0xffac8daf,
    0xff5fbdb0,
  ];

  int selectedTheme = 0xff828CFC;

  void onColorChanged(int color, int index) {
    selectedTheme = color;
    notifyListeners();
  }

  void showErrors() {
    autoValidate = true;
    notifyListeners();
  }

  void getSelectedCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }

  void getSelectedFont(String fontStyle) {
    selectedFontStyle = fontStyle;
    notifyListeners();
  }

  bool _isFormValid() {
    if (Validators.emptyStringValidator(shopName, 'Shop Name') == null &&
        Validators.emptyStringValidator(description, 'Description') == null &&
        shopName.length <= 30 &&
        description.length <= 500 &&
        address.length <= 100) {
      if (selectedCategory == null) {
        Alerts.showErrorSnackbar('Please select Category');
        return false;
      } else if (selectedLocation != null) {
        if (selectedLocation == "London" && selectedBorough == null) {
          Alerts.showErrorSnackbar('Please select your Location Borough');
          return false;
        } else if (selectedLocation == "Hertfordshire" &&
            selectedBorough == null) {
          Alerts.showErrorSnackbar('Please select your Location Borough');

          return false;
        } else {
          return true;
        }
      } else {
        Alerts.showErrorSnackbar('Please select Location');
        return false;
      }
    } else {
      showErrors();
      return false;
    }
  }

  Future _createShop() async {
    setBusy(true);

    await _databaseApi.createShop(
      Shop(
        id: _shopId,
        ownerId: currentUser.id,
        name: shopName,
        description: description,
        category: selectedCategory!,
        location: selectedLocation!,
        borough: selectedBorough ?? '',
        address: address,
        fontStyle: selectedFontStyle,
        color: selectedTheme,
        isFeatured: 0,
        isBestSeller: 0
      ),
    );

    await _databaseApi.updateUserShopId(
      userId: currentUser.id,
      shopId: _shopId,
    );

    setBusy(false);

    _navigationService.popUntil(
      (route) => route.settings.name == Routes.mainView,
    );
  }

  void createShop() {
    if (_isFormValid()) {
      _createShop();
    } else {
      showErrors();
    }
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
