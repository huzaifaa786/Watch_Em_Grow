import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:mipromo/ui/value/colors.dart';

class ProductReviewCard extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  ProductReviewCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: ExactAssetImage('assets/images/child.jpg'),
                        fit: BoxFit.cover,
                      ),
                      // border: Border.all(color: hintText),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Haseeb ',
                          style: TextStyle(
                              fontSize: 15,
                              color: primaryColor,
                              fontWeight: FontWeight.bold,fontFamily: 'Default'),
                        ),
                      
                         Text(
                        'Nov 02,2022',
                        style: TextStyle(fontSize: 15, color: primaryColor,fontFamily: 'Default', fontWeight: FontWeight.bold),
                      ),
                      ],
                    ),
                  ),
                  
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right:15.0),
                child: Row(
                  children: [
                    RatingStars(),
                  ],
                ),
              ),
            ],
          ),
        ),
         Padding(
           padding: const EdgeInsets.only(left:75.0,right:20.0),
           child: Text(
                        'Best Experience again want to order,Best Experience again want to order',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 15, color: textGrey,fontFamily: 'Default'),
                      ),
         ),
      ],
    );
  }
}
