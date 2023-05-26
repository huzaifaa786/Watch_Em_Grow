import 'package:flutter/material.dart';
import 'package:mipromo/ui/static_widget/item_card.dart';
import 'package:mipromo/ui/static_widget/shope_review_card.dart';
import 'package:mipromo/ui/static_widget/subtotal_card.dart';
import 'package:mipromo/ui/static_widget/top_bar.dart';
import 'package:mipromo/ui/value/colors.dart';
import 'package:mipromo/user_interface/checkout/checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TopBar(title: 'Cart', onPressed: (){}),
            // EmptyScreenCard(),
           ShopReviewCard(),
            const SizedBox(
              height: 5,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding:
                        EdgeInsets.only(top: 15.0, left: 15, bottom: 15),
                    child: Text(
                      'ITEMS',
                    ),
                  ),
                  SizedBox(
                    height: 250,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          CartItemCard(
                            itemName: 'Shalwar Kamiz',
                            itemPrice: '1500.00',
                          ),
                          CartItemCard(
                            itemName: 'Shalwar Kamiz',
                            itemPrice: '1500.00',
                          ),
                          CartItemCard(
                            itemName: 'Shalwar Kamiz',
                            itemPrice: '1500.00',
                          ),
                          CartItemCard(
                            itemName: 'Shalwar Kamiz',
                            itemPrice: '1500.00',
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SubTotalCard(),
            const SizedBox(
              height: 60,
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
                          Text('Total',style: TextStyle(fontWeight: FontWeight.bold),),
                          Row(
                            children: [
                              Text('£'),
                              Text('00.00'),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 20,),
                      Row(
                      children: [
                        Expanded(
                          child: MaterialButton(
                            color: const Color(0xffd09a4e),
                            child: const Text(
                              'CONTINUE',
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
                              builder: (context) => const CheckoutScreen()),
                        );
                             }
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
