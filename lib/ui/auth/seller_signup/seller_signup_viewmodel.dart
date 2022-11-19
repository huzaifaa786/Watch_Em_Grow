import 'package:flutter/cupertino.dart';
import 'package:mipromo/api/database_api.dart';
import 'package:mipromo/api/paypal_api.dart';
import 'package:mipromo/app/app.locator.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/ui/profile/buyer/paypal_verification_view.dart';
import 'package:mipromo/ui/shared/helpers/enums.dart';
import 'package:mipromo/ui/shared/helpers/validators.dart';
import 'package:mipromo/app/app.router.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SellerSignupViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _databaseApi = locator<DatabaseApi>();
  static final SnackbarService _snackbarService = locator<SnackbarService>();

  late AppUser currentUser;

  String name = "";
  String phoneNumber = "";
  String paypalMail = "";
  DateTime? selectedDate;

  bool validateForm = false;

  void init(AppUser user) {
    setBusy(true);

    currentUser = user;
    notifyListeners();

    setBusy(false);
  }

  Future<void> selectDate(Future<DateTime?> pickedDate) async {
    final date = await pickedDate;

    if (date != selectedDate) {
      selectedDate = date;
      notifyListeners();
    }
  }

  void showErrors() {
    validateForm = true;
    notifyListeners();
  }

  // Sign Up
  Future signUp() async {
    final bool isFormValid = _isFormValid();

    if (isFormValid) {
      //_createSellerAccount();
      createConnectedAccount();
      _verifyPaypalAccount();
    } else {
      showErrors();
    }
  }

  Future _verifyPaypalAccount() async {
    if (await _navigationService.navigateTo(Routes.paypalVerificationView,
            arguments: PaypalVerificationViewArguments(email: paypalMail)) ==
        true) {
      _createSellerAccount();
    } else {
      _snackbarService.showCustomSnackBar(
        variant: AlertType.error,
        title: "Try again",
        message: "Paypal verification failed",
      );
    }

    /*_navigationService.navigateTo(Routes.paypalVerificationView,
    arguments: PaypalVerificationViewArguments(email: paypalMail));*/
  }

  createConnectedAccount() async { 
        if (await _navigationService.navigateTo(Routes.connectStripeView) ==
        true) {
      _createSellerAccount();
    } else {
      _snackbarService.showCustomSnackBar(
        variant: AlertType.error,
        title: "Try again",
        message: "Stripe connect account registration failed",
      );
    }
  }

  bool _isFormValid() {
    final bool isFormEmpty = name.isEmpty && phoneNumber.isEmpty && paypalMail.isEmpty;

    final bool isFieldsValid = Validators.emptyStringValidator(name, 'Name') == null &&
        Validators.emptyStringValidator(phoneNumber, 'Phone Number') == null &&
        Validators.emptyStringValidator(paypalMail, 'Mail Id') == null &&
        Validators.dobValidator(
              dob: selectedDate.toString(),
              age: DateTime.now().year - selectedDate!.year,
            ) ==
            null;

    if (!isFormEmpty && isFieldsValid) {
      return true;
    } else {
      return false;
    }
  }

  Future _createSellerAccount() async {
    setBusy(true);
    await _databaseApi
        .createSellerAccount(
          userId: currentUser.id,
          dateOfBirth: selectedDate.toString(),
          fullName: name,
          phoneNumber: phoneNumber,
          paypalMail: paypalMail,
        )
        .whenComplete(
          () => _navigationService.back(),
        );
    setBusy(false);
  }
}
