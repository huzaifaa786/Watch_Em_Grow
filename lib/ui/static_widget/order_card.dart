// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:mipromo/ui/value/colors.dart';

class OrderCard extends StatelessWidget {
  const OrderCard(
      {Key? key,
      // this.title,
      // this.price,
      // this.currency,
     required this.onPressed,
     })
      : super(key: key);

  // final title;
  // final price;
  // final currency;
  final Function() onPressed;
 
 
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.grey),borderRadius: BorderRadius.circular(10)),
          width: MediaQuery.of(context).size.width * 0.95,
          child: Padding(
            padding: const EdgeInsets.only(left:10.0,right:10.0,top:20.0,bottom: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Nahida Home Botique',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                     Row(
                  children: [
                    Icon(
                     Icons.arrow_forward_ios_rounded,
                     size: 15,
                    )
                  ],
                ),
            
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Text('£ '),
                    Text('1500 -'),
                    Text('Order ID:'),
                    Text('KP2121'),
                  ],
                ),
                SizedBox(height: 10,),

                Row(
                  children: [
                    Text('Accepted',style: TextStyle(color:Colors.green),),
                    Text('- 25 Sep 2023 ',style: TextStyle(color:Colors.grey),),
                  ],
                ),
               
              ],
            ),
          )),
    );
  }
}
