import 'package:flutter/material.dart';
import 'package:mipromo/ui/static_widget/order_card.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: textGrey,
      body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 10,right: 10),
              child: Column(
                
                    children: [
              SizedBox(height: 20.0,),
              OrderCard(onPressed:(){}),
              SizedBox(height:20.0,),
              OrderCard(onPressed:(){}),
              SizedBox(height:20.0,),
              OrderCard(onPressed:(){}),
                    ],
                  ),
            ),
          )),
    );
  }
}
