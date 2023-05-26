import 'package:flutter/material.dart';
import 'package:mipromo/ui/value/colors.dart';

class TopBar extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  TopBar({Key? key,required this.title ,required this.onPressed}) : super(key: key);
   final String title;
   final Function() onPressed;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration( border: Border(
              bottom: BorderSide(width: 1, color: Color(0xffd09a4e)),
            ),),
      margin: const EdgeInsets.only(
        top: 12,
      ),
      child: Row(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: primaryColor,
                ),
                onPressed: onPressed,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 13.0),
                child: Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,fontFamily: 'Default'),
                ),
              )
            ],
          ),
       
        ],
      ),
    );
  }
}
