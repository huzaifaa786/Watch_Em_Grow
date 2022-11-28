import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:http_auth/http_auth.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/models/order.dart';
import 'package:sprintf/sprintf.dart';

class StripeApi {
  // static const String domain = "https://api.sandbox.paypal.com"; // for sandbox mode
  static const String domain =
      "https://api.stripe.com/v1"; // for production mode

  static const String transferUrl =
      '$domain/transfers';
  static const String refundUrl =
      '$domain/refunds';


  // for getting the access token from Paypal
  

  Future<dynamic> paySellerPayment(Order order,
      double processingFee, String? stripeAccount) async {
    try {
      print('helaa');
      double finalPayment =
          order.service.depositAmount! * (1 - (processingFee / 100));
    
      var uname = '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';
      var pword = '';
      var authn = 'Basic ' + base64Encode(utf8.encode('$uname:$pword'));

      var headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': authn,
      };
    int amount = finalPayment.toInt();
    int total = amount *100;
  
      var data = {
        'amount': total.toString(),
        'currency': 'GBP',
        'destination': stripeAccount,
      };
      //double finalPayment = order.service.price * 0.80;
      final response = await http.post(
        Uri.parse(transferUrl),
        headers: headers,
        body: data
      );

      final body = jsonDecode(response.body);
     
      return body;
    } catch (e, stack) {
      print(stack.toString());
      rethrow;
    }
  }

  Future<dynamic> refundPayment(Order order) async {
    try {
      var uname = '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';
      var pword = '';
      var authn = 'Basic ' + base64Encode(utf8.encode('$uname:$pword'));

      var headers = {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': authn,
      };

  
      var data = {
        'payment_intent': order.paymentIntent,
      };
      //double finalPayment = order.service.price * 0.80;
      final response = await http.post(
        Uri.parse(refundUrl),
        headers: headers,
        body: data
      );

      final body = jsonDecode(response.body);
     print(body);
      return body;
    } catch (e, stack) {
      print(stack.toString());
      rethrow;
    }
  }

  
}
