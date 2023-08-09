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
            Container(
                decoration: const BoxDecoration(),
                height: MediaQuery.of(context).size.height * 0.35,
                width: MediaQuery.of(context).size.width,
                child: Image.asset(
                  "assets/images/splash/splash.png",
                  fit: BoxFit.cover,
                )),
          ]),
        ),
      ],
    );
  }
}
