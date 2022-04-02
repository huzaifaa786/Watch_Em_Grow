import 'package:mipromo/api/database_api.dart';
import 'package:mipromo/app/app.locator.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/services/user_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class InputAddressViewModel extends BaseViewModel {
  final _userService = locator<UserService>();
  final _databaseApi = locator<DatabaseApi>();
  final _navigationService = locator<NavigationService>();
  AppUser? user;
  String fullName = '';
  String address = '';
  String postCode = '';

  Future<void> init() async {
    setBusy(true);
    await _userService.syncUser();
    user = _userService.currentUser;
    fullName = user!.fullName;
    address = user!.address;
    postCode = user!.postCode;
    notifyListeners();
    setBusy(false);
  }

  void setName(String name) {
    fullName = name;
    notifyListeners();
  }

  void setAddress(String address) {
    this.address = address;
    notifyListeners();
  }

  void setPostCode(String postCode) {
    this.postCode = postCode;
    notifyListeners();
  }

  Future updateAddress() async {
    if (address != user!.address || postCode != user!.postCode || fullName != user!.fullName) {
      setBusy(true);
      _databaseApi
          .updateAddress(
        userId: user!.id,
        fullName: fullName,
        address: address,
        postCode: postCode,
      )
          .then((value) {
        setBusy(false);
        _navigationService.back(result: true);
      });
    } else {
      _navigationService.back(result: true);
    }
  }
}
