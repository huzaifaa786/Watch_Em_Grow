// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:mipromo/ui/value/colors.dart';

class ProductCard extends StatelessWidget {
  const ProductCard(
      {Key? key,
     required this.title,
     required this.price,
    required  this.currency,
     required this.onPressed,
     required this.image,
      })
      : super(key: key);

  final String title;
  final String price;
  final String currency;
  final Function() onPressed;
  final String image;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.45,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.amber,
                  image: DecorationImage(
                    image: AssetImage(image),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    
                     Padding(
                       padding: const EdgeInsets.only(top:10.0,right:10.0),
                       child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(shape: BoxShape.circle ,
                        color:white,
                        ),
                        child: Icon(
                          Icons.favorite_border,
                          color: Colors.black,
                        ),
                                         ),
                     ),
                     Padding(
                       padding: const EdgeInsets.only(bottom:10.0,right:10.0),
                       child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(shape: BoxShape.circle ,
                        color:white,
                        ),
                        child: Icon(
                          Icons.card_travel,
                          color: Colors.black
                        ),
                                         ),
                     ),
                  
                  
                ],),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                title,
                style: TextStyle(color: primaryColor, fontSize: 15,fontFamily: 'Default'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Row(
                children: [
                  Text(
                    currency,
                    style: TextStyle(color: textGrey, fontSize: 15,fontFamily: 'Default'),
                  ),
                  Text(
                    price,
                    style: TextStyle(color: textGrey, fontSize: 15,fontFamily: 'Default'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
