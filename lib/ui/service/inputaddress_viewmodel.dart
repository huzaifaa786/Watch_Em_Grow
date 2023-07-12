import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mipromo/api/database_api.dart';
import 'package:mipromo/app/app.locator.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/models/shop_service.dart';
import 'package:mipromo/services/user_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:http/http.dart' as http;

class InputAddressViewModel extends BaseViewModel {
  final _userService = locator<UserService>();
  final _databaseApi = locator<DatabaseApi>();
  final _navigationService = locator<NavigationService>();
  AppUser? user;
  String fullName = '';
  String address = '';
  String postCode = '';
  int step = 0;
  String paymentIntent = '';
  final client = http.Client();
   late final ShopService service;
  static Map<String, String> headers = {
    'Authorization':
        'Bearer sk_test_51IVZcBDoZl8DJ0XN2B6ryI8a1tssqoDcso3P1IDP7GxJ1qtmPnCGh9Ywap5fBwmQkGB5LIX4luKiWLlg202VvuJU00KKpdAkHt',
    'Content-Type': 'application/x-www-form-urlencoded'
  };
  Future<void> init() async {
    setBusy(true);
    await _userService.syncUser();
    user = _userService.currentUser;
    fullName = user!.fullName;
    address = user!.address;
    postCode = user!.postCode;
    notifyListeners();
    setBusy(false);
  }

  void setName(String name) {
    fullName = name;
    notifyListeners();
  }

  void setAddress(String address) {
    this.address = address;
    notifyListeners();
  }

  void setPostCode(String postCode) {
    this.postCode = postCode;
    notifyListeners();
  }


  Future updateAddress() async {
    if (address != user!.address || postCode != user!.postCode || fullName != user!.fullName) {
      setBusy(true);
      _databaseApi
          .updateAddress(
        userId: user!.id,
        fullName: fullName,
        address: address,
        postCode: postCode,
      )
          .then((value) {
        setBusy(false);
        _createTestPaymentSheet;
      });
    } else {
      _navigationService.back(result: true);
    }
  }
 
 Future _createTestPaymentSheet() async {
    final url =
        Uri.parse('https://watchemgrow.klickwash.net/api/createpaymentIntent');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'a': 'a',
        'price': service.depositAmount,
        'connected_account': 'acct_1M7iQrRTmuR2qUZU'
      }),
    );
    final body = json.decode(response.body);
    final data = jsonDecode(body['intent'].toString());

    paymentIntent = data['intent']['id'].toString();

    return data;
  }

 
  Future<void> initPaymentSheet() async {
    // try {
    // 1. create payment intent on the server

    final data = await _createTestPaymentSheet();

    // create some billingdetails
    final billingDetails = BillingDetails(
      name: 'Flutter Stripe',
      email: 'email@stripe.com',
      phone: '+48888000888',
      address: Address(
        city: 'Houston',
        country: 'US',
        line1: '1459  Circle Drive',
        line2: '',
        state: 'Texas',
        postalCode: '77063',
      ),
    ); // mocked data for tests

    // 2. initialize the payment sheet
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        // Main params
        paymentIntentClientSecret: data['paymentIntent'].toString(),

        merchantDisplayName: 'Watch_Em_Grow',
        // Customer params
        customerId: data['customer'].toString(),
        customerEphemeralKeySecret: data['ephemeralKey'].toString(),
        // Extra params
        applePay: true,
        googlePay: true,
        style: ThemeMode.dark,
        // billingDetails: billingDetails,
        testEnv: true,
        merchantCountryCode: 'GBP',
      ),
    );
    step = 1;
    // } catch (e) {
    //   Fluttertoast.showToast(msg: 'Error: $e');
    //   rethrow;
    // }
  }

  Future<bool> confirmPayment() async {
    print("Asdfasdfsdfasfd");
    final x;
    try {
      // 3. display the payment sheet.
      await Stripe.instance.presentPaymentSheet();

      step = 0;

      Fluttertoast.showToast(msg: 'Payment succesfully completed');
      return true;
    } on Exception catch (e) {
      if (e is StripeException) {
        Fluttertoast.showToast(
            msg: 'Error from Stripe: ${e.error.localizedMessage}');
        return false;
      } else {
        Fluttertoast.showToast(msg: 'Unforeseen error: ${e}');
        return false;
      }
    }
  }

  
}
