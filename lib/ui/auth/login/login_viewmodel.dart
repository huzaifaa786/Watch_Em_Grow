import 'dart:io' show Platform;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mipromo/api/auth_api.dart';
import 'package:mipromo/app/app.locator.dart';
import 'package:mipromo/app/app.router.dart';
import 'package:mipromo/exceptions/auth_api_exception.dart';
import 'package:mipromo/models/app_user.dart';
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

  Future<void> _login() async {
    setBusy(true);

    try {
      final User user = await _authApi.loginWithEmail(
        email: loginEmail,
        password: loginPassword,
      );
      if (user.emailVerified) {
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
        ).whenComplete(
          () async {
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
            final bool result = await _authApi.sendEmailVerification(user);

            if (result) {
              await _dialogService.showCustomDialog(
                variant: AlertType.info,
                title: 'Email Sent',
                customData: CustomDialogData(
                  hasRichDescription: true,
                  richDescription: 'A verification email has been sent to ',
                  richData: user.email,
                ),
              );
            } else {
              await Alerts.showServerErrorDialog(
                'Failed to send Verification Email, please try again later.',
              );
            }
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

  Future<void> _navigateToMainView() async {
    await _navigateToLandingView();

    await _navigationService.replaceWith(Routes.mainView);
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
            richDescription: 'A password reset link has been sent to ${forgotPasswordEmail}',
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
