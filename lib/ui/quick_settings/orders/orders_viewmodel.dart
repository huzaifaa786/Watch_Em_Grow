import 'package:mipromo/app/app.locator.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/services/user_service.dart';
import 'package:mipromo/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:stacked/stacked.dart';

class OrdersViewModel extends BaseViewModel {
  final _userService = locator<UserService>();
  final _navigationService = locator<NavigationService>();

  late AppUser currentUser;
  Future<void> init() async {
    setBusy(true);
    await _userService.syncUser();
    currentUser = _userService.currentUser;
    setBusy(false);
  }

  moveToProfilePage() async {
    await _navigationService.replaceWith(
      Routes.mainView,
      arguments: MainViewArguments(
      ),
    );
  }

  //   @override
  // void dispose() {
  //   moveToProfilePage();
  //   super.dispose();
  // }
}
