import 'package:mipromo/app/app.locator.dart';
import 'package:mipromo/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class LandingViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  /// Navigate to BuyerSignup View
  Future<void> navigateToBuyerSignUpView() async {
    await _navigationService.navigateTo(Routes.buyerSignupView);
  }

  /// Navigate to Login View
  Future<void> navigateToLoginView() async {
    await _navigationService.navigateTo(Routes.loginView);
  }
}
