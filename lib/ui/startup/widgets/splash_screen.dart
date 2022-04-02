import 'package:flutter/material.dart';
import 'package:mipromo/ui/shared/helpers/styles.dart';

class SplashScreen extends StatelessWidget {
  
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Styles.kcPrimaryColor,
      child: Center(
        child: Image.asset(
          "assets/images/logo_new.png", color: Colors.white,
          //"assets/images/splash_logo.png",
          height: MediaQuery.of(context).size.height / 7,
        ),
      ),
    );
  }
}
