// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:mipromo/ui/value/colors.dart';

class BannerCard extends StatelessWidget {
  const BannerCard(
      {Key? key,
    //  required this.title,
     required  this.onPressed,
      })
      : super(key: key);

  // final String title;
  final Function() onPressed;
  
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Column(
             children: [
            Stack(
              // // overflow: Overflow.visible,
              alignment: AlignmentDirectional.centerEnd,
              fit: StackFit.loose,
              children: <Widget>[
                Container(
                  decoration: const BoxDecoration(),
                  height:80,
                  width: MediaQuery.of(context).size.width* 0.9,
                   
                  child: Image.asset("assets/images/poster.jpg", fit: BoxFit.cover,)),
                Positioned(
                    child: Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right:30.0),
                      child: Text('Shop by age',style: TextStyle(color: primaryColor,fontSize: 23,fontWeight: FontWeight.w900,fontFamily: 'Default'),),
                    ),
                  ],
                ))
              ],
            )
          ]),
        ),
      ],
    );
  }
}
