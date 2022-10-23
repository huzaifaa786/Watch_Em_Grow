import 'dart:async';

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

class connectStripeViewModel extends BaseViewModel {
  final _databaseApi = locator<DatabaseApi>();
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _paypalApi = locator<PaypalApi>();
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  bool isWebviewLoading = true;

  // String connectUrl =
  //     'https://connect.stripe.com/oauth/authorize?response_type=code&client_id=ca_M5OewgfEWvHw7auL4XNmWRY9BgIT1hLP&scope=read_write&redirect_uri=http%3A%2F%2Ftritec.store%2Fmipromo%2Fpublic%2Fredirect';

  // void init() {
  //   Future.delayed(Duration.zero, () async {
  //     try {
  //       /*accessToken = await _paypalApi.getVerificationAccessToken();
  //       if (accessToken != null) {
  //         print('Access Token: ' + accessToken!);
  //         //_navigationService.back();
  //         setBusy(false);
  //       }*/
  //     } catch (e) {
  //       _dialogService.showCustomDialog(variant: AlertType.error, title: 'Error', description: e.toString());
  //     }
  //   });
  // }

  // Future<NavigationDecision> handleWebViewVerification(NavigationRequest request) async {

  //   if (request.url.contains('http://tritec.store/mipromo/public/redirect')) {
      
  //     _navigationService.back(result: true);
  //   }
  //   else{
  //     _navigationService.back(result: false);

  //   }
  //     return NavigationDecision.navigate;

  // }

  // void setIsWebviewLoading({required bool loading}) {
  //   isWebviewLoading = loading;
  //   notifyListeners();
  // }
}
