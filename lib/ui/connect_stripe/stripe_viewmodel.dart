import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mipromo/api/database_api.dart';
import 'package:mipromo/api/paypal_api.dart';
import 'package:mipromo/app/app.locator.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/ui/shared/helpers/enums.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class connectStripeViewModel extends BaseViewModel {
  final _databaseApi = locator<DatabaseApi>();
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _paypalApi = locator<PaypalApi>();
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  late WebViewController ccontroller;
  bool isWebviewLoading = true;
  String connectUrl = '';

  final _firebaseAuth = FirebaseAuth.instance;

  /// Fetch the current Firebase User
  User? get currentUser => _firebaseAuth.currentUser;

  // String connectUrl =
  //     'https://connect.stripe.com/oauth/authorize?response_type=code&client_id=ca_M5OewgfEWvHw7auL4XNmWRY9BgIT1hLP&scope=read_write&redirect_uri=http%3A%2F%2Ftritec.store%2Fmipromo%2Fpublic%2Fredirect';

  // String connectUrl =
  //     'https://connect.stripe.com/express/oauth/authorize?response_type=code&client_id=ca_M5OewgfEWvHw7auL4XNmWRY9BgIT1hLP&redirect_uri=http%3A%2F%2Ftore%2Fmipromo%2Fpublic%2Fredirect';
  // String connectUrl =
  //     'https://connect.stripe.com/setup/e/acct_1M7Bj9IT7ZExORx2/YlbviveWBqR3';

  void init() {
    print(currentUser);
    Future.delayed(Duration.zero, () async {
      try {
        Dio dio = Dio();
        final url = 'http://tritec.store/mipromo/public/api/stripe/connect';
        final result = await dio.get(url);
        final response = jsonDecode(result.toString());
        final ac_id = response['account']['id'];
       
        final uname =
            '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';
        final pword = '';
        final authn = 'Basic ' + base64Encode(utf8.encode('$uname:$pword'));

        final headers = {
          'Content-Type': 'application/x-www-form-urlencoded',
          'Authorization': authn,
        };

        final data =
            'account=$ac_id&refresh_url=https://miypromo.com/reauth&return_url=https://miypromo.com/return&type=account_onboarding';

        final url2 = Uri.parse('https://api.stripe.com/v1/account_links');
        final res = await http.post(url2, headers: headers, body: data);
        
        final res2 = jsonDecode(res.body.toString());
        print(res2);
        final link = res2['url'];
        connectUrl = link.toString();
        await launch(connectUrl);
        await Future.delayed(Duration(milliseconds: 100));
        while (WidgetsBinding.instance?.lifecycleState !=
            AppLifecycleState.resumed) {
          await Future.delayed(Duration(milliseconds: 100));
        }
        final url4 = Uri.parse('https://api.stripe.com/v1/accounts/$ac_id');
        final res4 = await http.get(url4, headers: {'Authorization': authn});
        if (res4.statusCode != 200)
          throw Exception('http.get error: statusCode= ${res4.statusCode}');

        final res3 = jsonDecode(res4.body.toString());
        if (res3['details_submitted'] == true) {
          await _databaseApi.connectStripe(
              userId: currentUser!.uid, accountId: ac_id.toString());

          _navigationService.back(result: true);
          _dialogService.showCustomDialog(
              variant: AlertType.success,
              title: 'Success',
              description: 'Stripe account connected Succesfully!');
        } else {
          _navigationService.back(result: true);
          _dialogService.showCustomDialog(
              variant: AlertType.error,
              title: 'Error',
              description: 'Stripe account not connected try again!');
        }
        // var url3 = Uri.parse('https://api.stripe.com/v1/customers');
        // var res3 = await http.post(url3, headers: {'Authorization': authn});
        // if (res3.statusCode != 200)
        //   throw Exception('http.post error: statusCode= ${res3.statusCode}');
        // print(res3.body);

        // // print(res2['url'].toString());
        // if (res.statusCode != 200)
        //   throw Exception('http.post error: statusCode= ${res.statusCode}');

        // launch(connectUrl);
        // Stripe.instance
        //    final result = await Stripe.instance.(
        //   clientSecret: clientSecret,
        // );

        // Stripe.instance.retrievePaymentIntent('');
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

  Future<NavigationDecision> handleWebViewVerification(
      NavigationRequest request) async {
    if (request.url.contains('https://miypromo.com/return')) {
      // _navigationService.back(result: true);
    } else {
      // _navigationService.back(result: false);
    }
    return NavigationDecision.navigate;
  }

  void setIsWebviewLoading({required bool loading}) {
    isWebviewLoading = loading;
    notifyListeners();
  }
}
