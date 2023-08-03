import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mipromo/api/api.dart';
import 'package:mipromo/api/database_api.dart';
import 'package:mipromo/app/app.locator.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/models/order.dart';
import 'package:mipromo/models/shop.dart';
import 'package:mipromo/models/shop_service.dart';
import 'package:mipromo/services/user_service.dart';
import 'package:mipromo/ui/home/home_view.dart';
import 'package:mipromo/ui/shared/helpers/enums.dart';
import 'package:mipromo/ui/shared/helpers/validators.dart';
import 'package:mipromo/ui/value/stripe_key.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class InputAddressViewModel extends BaseViewModel {
  final _userService = locator<UserService>();
  final _databaseApi = locator<DatabaseApi>();
  final _snackbarService = locator<SnackbarService>();
  final _dialogService = locator<DialogService>();
  final _navigationService = locator<NavigationService>();
  AppUser? user;
  String fullName = '';
  String address = '';
  String postCode = '';
  String cardNum = '';
  String expYears = '';
  String expMonths = '';
  String cardCvc = '';
  String serviceAmount = '';
  String productKey = '';
  String productPrice = '';
  int step = 0;
  String paymentIntent = '';
  bool validateForm = false;
  final client = http.Client();
  var responceData;
  ShopService? service;
  static Map<String, String> headers = {
    'Authorization': private_key,
    'Content-Type': 'application/x-www-form-urlencoded'
  };
  Future<void> init(ShopService myservice) async {
    setBusy(true);
    await _userService.syncUser();
    user = _userService.currentUser;
    fullName = user!.fullName;
    address = user!.address;
    postCode = user!.postCode;
    service = myservice;
    notifyListeners();
    setBusy(false);
  }

  void setName(String name) {
    fullName = name;
    notifyListeners();
  }

  void setcardNumber(String cardNumber) {
    cardNum = cardNumber;
    notifyListeners();
  }

  void setproductKey(String producyKey) {
    productKey = producyKey;
    notifyListeners();
  }

  void setexpYear(String expYear) {
    expYears = expYear;
    notifyListeners();
  }

  void setexpMonth(String expMonth) {
    expMonths = expMonth;
    notifyListeners();
  }

  void setCvv(String cvc) {
    cardCvc = cvc;
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

  // Future updateAddress() async {

  //   subscriptions();

  //   // if (fullName != user!.fullName) {
  //   // setBusy(true);
  //   // _databaseApi
  //   //     .updateAddress(
  //   //   userId: user!.id,
  //   //   fullName: fullName,
  //   //   address: address,
  //   //   postCode: postCode,
  //   // )
  //   //     .then((value) {
  //   //   // createCustomer(
  //   //   //   user!.email.toString(),
  //   //   //   user!.phoneNumber.toString(),
  //   //   //   user!.fullName.toString(),
  //   //   // );
  //   //   subscriptions();
  //   //   // createPaymentIntent(service!.price.toInt());
  //   //   setBusy(false);
  //   // });
  //   // } else {
  //   //   _navigationService.back(result: true);
  //   // }
  // }

  /// STRIPE RECURRING PAYMENT////////

  void _init() {
    Stripe.publishableKey =
        'pk_test_51JvIZ1Ey3DjpASZjPAzcOwqhblOq2hbchp6i56BsjapvhWcooQXqh33XwCrKiULfAe7NKFwKUhn2nqURE7VZcXXf00wMDzp4';
  }

  Future<dynamic> createCustomer(
      String email, String name, String phone) async {
    log(user!.phoneNumber.toString());
    final response = await http.post(
      Uri.parse('https://api.stripe.com/v1/customers'),
      headers: {'Authorization': private_key},
      body: {
        'email': email,
        'name': fullName,
      },
    );
    final responceData = json.decode(response.body);
    return responceData;
  }

  void showErrors() {
    validateForm = true;
    notifyListeners();
  }

  Future<void> subscriptions() async {
    setBusy(true);
    final bool isFormNotEmpty = cardNum.isNotEmpty &&
        expMonths.isNotEmpty &&
        expYears.isNotEmpty &&
        cardCvc.isNotEmpty;
    final bool isFormValid = Validators.emptyStringValidator(
                cardNum, "Card Num can't be Empty ") ==
            null &&
        Validators.emptyStringValidator(cardCvc, "Card CVC can't be Empty ") ==
            null &&
        Validators.emptyStringValidator(
                expMonths, "Exp.Month can't be Empty ") ==
            null &&
        Validators.emptyStringValidator(expYears, "Exp.Year can't be Empty ") ==
            null;
    if (isFormValid) {
      _init();
      final _customer = await createCustomer(
        user!.email.toString(),
        user!.phoneNumber.toString(),
        user!.fullName.toString(),
      );
      await createProduct();
      await createProductPrice();
      final _paymentMethod = await _createPaymentMethod(
          number: cardNum,
          expMonth: expMonths,
          expYear: expYears,
          cvc: cardCvc);
      await _attachPaymentMethod(
          _paymentMethod['id'].toString(), _customer['id'].toString());
      await _updateCustomer(
          _paymentMethod['id'].toString(), _customer['id'].toString());
      setBusy(false);
      await _createSubscriptions(_customer['id'].toString());
    } else {
      setBusy(false);
      showErrors();
    }
  }

  Future _createPaymentMethod(
      {required String number,
      required String expMonth,
      required String expYear,
      required String cvc}) async {
    final String url = 'https://api.stripe.com/v1/payment_methods';
    var response = await client.post(
      Uri.parse(url),
      headers: {'Authorization': private_key},
      body: {
        'type': 'card',
        'card[number]': '$number',
        'card[exp_month]': '$expMonth',
        'card[exp_year]': '$expYear',
        'card[cvc]': '$cvc',
      },
    );
    if (response.statusCode == 200) {
      print(response.body);
      return json.decode(response.body);
    } else {
      setBusy(false);
      await _dialogService.showCustomDialog(
          variant: AlertType.error,
          title: 'Alert',
          description: "Please Provide Correct Detail.");
      print(json.decode(response.body));
      throw 'Failed to create PaymentMethod.';
    }
  }

  Future _attachPaymentMethod(String paymentMethodId, String customerId) async {
    final String url =
        'https://api.stripe.com/v1/payment_methods/$paymentMethodId/attach';
    var response = await client.post(
      Uri.parse(url),
      headers: {'Authorization': private_key},
      body: {
        'customer': customerId,
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      setBusy(false);
      await _dialogService.showCustomDialog(
          variant: AlertType.error,
          title: 'Alert',
          description: "Failed During Attach Payment Method.");
      print(json.decode(response.body));
      throw 'Failed to attach PaymentMethod.';
    }
  }

  Future _updateCustomer(String paymentMethodId, String customerId) async {
    final String url = 'https://api.stripe.com/v1/customers/$customerId';

    var response = await client.post(
      Uri.parse(url),
      headers: {'Authorization': private_key},
      body: {
        'invoice_settings[default_payment_method]': paymentMethodId,
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      setBusy(false);
      await _dialogService.showCustomDialog(
          variant: AlertType.error,
          title: 'Alert',
          description: "Failed During Update Subscription Plan.");
      print(json.decode(response.body));
      throw 'Failed to update Customer.';
    }
  }

  Future createProduct() async {
    final String url = 'https://api.stripe.com/v1/products';
    var response = await client.post(Uri.parse(url), headers: {
      'Authorization': private_key
    }, body: {
      'name': service!.name,
    });
    if (response.statusCode == 200) {
      print(json.decode(response.body));
      final data = json.decode(response.body);
      productKey = data['id'].toString();
      return json.decode(response.body);
    } else {
      setBusy(false);
      await _dialogService.showCustomDialog(
          variant: AlertType.error,
          title: 'Alert',
          description: "Failed During Product Creation.");
      print(json.decode(response.body));
      throw 'Failed to update Customer.';
    }
  }

  Future createProductPrice() async {
    final String url = 'https://api.stripe.com/v1/prices';
    var response = await client.post(
      Uri.parse(url),
      headers: {'Authorization': private_key},
      body: <String, dynamic>{
        'product': productKey,
        'unit_amount': (service!.price * 100)
            .toStringAsFixed(0), // Replace with the price amount (in cents)
        'currency': 'GBP', // Replace with your preferred currency code
        'recurring[interval]': 'month'
      }, // Replace with desired interval (month, week, etc.)
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      productPrice = data['id'].toString();
      return json.decode(response.body);
    } else {
      setBusy(false);
      await _dialogService.showCustomDialog(
          variant: AlertType.error,
          title: 'Alert',
          description: "Failed During Price Creation.");
      print(json.decode(response.body));
      throw 'Failed to update Customer.';
    }
  }

  Future<dynamic> _createSubscriptions(String customerId) async {
    final String url = 'https://api.stripe.com/v1/subscriptions';
    setBusy(true);
    Map<String, dynamic> body = {
      'customer': customerId,
      'items[0][price]': productPrice,
    };
    var response = await client.post(Uri.parse(url),
        headers: {'Authorization': private_key}, body: body);
    log(response.toString());
    if (response.statusCode == 200) {
      setBusy(false);

      final String timeString =
          DateTime.utc(2023).microsecondsSinceEpoch.toString();
      final String orderId = DateTime.now().microsecondsSinceEpoch.toString();
      final order = Order(
        type: OrderType.product,
        paymentMethod: MPaymentMethod.stripe,
        orderId: orderId,
        paymentId: productKey,
        shopId: service!.shopId,
        service: service!,
        userId: user!.id,
        status: OrderStatus.bookRequested,
        rate: 0,
        name: user!.fullName,
        address: user!.address,
        postCode: user!.postCode,
        time: DateTime.utc(2023).microsecondsSinceEpoch,
      );
      _databaseApi.createOrder(order).then((value) async {
        var token = await _databaseApi.getToken(order.service.ownerId);
        if (token != null) {
          Shop shopDetails = await _databaseApi.getShop(order.service.shopId);

          var test = _databaseApi.postNotification(
              orderID: order.orderId,
              title: 'New Booking',
              body:
                  '${order.name} has booked ${order.service.name}(£${order.service.price}) from ${shopDetails.name}',
              forRole: 'order',
              userID: '',
              receiverToken: token.toString());

          Map<String, dynamic> postMap = {
            "userId": user!.id,
            "orderID": order.orderId,
            "title": 'New Booking',
            "body":
                '${order.name} has booked ${order.service.name}(£${order.service.price})',
            "id": DateTime.now().millisecondsSinceEpoch.toString(),
            "read": false,
            "image": user!.imageUrl,
            "time": DateTime.utc(
              2023,
            ).millisecondsSinceEpoch.toString(),
            "sound": "default"
          };

          _databaseApi.postNotificationCollection(shopDetails.ownerId, postMap);
        }

        // if (await _navigationService.orderSuccessView) {
        // _navigationService.back();
        // navigateToOrderDetailView(order);
        // } else {
        //   _navigationService.back();
        //   _navigationService.back();
        // }
        /* if (response?.confirmed ?? false) {
              _navigationService.back();
              _navigationService.back();
              navigateToOrderDetailView(order);
            } else {
              _navigationService.back();
              _navigationService.back();
            }*/
      }, onError: (error) async {
        setBusy(false);
        await _dialogService.showCustomDialog(
          variant: AlertType.error,
          title: 'Payment failed',
          description: error.toString(),
        );
        // _navigationService.back();
      });

      await _dialogService.showCustomDialog(
          variant: AlertType.success,
          title: 'Success',
          description: "Subscription will be Made.");
      _navigationService.back();
      _navigationService.back();
      return json.decode(response.body);
    } else {
      setBusy(false);
      await _dialogService.showCustomDialog(
          variant: AlertType.error,
          title: 'Alert',
          description: "Failed During Subscription Payment.");
      print(json.decode(response.body));
      throw 'Failed to register as a subscriber.';
    }
  }

///////////////Strip RECURRING////////

}
