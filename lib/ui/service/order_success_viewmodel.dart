import 'package:mipromo/api/database_api.dart';
import 'package:mipromo/app/app.locator.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/services/user_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class OrderSuccessViewModel extends BaseViewModel {
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
    notifyListeners();
    setBusy(false);
  }

  onClose(){
    _navigationService.back(result: false);
  }

  navigateToOrder(){
    _navigationService.back(result: true);
  }

}
