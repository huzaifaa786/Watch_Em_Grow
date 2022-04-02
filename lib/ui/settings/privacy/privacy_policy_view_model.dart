import 'package:mipromo/api/database_api.dart';
import 'package:mipromo/api/paypal_api.dart';
import 'package:mipromo/app/app.locator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class PrivacyPolicyViewModel extends BaseViewModel {
  bool isWebviewLoading = true;

  PrivacyPolicyViewModel();
  void init() {

  }

  void setIsWebviewLoading({required bool loading}) {
    isWebviewLoading = loading;
    notifyListeners();
  }
}
