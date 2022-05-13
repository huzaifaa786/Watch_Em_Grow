import 'package:flutter/material.dart';
import 'package:mipromo/api/database_api.dart';
import 'package:mipromo/app/app.router.dart';
import 'package:mipromo/api/paypal_api.dart';
import 'package:mipromo/app/app.locator.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/models/order.dart';
import 'package:mipromo/models/shop_service.dart';
import 'package:mipromo/ui/shared/helpers/enums.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:webview_flutter/webview_flutter.dart';

class paypalVerificationViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _databaseApi = locator<DatabaseApi>();
  final _paypalApi = locator<PaypalApi>();
  final _dialogService = locator<DialogService>();

  String? accessToken;
  String? verifyUrl = 'https://www.paypal.com/connect/?flowEntry=static&response_type=code&scope=openid%20profile%20email&client_id=Aa6veR5J_GbKz7IrpxHcdbMMlqBLrTUuAJuHx5e5uQqTsBk3h1R5TJBFCtQajBqhY9HIChSS_W_olNNm&redirect_uri=https://mipromo.com/';
  String? executeUrl;
  String? paymentId;
  bool isWebviewLoading = true;

  final String email;

  paypalVerificationViewModel(this.email);

  void init() {
    Future.delayed(Duration.zero, () async {
      try {
        /*accessToken = await _paypalApi.getVerificationAccessToken();
        if (accessToken != null) {
          print('Access Token: ' + accessToken!);
          //_navigationService.back();
          setBusy(false);
        }*/
      } catch (e) {
        _dialogService.showCustomDialog(
            variant: AlertType.error,
            title: 'Error',
            description: e.toString());
      }
    });
  }

  Future<NavigationDecision> handleWebViewVerification(NavigationRequest request) async {
    if (request.url.contains('https://mipromo.com/')) {
      final uri = Uri.parse(request.url);
      final authCode = uri.queryParameters['code'];
      isWebviewLoading = true;
      notifyListeners();
      await _paypalApi.getCustomerAccessToken(authCode!).then((accessToken) async {
        await _paypalApi.getUserInfo(accessToken!).then((value){
          isWebviewLoading = false;
          notifyListeners();
          if(value! == email){
            _navigationService.back(result: true);
          }else{
            _navigationService.back(result: false);
          }
        });

      });
    }else{
      print('Failed');
    }
    return NavigationDecision.navigate;
  }

  void setIsWebviewLoading({required bool loading}) {
    isWebviewLoading = loading;
    notifyListeners();
  }
}