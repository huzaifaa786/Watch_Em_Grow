import 'package:flutter/material.dart';
import 'package:mipromo/ui/static_widget/address_card.dart';
import 'package:mipromo/ui/static_widget/commint_card.dart';
import 'package:mipromo/ui/static_widget/order_summery_card.dart';
import 'package:mipromo/ui/static_widget/payment_method_card.dart';
import 'package:mipromo/ui/static_widget/top_bar.dart';
import 'package:mipromo/ui/value/colors.dart';
import 'package:mipromo/user_interface/cart/cart_screen.dart';
import 'package:mipromo/user_interface/success/success_screen.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TopBar(
              title: 'Checkout',
              onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CartScreen()),
                    );
              },
            ),
            const SizedBox(height: 20,),
          const Padding(
            padding:  EdgeInsets.only(left:15.0,right:15.0),
            child:  AddressCard(),
          ),
           
            const SizedBox(
              height: 25,
            ),
           Padding(
             padding: const EdgeInsets.only(left:15.0,right:15.0),
             child: PaymentMethodCard(onPressed: (){},onTap: (){},),
           ),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding:EdgeInsets.only(left:15.0,right:15.0),
              child: CommintsCard(),
            ),
             const SizedBox(
              height: 10,
            ),
             Padding(
              padding: const EdgeInsets.only(left:15.0,right:15.0),
              child: OrderSummeryCard(),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(color: white),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 15.0, bottom: 30.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total',style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Default'),),
                          Row(
                            children: [
                              Text(
                                  '£ ',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: textGrey,
                                  ),
                                ),
                              const Text('00.00',style:TextStyle(fontFamily: 'Default'),),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 20,),
                        Row(
                      children: [
                        Expanded(
                          child: MaterialButton(
                            color: const Color(0xffd09a4e),
                             child: const Text(
                              'CHECKOUT',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,fontFamily: 'Default'
                              ),
                            ),
                            height:45,
                            onPressed: (){
                                Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SuccessScreen()),
                        );}
                          ),
                        ),
                      ],
                    ),
                   
                    ],
                  ),
                )),
          ],
        ),
      )),
    );
  }
}
