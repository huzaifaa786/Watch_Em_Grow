import 'package:fluttertoast/fluttertoast.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/models/availability.dart';
import 'package:mipromo/ui/shared/helpers/data_models.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../api/database_api.dart';
import '../../../app/app.locator.dart';
import '../../../models/shop.dart';
import '../../shared/helpers/alerts.dart';
import '../../shared/helpers/validators.dart';

class EditShopViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _databaseApi = locator<DatabaseApi>();
  var values = List.filled(7, true);
  late Shop mshop;
  late Availability availability;
  void init(Shop shop) async {
    setBusy(true);
    mshop = shop;
    shopName = shop.name;
    description = shop.description;
    selectedCategory = shop.category;
    selectedLocation = shop.location;
    if (selectedLocation == 'London') {
      londonBorough = shop.borough;
    } else if (selectedLocation == 'Hertfordshire') {
      hertfordshireBorough = shop.borough;
    } else {}
    address = shop.address;
    policy = shop.policy;
    //selectedFontStyle = shop.fontStyle;
    selectedTheme = shop.color;
    await _databaseApi.getAvailabilty(userId: shop.ownerId).then((value) {
      availability = value;
    });
    values = converToArray(availability);
    setBusy(false);
  }

  String shopName = "";

  String description = "";

  String? selectedCategory;
  String? selectedLocation;
  String? londonBorough;
  String? hertfordshireBorough;

  String address = "";
  String policy = "";
  String extraServiceName = "";
  String price = "";

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
    // swiperIndex = index;
    notifyListeners();
  }

  bool displayNewTextField = false;
  displayTextField() {
    displayNewTextField = !displayNewTextField;
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

  void getSelectedLocation(String city) {
    selectedLocation = city;
    notifyListeners();
  }

  void getSelectedLondonBorough(String borough) {
    londonBorough = borough;
    notifyListeners();
  }

  void getSelectedHertfordshireBorough(String borough) {
    hertfordshireBorough = borough;
    notifyListeners();
  }

  void getSelectedFont(String fontStyle) {
    selectedFontStyle = fontStyle;
    notifyListeners();
  }

  selection(int index) {
    values[index] = !values[index];
    notifyListeners();

    Map<String, dynamic> postMap = {
      for (var i = 0; i <= 6; i++) intDayToEnglish(i): values[i]
    };

    _databaseApi.changeAvailabilty(userId: mshop.ownerId, availabilty: postMap);
  }

  bool _isFormValid() {
    if (Validators.emptyStringValidator(shopName, 'Shop Name') == null &&
        Validators.emptyStringValidator(description, 'Description') == null &&
        shopName.length <= 30 &&
        description.length <= 500 &&
        policy.length <= 1000 &&
        address.length <= 100) {
      if (selectedCategory == null) {
        Alerts.showErrorSnackbar('Please select Category');
        return false;
      } else if (selectedLocation != null) {
        if (selectedLocation == "London" && londonBorough == null) {
          Alerts.showErrorSnackbar('Please select your Location Borough');
          return false;
        } else if (selectedLocation == "Hertfordshire" &&
            hertfordshireBorough == null) {
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

  Future _createShop(Shop shop) async {
    setBusy(true);

    await Future.wait(
      [
        _updateShopName(shop),
        _updateShopDescription(shop),
        _updateShopCategory(shop),
        _updateShopLocation(shop),
        _updateShopBorough(shop),
        _updateShopAddress(shop),
        _updateShopPolicy(shop),
        _updateShopFontStyle(shop),
        _updateShopColor(shop),
      ],
    ).whenComplete(
      () {
        setBusy(false);
        _navigationService.back();
      },
    );

    _navigationService.back();
  }

  Future _updateShopName(Shop shop) async {
    if (shopName != shop.name) {
      await _databaseApi.updateShopName(
        shop.id,
        shopName,
      );
    }
  }

  Future _updateShopDescription(Shop shop) async {
    if (description != shop.description) {
      await _databaseApi.updateShopDescription(
        shop.id,
        description,
      );
    }
  }

  Future _updateShopCategory(Shop shop) async {
    if (selectedCategory != shop.category) {
      await _databaseApi.updateShopCategory(
        shop.id,
        selectedCategory!,
      );
    }
  }

  Future _updateShopLocation(Shop shop) async {
    if (selectedLocation != shop.location) {
      await _databaseApi.updateShoplocation(
        shop.id,
        selectedLocation!,
      );
    }
  }

  Future _updateShopBorough(Shop shop) async {
    if (londonBorough != shop.borough) {
      await _databaseApi.updateShopBorough(
        shop.id,
        londonBorough!,
      );
    }

    if (hertfordshireBorough != shop.borough) {
      await _databaseApi.updateShopBorough(
        shop.id,
        hertfordshireBorough!,
      );
    }
  }

  Future _updateShopAddress(Shop shop) async {
    if (address != shop.address) {
      await _databaseApi.updateShopAddress(
        shop.id,
        address,
      );
    }
  }

  Future _updateShopPolicy(Shop shop) async {
    if (policy != shop.policy) {
      await _databaseApi.updateShopPolicy(
        shop.id,
        policy,
      );
    }
  }

  Future _updateShopFontStyle(Shop shop) async {
    if (selectedFontStyle != shop.fontStyle) {
      await _databaseApi.updateShopFontStyle(
        shop.id,
        selectedFontStyle,
      );
    }
  }

  Future _updateShopColor(Shop shop) async {
    if (selectedTheme != shop.color) {
      await _databaseApi.updateShopColor(
        shop.id,
        selectedTheme,
      );
    }
  }

  void createShop(Shop shop) {
    if (_isFormValid()) {
      _createShop(shop);
    } else {
      showErrors();
    }
  }

  void createExtraServicesShop() {
    if (isFormValid()) {
      addExtraServices();
    } else {
      showErrors();
    }
  }

    bool isFormValid() {
    if (Validators.emptyStringValidator(extraServiceName, 'extraServiceName') == null &&
        Validators.emptyStringValidator(price, 'price') == null &&
        shopName.length <= 30) {
      if (extraServiceName == null) {
        Alerts.showErrorSnackbar('Please enter service name');
        return false;
      } else if(price == null) {
        Alerts.showErrorSnackbar('Please select price');
        return false;
      } else{
        return true;
      }
    } else {
      showErrors();
      return false;
    }
  }

  addExtraServices() async {
    print(mshop.id);
    Map<String, dynamic> postMap = {
      'name': extraServiceName,
      'price': price,
    };

    await _databaseApi.createExtraServices(
        shopId: mshop.id, extraService: postMap);

    Fluttertoast.showToast(msg: 'Updated');
  }
}
