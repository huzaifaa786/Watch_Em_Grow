// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:mipromo/ui/value/colors.dart';

class EmptyScreenCard extends StatelessWidget {
  const EmptyScreenCard(
      {Key? key,
     required this.title,
     required this.subtitle,
     required this.onPressed,
     required this.onTap,
    //  required this.iconColor,
    //  required this.icon,
    //  required this.iconBackground,
     required this.buttonTitle,      
      })
      : super(key: key);

  final String title;
  final String subtitle;
  final Function() onPressed;
  final Function() onTap;
  // final String iconColor;
  // final String icon;
  // final String iconBackground;
  final String buttonTitle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(color:Colors.green[100],shape: BoxShape.circle),
              child: Icon(
                Icons.check_circle_outline,
                size: 45,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 10,),
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 5,),
            Padding(
              padding: const EdgeInsets.only(left: 70.0, right: 70.0),
              child: Text(
               subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(color: hintText, fontSize: 12),
              ),
            ),
            SizedBox(height: 15,),
            GestureDetector(
              onTap: onPressed,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xffd09a4e),
                  // border: Border.all(color: hintText),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15, top: 10, bottom: 10),
                  child: Text(
                    buttonTitle,
                    style: TextStyle(color: white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
