import 'package:mipromo/api/auth_api.dart';
import 'package:mipromo/app/app.locator.dart';
import 'package:mipromo/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class StartUpViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _authApi = locator<AuthApi>();

  /// Handle the startup screen according to User's authentication state
  Future<void> runStartupLogic() async {
    final user = _authApi.currentUser;

    if (user != null && user.emailVerified) {
      await _navigationService.replaceWith(Routes.mainView);
    } else {
      await _navigationService.replaceWith(Routes.landingView);
    }
  }
}
