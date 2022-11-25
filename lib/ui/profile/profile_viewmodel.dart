import 'package:mipromo/api/auth_api.dart';
import 'package:mipromo/app/app.locator.dart';
import 'package:mipromo/app/app.router.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ProfileViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _authApi = locator<AuthApi>();

  Future<void> navigateToCreateShopView(AppUser user) async {
    await _navigationService.navigateTo(
      Routes.createShopView,
      arguments: CreateShopViewArguments(user: user),
    );
  }

  Future<void> navigateToEditProfile(AppUser user) async {
    
    await _navigationService.navigateTo(
      Routes.sellerEditProfileView,
      arguments: SellerEditProfileViewArguments(user: user),
    );
  }

  Future<void> signOut() async {
    final response = await _dialogService.showConfirmationDialog(
      title: 'Are you sure you want to logout?',
    );

    if (response?.confirmed ?? false) {
      await _authApi.logout();

      _navigationService.popUntil(
        (route) => route.settings.name == Routes.mainView,
      );
      await _navigationService.replaceWith(Routes.startUpView);
    } else {
      _navigationService.back();
    }
  }
}
