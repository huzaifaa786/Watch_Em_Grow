import 'package:flutter/material.dart';
import 'package:mipromo/ui/landing/landing_viewmodel.dart';
import 'package:mipromo/ui/shared/helpers/constants.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class LandingView extends StatelessWidget {
  const LandingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LandingViewModel>.reactive(
      builder: (context, model, child) => Material(
        child: SafeArea(
          child: Container(
            height: context.screenHeight,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "assets/images/landing.png",
                ),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Spacer(flex: 1),
                // Logo
                // Image.asset(
                //   "assets/images/logo_new.png",
                //   height: context.screenWidth / 5,
                // ).centered(),

                const Spacer(flex: 4),

                // Landing Label
                Constants.landingLabel.text.xl2.black.letterSpacing(1.3).make(),

                25.heightBox,

                // Create Account Button
                MaterialButton(
                  minWidth: context.screenWidth,
                  padding: const EdgeInsets.all(16),
                  color: const Color(0xFFD09A4E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  onPressed: () {
                    model.navigateToBuyerSignUpView();
                  },
                  child: Constants.createAccountLabel.text.white.lg.bold
                      .letterSpacing(1.3)
                      .make(),
                ),

                const Spacer(flex: 3),

                // Login Footer
                Constants.alreadyHaveAnAccountLabel.richText.bold
                    .color(Colors.grey)
                    .withTextSpanChildren(
                  [
                    Constants.loginLabel.textSpan
                        .tap(
                          () {
                            model.navigateToLoginView();
                          },
                        )
                        .color(Colors.brown)
                        .make(),
                  ],
                ).make(),
                const Spacer(),
              ],
            ).pSymmetric(h: context.screenWidth / 10),
          ),
        ),
      ),
      viewModelBuilder: () => LandingViewModel(),
    );
  }
}
