import 'package:flutter/material.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/ui/profile/profile_viewmodel.dart';
import 'package:mipromo/ui/shared/helpers/constants.dart';
import 'package:mipromo/ui/shared/widgets/avatar.dart';
import 'package:mipromo/ui/shared/widgets/basic_loader.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NoShopProfileView extends StatelessWidget {
  const NoShopProfileView({
    Key? key,
    required this.user,
  }) : super(key: key);

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
      builder: (context, model, child) => model.isBusy
          ? const BasicLoader()
          : SafeArea(
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Avatar(
                        radius: context.screenWidth / 12,
                        imageUrl: user.imageUrl,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            if (user.fullName.isEmpty)
                              const SizedBox.shrink()
                            else
                              user.fullName.text.maxLines(3).make().pOnly(
                                    bottom: 10,
                                  ),
                            "@${user.username}".text.sm.maxLines(2).make(),
                          ],
                        ).p20(),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        onPressed: () {
                          model.navigateToEditProfile(user);
                        },
                        child: Constants.editProfileLabel.text.sm.make(),
                      ),
                    ],
                  ).p16(),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        SvgPicture.asset(
                          "assets/images/shop.svg",
                          height: context.screenHeight / 7,
                        ),
                        Constants.createShopInfoLabel.text.center.sm
                            .make()
                            .box
                            .width(context.screenWidth / 1.5)
                            .make()
                            .pOnly(top: 20),
                        TextButton(
                          onPressed: () {
                            model.navigateToCreateShopView(user);
                          },
                          child: "+ ${Constants.createShopLabel}"
                              .text
                              .bold
                              .color(Theme.of(context).primaryColor)
                              .make(),
                        ),
                        const Spacer(),
                        OutlinedButton(
                          onPressed: () {
                            model.signOut();
                          },
                          child: 'Logout'.text.red500.make(),
                        ),
                        20.heightBox,
                      ],
                    ),
                  ),
                ],
              ),
            ),
      viewModelBuilder: () => ProfileViewModel(),
    );
  }
}
