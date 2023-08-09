import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:mipromo/api/database_api.dart';
import 'package:mipromo/app/app.locator.dart';
import 'package:mipromo/app/app.router.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/models/shop.dart';
import 'package:mipromo/ui/shared/helpers/alerts.dart';
import 'package:mipromo/ui/shared/helpers/constants.dart';
import 'package:mipromo/ui/shared/helpers/enums.dart';
import 'package:mipromo/ui/shared/helpers/validators.dart';
import 'package:mipromo/ui/value/stripe_key.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:uuid/uuid.dart';
import 'package:mipromo/api/auth_api.dart';
import 'package:http/http.dart' as http;

class SubscriptionViewModel extends BaseViewModel {
  final _authApi = locator<AuthApi>();
  final _navigationService = locator<NavigationService>();
  final _databaseApi = locator<DatabaseApi>();
  final _dialogService = locator<DialogService>();

  late AppUser currentUser;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late final paymentMethod;
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expiryDateController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  final client = http.Client();
  static Map<String, String> headers = {
    'Authorization': private_key,
    'Content-Type': 'application/x-www-form-urlencoded'
  };

  void init(AppUser user) {
    setBusy(true);

    currentUser = user;

    notifyListeners();

    setBusy(false);
  }

  String selectedFontStyle = "Default";

  int selectedTheme = 0xff828CFC;

  Future<void> subscriptions() async {
    setBusy(true);
    try {
      final customer = await _createCustomer();
      final paymentMethod = await _createPaymentMethod(
          number: cardNumberController.text,
          expMonth:
              int.parse(expiryDateController.text.split("/")[0]).toString(),
          expYear:
              int.parse(expiryDateController.text.split("/")[1]).toString(),
          cvc: cvvController.text);
      await _attachPaymentMethod(
          paymentMethod['id'].toString(), customer['id'].toString());
      await _updateCustomer(
          paymentMethod['id'].toString(), customer['id'].toString());
      await _createSubscriptions(customer['id'].toString());
      final userId = _authApi.currentUser!.uid;
      await _databaseApi.updateUserStatus(userId);

      await _dialogService.showCustomDialog(
          variant: AlertType.success,
          title: 'Success',
          description: 'Watch Em Grow Premium Subscribed Successfully');
    } catch (e) {
      Alerts.showErrorSnackbar('Payment Failed');
    }
    setBusy(false);
  }

  Future<dynamic> _createCustomer() async {
    try {} catch (e) {}
    final String url = 'https://api.stripe.com/v1/customers';
    var response = await client.post(
      Uri.parse(url),
      headers: headers,
      body: {'email': currentUser.email},
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print(json.decode(response.body));
      throw 'Failed to register as a customer.';
    }
  }

  Future<dynamic> _createPaymentMethod(
      {required String number,
      required String expMonth,
      required String expYear,
      required String cvc}) async {
    final String url = 'https://api.stripe.com/v1/payment_methods';
    var response = await client.post(
      Uri.parse(url),
      headers: headers,
      body: {
        'type': 'card',
        'card[number]': '$number',
        'card[exp_month]': '$expMonth',
        'card[exp_year]': '$expYear',
        'card[cvc]': '$cvc',
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print(json.decode(response.body));
      throw 'Failed to create PaymentMethod.';
    }
  }

  Future<dynamic> _attachPaymentMethod(
      String paymentMethodId, String customerId) async {
    final String url =
        'https://api.stripe.com/v1/payment_methods/$paymentMethodId/attach';
    var response = await client.post(
      Uri.parse(url),
      headers: headers,
      body: {
        'customer': customerId,
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print(json.decode(response.body));
      throw 'Failed to attach PaymentMethod.';
    }
  }

  Future<dynamic> _updateCustomer(
      String paymentMethodId, String customerId) async {
    final String url = 'https://api.stripe.com/v1/customers/$customerId';

    var response = await client.post(
      Uri.parse(url),
      headers: headers,
      body: {
        'invoice_settings[default_payment_method]': paymentMethodId,
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print(json.decode(response.body));
      throw 'Failed to update Customer.';
    }
  }

  Future<dynamic> _createSubscriptions(String customerId) async {
    final String url = 'https://api.stripe.com/v1/subscriptions';

    Map<String, dynamic> body = {
      'customer': customerId,
      'items[0][price]': 'price_1MhAL6IyrTaw9Whhcs3b2SQO',
    };

    var response =
        await client.post(Uri.parse(url), headers: headers, body: body);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      print(json.decode(response.body));
      throw 'Failed to register as a subscriber.';
    }
  }
}
