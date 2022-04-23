import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mipromo/api/auth_api.dart';
import 'package:mipromo/app/app.locator.dart';
import 'package:mipromo/app/app.router.dart';
import 'package:mipromo/services/user_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _authApi = locator<AuthApi>();
  final _userService = locator<UserService>();
  final _firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => _firebaseAuth.currentUser;
  late bool isDarkMode;

  void init({
    required bool isDark,
  }) {
    setBusy(true);

    isDarkMode = isDark;
    notifyListeners();

    setBusy(false);
  }

  void toggleTheme({
    required bool isDark,
  }) {
    isDarkMode = isDark;
    notifyListeners();
  }

  void pop() {
    _navigationService.back();
  }

  Future<void> signOut() async {
    await _authApi.logout();

    _navigationService.popUntil(
      (route) => route.settings.name == Routes.mainView,
    );
    await _navigationService.replaceWith(Routes.startUpView);
  }

  Future<void> deactivate() async {
    var rng = new Random();
    var rand = rng.nextInt(900000) + 100000;
    print(rand.toInt());
    Dio dio = Dio();
    String? email = currentUser!.email;
    var url = 'http://tritec.store/mipromo/public/api/deactivate/account';
    var data = {'email': email};

    var result = await dio.post(url, data: data);
    var response = jsonDecode(result.toString());

    if (response['error'] == false) {
      Fluttertoast.showToast(msg: 'Your request sent successfully');
    }
  }

  Future launchTermsUrl() async {
    await launch('https://www.sadje.org/copy-of-privacy');
  }

  Future launchPrivacyUrl() async {
    await launch('https://www.sadje.org/privacy');
  }

  Future launchAboutUsUrl() async {
    await launch('https://www.sadje.org/copy-of-privacy-policy');
  }

  Future<void> navigateToTermsView() async {
    await _navigationService.navigateTo(Routes.termsAndConditionsView);
  }

  Future<void> navigateToPolicyView() async {
    await _navigationService.navigateTo(
      Routes.privacyPolicyView,
      arguments:
          PrivacyPolicyViewArguments(url: 'https://www.sadje.org/privacy'),
    );
  }

  Future<void> navigateToAboutView() async {
    await _navigationService.navigateTo(
      Routes.aboutView,
      arguments: PrivacyPolicyViewArguments(
          url: 'https://www.sadje.org/copy-of-privacy-policy'),
    );
  }

  Future<void> navigateToHelpView() async {
    await _navigationService.navigateTo(Routes.helpView);
  }
}
