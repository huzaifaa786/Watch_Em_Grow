import 'package:mipromo/app/app.locator.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/services/user_service.dart';
import 'package:stacked/stacked.dart';

class OrdersViewModel extends BaseViewModel {
  final _userService = locator<UserService>();
  late AppUser currentUser;
  Future<void> init() async {
    setBusy(true);
    await _userService.syncUser();
    currentUser = _userService.currentUser;
    setBusy(false);
  }
}
