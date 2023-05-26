// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:mipromo/ui/value/colors.dart';

class ShopeCard extends StatelessWidget {
  const ShopeCard(
      {Key? key,
     required this.onTap,
     required this.onPressed,
     required this.image,
       })
      : super(key: key);

  
  final Function() onPressed;
  final Function() onTap;
  final String image;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
      child: GestureDetector(
        onTap: onPressed,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: hintText),
                        shape: BoxShape.circle,
                      ),
                      height: 50,
                      width: 50,
                      child: CircleAvatar(
                        backgroundImage: AssetImage("assets/images/poster.jpg"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Shop Name',
                            style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold, color: primaryColor,fontFamily: 'Default'),
                          ),
                          Text(
                            '4 follower',
                            style: TextStyle(fontSize: 15, color: Colors.grey,fontFamily: 'Default',),
                          ),
                        ],
                      ),
                    ),
                  
                  ],
                ),
                Row(
                  children: [
                    Text(
                      'View Shop',
                      style: TextStyle(color:Color(0xffd09a4e), fontSize: 18.0, ),
                    )
                  ],
                )
              ],
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: 130,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.amber,
                    image: DecorationImage(
                      image: AssetImage(image),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                 Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: 130,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.amber,
                    image: DecorationImage(
                      image: AssetImage(image),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                 Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: 130,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.amber,
                    image: DecorationImage(
                      image: AssetImage(image),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
