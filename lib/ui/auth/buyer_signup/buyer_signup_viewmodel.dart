import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mipromo/api/auth_api.dart';
import 'package:mipromo/app/app.locator.dart';
import 'package:mipromo/app/app.router.dart';
import 'package:mipromo/exceptions/auth_api_exception.dart';
import 'package:mipromo/ui/auth/buyer_signup/email_verify.dart';
import 'package:mipromo/ui/shared/helpers/alerts.dart';
import 'package:mipromo/ui/shared/helpers/data_models.dart';
import 'package:mipromo/ui/shared/helpers/enums.dart';
import 'package:mipromo/ui/shared/helpers/validators.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class BuyerSignupViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _snackbarService = locator<SnackbarService>();
  final _dialogService = locator<DialogService>();
  final _authApi = locator<AuthApi>();
  final currentuser = User;
  bool termsCheckBoxValue = false;

  bool isPasswordVisible = false;
  bool validateForm = false;
  String email = "";
  String password = "";
  String code1 = "";

  void toggleTermsCheckBoxValue({
    required bool value,
  }) {
    termsCheckBoxValue = value;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    notifyListeners();
  }

  void showErrors() {
    validateForm = true;
    notifyListeners();
  }

  // Sign Up as Buyer
  Future signUp() async {
    final bool isFormNotEmpty = email.isNotEmpty && password.isNotEmpty;

    final bool isFormValid = Validators.emailValidator(email) == null &&
        Validators.passwordValidator(password) == null;

    if (isFormNotEmpty && isFormValid) {
      if (termsCheckBoxValue == true) {
        _signUpBuyer();
      } else {
        _snackbarService.showCustomSnackBar(
          variant: AlertType.error,
          message: 'Please agree terms and conditions to continue',
          duration: const Duration(seconds: 2),
        );
      }
    } else {
      showErrors();
    }
  }

  Future verify(code,email) async {
  
    if (code.toString() == code1) {
      await verifiedemail(email);
      _navigateToLoginView();
    } else {
      await Alerts.showServerErrorDialog(
        'Wrong Code',
      );
    }
  }

  Future _signUpBuyer() async {
    setBusy(true);

    try {
      final User user = await _authApi.signUpWithEmail(
        email: email,
        password: password,
      );

      if (user.uid.isNotEmpty) {
        // final bool result = await _authApi.sendEmailVerification(user);
        var rng = new Random();
        var rand = rng.nextInt(900000) + 100000;
        int number = rand.toInt();
        String? email = user.email;
        Dio dio = Dio();

        var url = 'http://tritec.store/mipromo/public/api/account/verify';
        var data = {'email': email,'code':number};

        var result = await dio.post(url, data: data);
        var response = jsonDecode(result.toString());
        print(result);
        if (response['error'] == false) {
          _navigateToEmailverifyView(number,user.email);
        }

        // if (result) {
        //   final DialogResponse? dialogResponse =
        //       await _dialogService.showCustomDialog(
        //     variant: AlertType.info,
        //     title: 'Email Sent',
        //     customData: CustomDialogData(
        //       hasRichDescription: true,
        //       richDescription:
        //           'A verification email has been sent to ${user.email}. Please verify your email to get access.',
        //       richData: "",
        //       richDescriptionExtra: '',
        //     ),
        //   );

        //   if (dialogResponse != null && dialogResponse.confirmed) {
        //     _navigateToLoginView();
        //   }
        // } else {
        //   await Alerts.showServerErrorDialog(
        //     'Failed to send Verification Email, please try again later.',
        //   );
        // }

      }
    } on AuthApiException catch (e) {
      await Alerts.showBasicFailureDialog(
        e.title,
        e.message,
      );
    }

    setBusy(false);
  }

  Future verifiedemail(email) async {
    setBusy(true);

   

    
   
        Dio dio = Dio();

        var url = 'http://tritec.store/mipromo/public/api/add/verify/email';
        var data = {'email': email,};

        var result = await dio.post(url, data: data);
        var response = jsonDecode(result.toString());
        print(result);
  
      


 

    setBusy(false);
  }

  Future _navigateToLoginView() async {
    _navigationService.popUntil(
      (route) => route.settings.name == Routes.landingView,
    );

    await _navigationService.navigateTo(
      Routes.loginView,
    );
  }

  Future _navigateToEmailverifyView(code,email) async {
    await _navigationService.navigateTo(Routes.emailVerify,
        arguments: EmailVerifyArguments(code: code,email: email));
  }
}
