// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:mipromo/ui/value/colors.dart';

class PaymentMethodCard extends StatelessWidget {
  const PaymentMethodCard(
      {Key? key,
     required this.onPressed,
     required this.onTap,
      })
      : super(key: key);

  
  final void Function() onPressed;
  final void Function() onTap;
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:onPressed ,
      child: Container(
        width: MediaQuery.of(context).size.width ,
        decoration: BoxDecoration(
            color: white, borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.only(left:10.0,right:10,top:5,bottom: 15),
         child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text('PAYMENT METHOD',style:TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Default'),),
          SizedBox(height: 10,),
       Container(
        width: MediaQuery.of(context).size.width*0.9 ,
        decoration: BoxDecoration(color: white,border: Border.all(color: textGrey),borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.only(left:15.0,top: 10.0,bottom: 10.0),
          child: Row(
            children: [
            Container(width: 50,
            height: 50,
             decoration: BoxDecoration(color: white,shape: BoxShape.circle,
              image: DecorationImage(
                          image: ExactAssetImage('assets/images/stripe.png'),
                          fit: BoxFit.cover,
                        ),
             ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Stripe',style: TextStyle(fontFamily: 'Default'),),
                  Text('Connected',style: TextStyle(color:Colors.green,fontFamily: 'Default'),),
                ],
              ),
            )
          ],),
        ),
       ),
         const SizedBox(height: 10,),
 Container(
        width: MediaQuery.of(context).size.width*0.9 ,
        decoration: BoxDecoration(color: white,border: Border.all(color: textGrey),borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.only(left:15.0,top: 10,bottom: 10.0),
          child: Row(
            children: [
            Container(width: 50,
            height: 50,
             decoration: BoxDecoration(color: white,shape: BoxShape.circle,
              image: DecorationImage(
                          image: ExactAssetImage('assets/images/paypal.png'),
                          fit: BoxFit.cover,
                        ),
             ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('PayPal',style: TextStyle(fontFamily: 'Default'),),
                  const Text('DisConnected',style: TextStyle(color:hintText,fontFamily: 'Default'),),
                ],
              ),
            )
          ],),
        ),
       )
         

         ],),
        ),
      ),
    );
  }
}
