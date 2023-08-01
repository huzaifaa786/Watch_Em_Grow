// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:mipromo/ui/value/colors.dart';
import 'package:velocity_x/velocity_x.dart';

class BannerCard extends StatelessWidget {
  const BannerCard({
    Key? key,
    //  required this.title,
    required this.onPressed,
  }) : super(key: key);

  // final String title;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Column(children: [
            Stack(
              // // overflow: Overflow.visible,
              alignment: AlignmentDirectional.bottomStart,
              fit: StackFit.loose,
              children: <Widget>[
                Container(
                    decoration: const BoxDecoration(),
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width,
                    child: Image.asset(
                      "assets/images/splash/splash.jpg",
                      fit: BoxFit.cover,
                    )),
                Positioned(
                    child: Padding(
                  padding: EdgeInsets.only(left: 25.0, bottom: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'This Months Flash Deals',
                        style: TextStyle(
                            color: white,
                            fontSize: 23,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'Default'),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: white),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, right: 20, top: 15, bottom: 15),
                            child: Text(
                              'View Collection',
                              style: TextStyle(
                                  color: Vx.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'Default'),
                            ),
                          ))
                    ],
                  ),
                ))
              ],
            )
          ]),
        ),
      ],
    );
  }
}
