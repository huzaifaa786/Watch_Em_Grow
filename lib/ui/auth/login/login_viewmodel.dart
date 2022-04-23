import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mipromo/api/auth_api.dart';
import 'package:mipromo/app/app.locator.dart';
import 'package:mipromo/app/app.router.dart';
import 'package:mipromo/exceptions/auth_api_exception.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/api/database_api.dart';

import 'package:mipromo/services/user_service.dart';
import 'package:mipromo/ui/shared/helpers/data_models.dart';
import 'package:mipromo/ui/shared/helpers/enums.dart';
import 'package:mipromo/ui/shared/helpers/validators.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:mipromo/ui/shared/helpers/alerts.dart';
import 'package:uuid/uuid.dart';

class LoginViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _authApi = locator<AuthApi>();
  final _databaseApi = locator<DatabaseApi>();
  late AppUser _currentUser;
  AppUser get currentUser => _currentUser;
  final _userService = locator<UserService>();

  bool isPasswordVisible = false;

  bool validateForm = false;

  String loginEmail = "";
  String loginPassword = "";

  String forgotPasswordEmail = "";

  final _referCode = const Uuid().v4().substring(0, 6);

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void showErrors() {
    validateForm = true;
    notifyListeners();
  }

  Future<void> navigateToForgotPasswordView() async {
    await _navigationService.navigateTo(Routes.forgotPasswordView);
  }

  /// Login
  Future<void> login() async {
    final bool isFormNotEmpty =
        loginEmail.isNotEmpty && loginPassword.isNotEmpty;

    final bool isFormValid = Validators.emailValidator(loginEmail) == null &&
        Validators.passwordValidator(loginPassword) == null;

    if (isFormNotEmpty && isFormValid) {
      await _login();
    } else {
      showErrors();
    }
  }

  Future<void> notificationInit() async {
    final FirebaseMessaging messaging = FirebaseMessaging.instance;
    final NotificationSettings settings = await messaging.requestPermission();
    if (settings.authorizationStatus != AuthorizationStatus.authorized) {
      await _dialogService.showCustomDialog(
        variant: AlertType.warning,
        title: 'Notifiaction permission denied',
      );
    }
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
    if (Platform.isAndroid) {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        'This channel is used for important notifications.', // description
        importance: Importance.max,
      );
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
  }

  Future<void> setCurrentUser(id) async {
    _databaseApi.listenUser(id.toString()).listen(
      (user) {
        _currentUser = user;
        notifyListeners();
        setBusy(false);
      },
    );
    print("current user");
    print(_currentUser);
  }

  Future verifiedemail(email) async {
    setBusy(true);

    Dio dio = Dio();

    var url = 'http://tritec.store/mipromo/public/api/check/email';
    var data = {
      'email': email,
    };

    var result = await dio.post(url, data: data);
    var response = jsonDecode(result.toString());
    print(response);
    if (response['error'] == false) {
      return true;
    }

    setBusy(false);
  }

  Future<void> _login() async {
    setBusy(true);

    try {
      if (await verifiedemail(loginEmail) == true) {
        final User user = await _authApi.loginWithEmail(
          email: loginEmail,
          password: loginPassword,
        );

        notificationInit();
        final token = await FirebaseMessaging.instance.getToken();
        await _userService
            .syncOrCreateUser(
          user: AppUser(
            id: user.uid,
            token: token,
            email: user.email,
            referCode: _referCode,
          ),
        )
            .whenComplete(
          () async {
            await setCurrentUser(user.uid);
            await _navigateToMainView();
          },
        );
      } else {
        final DialogResponse? dialogResponse =
            await _dialogService.showCustomDialog(
          variant: AlertType.warning,
          title: 'Email Not Verified',
          description: 'Please verify your Email to Login.',
          mainButtonTitle: 'Resend',
          customData: CustomDialogData(
            isConfirmationDialog: true,
          ),
        );

        if (dialogResponse != null && dialogResponse.confirmed) {
          try {
            await Sendverification();
          } on AuthApiException catch (e) {
            await Alerts.showBasicFailureDialog(
              e.title,
              e.message,
            );
          }
        }
      }
    } on AuthApiException catch (e) {
      print(e.message.toString());
      await Alerts.showBasicFailureDialog(
        e.title,
        'Invalid email or password',
      );
    }

    setBusy(false);
  }

  Future Sendverification() async {
    setBusy(true);

    var rng = new Random();
    var rand = rng.nextInt(900000) + 100000;
    int number = rand.toInt();
    String? email = loginEmail;
    Dio dio = Dio();

    var url = 'http://tritec.store/mipromo/public/api/account/verify';
    var data = {'email': email, 'code': number};

    var result = await dio.post(url, data: data);
    var response = jsonDecode(result.toString());
    print(result);
    if (response['error'] == false) {
      _navigateToEmailverifyView(number, loginEmail);
    }

    setBusy(false);
  }

  Future _navigateToEmailverifyView(code, email) async {
    await _navigationService.navigateTo(Routes.emailVerify,
        arguments: EmailVerifyArguments(code: code, email: email));
  }

  Future<void> _navigateToMainView() async {
    await _navigateToLandingView();
    if (_currentUser.username.isEmpty) {
      await _navigationService.replaceWith(Routes.mainView);
    } else {
      await _navigationService.replaceWith(Routes.discoverPage);
    }
  }

  Future<void> _navigateToLandingView() async {
    _navigationService.popUntil(
      (route) => route.settings.name == Routes.landingView,
    );
  }

  /// Forgot Password
  Future forgotPassword() async {
    if (forgotPasswordEmail.isNotEmpty &&
        Validators.emailValidator(forgotPasswordEmail) == null) {
      _forgotPassword();
    } else {
      showErrors();
    }
  }

  Future _forgotPassword() async {
    setBusy(true);

    try {
      final result = await _authApi.forgotPassword(
        email: forgotPasswordEmail,
      );

      if (result) {
        final DialogResponse? dialogResponse =
            await _dialogService.showCustomDialog(
          variant: AlertType.info,
          title: 'Password reset',
          customData: CustomDialogData(
            hasRichDescription: true,
            richDescription:
                'A password reset link has been sent to ${forgotPasswordEmail}',
            richData: '',
          ),
        );

        if (dialogResponse != null && dialogResponse.confirmed) {
          _navigateToLandingView();
        }
      } else {
        await Alerts.showServerErrorDialog(
          'Failed to send password reset email, please try again later.',
        );
      }
    } on AuthApiException catch (e) {
      Alerts.showBasicFailureDialog(
        e.title,
        e.message,
      );
    }

    setBusy(false);
  }
}
