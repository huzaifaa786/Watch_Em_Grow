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
import 'package:mipromo/ui/shared/helpers/enums.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class InputAddressViewModel extends BaseViewModel {
  final _userService = locator<UserService>();
  final _databaseApi = locator<DatabaseApi>();
  final _navigationService = locator<NavigationService>();
  AppUser? user;
  String fullName = '';
  String address = '';
  String postCode = '';
  String serviceAmount = '';
  int step = 0;
  String paymentIntent = '';
  final client = http.Client();
  var responceData;
  ShopService? service;
  static Map<String, String> headers = {
    'Authorization':
        'Bearer sk_test_51IVZcBDoZl8DJ0XN2B6ryI8a1tssqoDcso3P1IDP7GxJ1qtmPnCGh9Ywap5fBwmQkGB5LIX4luKiWLlg202VvuJU00KKpdAkHt',
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

  void setAddress(String address) {
    this.address = address;
    notifyListeners();
  }

  void setPostCode(String postCode) {
    this.postCode = postCode;
    notifyListeners();
  }

  Future updateAddress() async {
    log('sdsddsdsndsndsnidsidsndisdnidisndi');
    // if (fullName != user!.fullName) {
    setBusy(true);
    _databaseApi
        .updateAddress(
      userId: user!.id,
      fullName: fullName,
      address: address,
      postCode: postCode,
    )
        .then((value) {
      // createCustomer(
      //   user!.email.toString(),
      //   user!.phoneNumber.toString(),
      //   user!.fullName.toString(),
      // );
      createPaymentIntent(service!.price.toInt());
      setBusy(false);
    });
    // } else {
    //   _navigationService.back(result: true);
    // }
  }

  /// STRIPE RECURRING PAYMENT////////
  ///

  Future<dynamic> createCustomer(
      String email, String name, String phone) async {
    log(user!.phoneNumber.toString());
    final response = await http.post(
      Uri.parse('https://api.stripe.com/v1/customers'),
      headers: {
        'Authorization':
            'Bearer sk_test_51JvIZ1Ey3DjpASZjmQpp61o9MDwfEnXHyZIbVE08CiJf3XxMKN93bOlu5MSxiw07yPJwX9kvDezuEugwSNZNkddy00ZCa33RpG',
      },
      body: {
        'email': email,
        'name': fullName,
        // 'phone': phone,
        // 'address': customerAddress
      },
    );
    final responceData = json.decode(response.body);
    // setBusy(true);

    // log(responceData.toString());
    return responceData;
  }

  Future<dynamic> createPaymentIntent(int amount) async {
    final data = await createCustomer(
      user!.email.toString(),
      user!.phoneNumber.toString(),
      user!.fullName.toString(),
    );
    // log(data.toString());
    // log(data.toString());
    final response = await http.post(
      Uri.parse('https://api.stripe.com/v1/payment_intents'),
      headers: {
        'Authorization':
            'Bearer sk_test_51JvIZ1Ey3DjpASZjmQpp61o9MDwfEnXHyZIbVE08CiJf3XxMKN93bOlu5MSxiw07yPJwX9kvDezuEugwSNZNkddy00ZCa33RpG',
      },
      body: {
        'amount': amount.toString(),
        'currency': 'GBP',
        'customer': data['id']
      },
    );
    final reponceData = json.decode(response.body);
    // log(reponceData.toString());
    await _databaseApi.updateStripeId(
      userId: user!.id,
      stripeCustomerId: data['id'].toString(),
    );
    log(user!.stripCustomerId.toString());
    await createPaymentMethod();
    await processPayment(service!.price.toInt(), data!['id'].toString(),
        reponceData!['client_secret'].toString());
    return reponceData;
  }

  Future<void> processPayment(
      int amount, String customerId, String clientSecret) async {
    // log(clientSecret.toString());
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        customerId: customerId,
        applePay: true,
        googlePay: true,
        style: ThemeMode.dark,
      ),
    );
    await Stripe.instance.presentPaymentSheet();
  }

  Future<dynamic> createPaymentMethod() async {
    final response = await http.get(
      Uri.parse('https://api.stripe.com/v1/customers/' +
          user!.stripCustomerId.toString() +
          '/payment_methods'),
      headers: {
        'Authorization':
            'Bearer sk_test_51JvIZ1Ey3DjpASZjmQpp61o9MDwfEnXHyZIbVE08CiJf3XxMKN93bOlu5MSxiw07yPJwX9kvDezuEugwSNZNkddy00ZCa33RpG',
      },
    );
    final reponceData = json.decode(response.body);
    log(reponceData.toString());

    return reponceData;
  }

///////////////Strip RECURRING////////
  Future _createTestPaymentSheet() async {
    log('finaly in create payment');
    // log(service.depositAmount.toString());
    // final url =
    //     Uri.parse('https://watchemgrow.klickwash.net/api/create/payment');
    // final response = await http.post(
    //   url,
    //   headers: {
    //     'Content-Type': 'application/json',
    //   },
    //   body: json.encode({
    //     'a': 'a',
    //     'price': 100,
    //     'connected_account': 'acct_1M7iQrRTmuR2qUZU'
    //   }),
    // );
    log(service!.price.toString());
    var url = 'https://watchemgrow.klickwash.net/api/create/payment';
    var data = {'price': service!.price.toString()}; // add service price
    var responses = await Api.execute(url: url, data: data);
    if (responses['error'] == false) {
      return responses['intent'];
    }
    // final body = json.decode(response.body);
    // final data = jsonDecode(body['intent'].toString());
    // paymentIntent = data['intent']['id'].toString();

    // return data;
  }

  Future<void> initPaymentSheet() async {
    log('i am here dear');
    try {
      // 1. create payment intent on the server

      final data = await _createTestPaymentSheet();

      // create some billingdetails
      final billingDetails = BillingDetails(
        name: 'Flutter Stripe',
        email: 'email@stripe.com',
        phone: '+48888000888',
        address: Address(
          city: 'Houston',
          country: 'Uk',
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
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
      rethrow;
    }
  }

  Future<bool> confirmPayment() async {
    print("Asdfasdfsdfasfd");

    final x;
    try {
      // 3. display the payment sheet.
      await initPaymentSheet();
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

//  NavigationDecision handleWebViewUrlProduct(NavigationRequest request) {
//     // if (request.url.contains(PaypalApi.returnURL)) {
//     //   final uri = Uri.parse(request.url);
//     //   final payerID = uri.queryParameters['PayerID'];
//       // if () {
//         // _paypalApi.capturePayment(paymentId!, accessToken!).then((response) {
//         //   if (response['statusCode'] != 201) {
//         //     _dialogService.showCustomDialog(
//         //       variant: AlertType.error,
//         //       title: response['message'] as String,
//         //     );
//         //     return;
//         //   }
//           // final capture = response['purchase_units'][0]['payments']['captures'][0];

//           // final String captureId = capture['id'] as String;
//           // final String timeString = capture['update_time'] as String;
//           final String orderId = DateTime.now().microsecondsSinceEpoch.toString();
//           final order = Order(
//               type: OrderType.product,
//               paymentMethod: MPaymentMethod.paypal,
//               orderId: orderId,
//               paymentId: paymentId,
//               shopId: service.shopId,
//               captureId: captureId,
//               service: service,
//               userId: user.id,
//               status: OrderStatus.progress,
//               rate: 0,
//               name: user.fullName,
//               address: user.address,
//               postCode: user.postCode,
//               time: DateTime.parse(timeString).microsecondsSinceEpoch,
//               selectedSize: selectedSize);
//           _databaseApi.createOrder(order).then((value) async {
//             var token = await _databaseApi.getToken(order.service.ownerId);
//             if (token != null) {
//               Shop shopDetails = await _databaseApi.getShop(order.service.shopId);
//               var test = _databaseApi.postNotification(
//                   orderID: order.orderId,
//                   title: 'New Order',
//                   body: '${order.name} has made order ${order.service.name} on ${shopDetails.name}',
//                   forRole: 'order',
//                   userID: '',
//                   receiverToken: token.toString());

//               Map<String, dynamic> postMap = {
//                 "userId": user.id,
//                 "orderID": order.orderId,
//                 "title": 'New Order',
//                 "body": '${order.name} has made order ${order.service.name}',
//                 "id": DateTime.now().millisecondsSinceEpoch.toString(),
//                 "read": false,
//                 "image": user.imageUrl,
//                 "time": DateTime.now().millisecondsSinceEpoch.toString(),
//                 "sound": "default"
//               };

//               _databaseApi.postNotificationCollection(shopDetails.ownerId, postMap);
//             }
//             if (await _navigationService.navigateTo(Routes.orderSuccessView) == true) {
//               _navigationService.back();
//               _navigationService.back();
//               navigateToOrderDetailView(order);
//             } else {
//               _navigationService.back();
//               _navigationService.back();
//             }
//             /*final response = await _dialogService.showConfirmationDialog(
//               title: 'Success',
//               description: 'Payment is completed.',
//               confirmationTitle: 'View Order',
//               cancelTitle: 'Close',
//             );
//             if (response?.confirmed ?? false) {
//               _navigationService.back();
//               _navigationService.back();
//               navigateToOrderDetailView(order);
//             } else {
//               _navigationService.back();
//               _navigationService.back();
//             }*/
//           }, onError: (error) async {
//             await _dialogService.showCustomDialog(
//               variant: AlertType.error,
//               title: 'Payment failed',
//               description: error.toString(),
//             );
//             _navigationService.back();
//           });
//         }
//       // } else {
//       //   _navigationService.back();
//       // }
//     }
//     // return NavigationDecision.navigate;

}
