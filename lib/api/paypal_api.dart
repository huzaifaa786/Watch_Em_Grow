import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:http_auth/http_auth.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/models/order.dart';
import 'package:sprintf/sprintf.dart';

class PaypalApi {
 // static const String domain = "https://api.sandbox.paypal.com"; // for sandbox mode
   static const String domain = "https://api.paypal.com"; // for production mode
  static const String clientId =
      'Aa6veR5J_GbKz7IrpxHcdbMMlqBLrTUuAJuHx5e5uQqTsBk3h1R5TJBFCtQajBqhY9HIChSS_W_olNNm';
  static const String secret =
      'EIAaVkUD064Mj3EjLlzUiyAzNPBtRq5B9XZorr4x6GUSWAefJTwOAcXUvsgS4-ArlvMr_rMjxkpdVvs-';
  static const String captureUrl = '$domain/v2/checkout/orders/%s/capture';
  static const String refundUrl = '$domain/v2/payments/captures/%s/refund';
  static const String transferUrl = 'https://api-m.paypal.com/v1/payments/payouts';
  static const String userInfoUrl = '$domain/v1/identity/oauth2/userinfo?schema=paypalv1.1';
  static const String authCodeUrl = '$domain/v1/oauth2/token?grant_type=authorization_code&code=';
  static const returnURL = 'https://www.sadje.org';
  static const cancelURL = 'https://www.sadje.org/cancel';

  // for getting the access token from Paypal
  Future<String?> getAccessToken() async {
    try {
      final client = BasicAuthClient(clientId, secret);
      final response = await client.post(
          Uri.parse('$domain/v1/oauth2/token?grant_type=client_credentials'));
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return body["access_token"] as String;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // for getting the user info from paypal login verification
  Future<String?> getUserInfo(String customerAccessToken) async {
    try{
      final response = await http.get(
          Uri.parse(userInfoUrl),
        headers: {'Authorization': 'Bearer $customerAccessToken'},
      );
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return body["emails"][0]['value'] as String;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // for getting the customer access token
  Future<String?> getCustomerAccessToken(String authCode) async {
    try{
      final client = BasicAuthClient(clientId, secret);
      final response = await client.post(
        Uri.parse(authCodeUrl+authCode),
      );
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return body["access_token"] as String;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  // for creating the payment request with Paypal
  Future<Map<String, String>?> createPaypalPayment(Map<String, dynamic> transactions, String accessToken,) async {
    try {
      final response = await http.post(Uri.parse('$domain/v2/checkout/orders'),
          body: jsonEncode(transactions),
          headers: {
            "content-type": "application/json",
            'Authorization': 'Bearer $accessToken'
          });

      final body = jsonDecode(response.body);
      if (response.statusCode == 201) {
        final id = body['id'] as String;
        final List? links = body["links"] as List?;
        if (links != null && links.isNotEmpty) {
          String executeUrl = "";
          String approvalUrl = "";
          final item = links.firstWhere((o) => o["rel"] == "approve",
              orElse: () => null);
          if (item != null) {
            approvalUrl = item["href"] as String;
          }
          final item1 = links.firstWhere((o) => o["rel"] == "execute",
              orElse: () => null);
          if (item1 != null) {
            executeUrl = item1["href"] as String;
          }
          return {
            'id': id,
            "executeUrl": executeUrl,
            "approvalUrl": approvalUrl
          };
        }
        return null;
      } else {
        throw Exception(body["message"]);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> capturePayment(String paymentId, String accessToken) async {
    try {
      final response = await http
          .post(Uri.parse(sprintf(captureUrl, [paymentId])), headers: {
        "content-type": "application/json",
        'Authorization': 'Bearer $accessToken'
      });

      final body = jsonDecode(response.body);
      body['statusCode'] = response.statusCode;
      return body;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> refundPayment(Order order, String accessToken) async {
    try {
      final response = await http.post(
        Uri.parse(sprintf(refundUrl, [order.captureId])),
        headers: {
          "content-type": "application/json",
          'Authorization': 'Bearer $accessToken'
        },
          body: jsonEncode({
          'amount': {'value': order.depositAmount!, 'currency_code': 'GBP'}
         }),
      );

      final body = jsonDecode(response.body);
      body['statusCode'] = response.statusCode;
      return body;
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> paySellerPayment(String email, Order order,double processingFee, String accessToken) async {
    try {
      var rng = new Random();
      List batch_idList=[];
      for(int i=0; i< 9; i++){
        batch_idList.add(rng.nextInt(9));
      }
      String batchID = batch_idList.join('');

      double finalPayment = order.depositAmount! * (1 - (processingFee / 100));
      //double finalPayment = order.service.price * 0.80;
      final response = await http.post(
        Uri.parse(transferUrl),
        headers: {
          "content-type": "application/json",
          'Authorization': 'Bearer $accessToken'
        },
         body: jsonEncode({
           "sender_batch_header": {
             "sender_batch_id": batchID,
             "email_subject": "You have a payout!",
             "email_message": "You have received a payout! Thanks for using our service!"
           },
           "items": [
             {
               "recipient_type": "EMAIL",
               "amount": {
                 "value": finalPayment.toStringAsFixed(2),
                 "currency": "GBP"
               },
               "note": "Thanks for your service!",
               "sender_item_id": order.orderId,
               "receiver": email
             }
           ]
         }),
      );

      final body = jsonDecode(response.body);
      body['statusCode'] = response.statusCode;
      return body;
    } catch (e, stack) {
      print(stack.toString());
      rethrow;
    }
  }
}
