import 'package:flutter/material.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/models/shop.dart';
import 'package:mipromo/ui/shared/widgets/avatar.dart';
import 'package:velocity_x/velocity_x.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    Key? key,
    required this.user,
    this.shop,
    required this.headerButton,
    required this.onFollowersTap,
    required this.onFollowingTap,
  }) : super(key: key);

  final AppUser user;
  final Shop? shop;
  final Widget headerButton;
  final void Function() onFollowersTap;
  final void Function() onFollowingTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Avatar(
              radius: context.screenWidth / 10,
              imageUrl: user.imageUrl,
            ),
            20.widthBox,
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      (user.followers > 999
                              ? "${(user.followers / 1000).toDoubleStringAsFixed(digit: 1)}k"
                              : "${user.followers}")
                          .text
                          .bold
                          .make(),
                      'Followers'.text.make(),
                    ],
                  ).onTap(onFollowersTap),
                  Column(
                    children: [
                      (user.following > 999
                              ? "${(user.following / 1000).toDoubleStringAsFixed(digit: 1)}k"
                              : "${user.following}")
                          .text
                          .bold
                          .make(),
                      'Following'.text.make(),
                    ],
                  ).onTap(onFollowingTap),
                ],
              ),
            ),
          ],
        ),
        12.heightBox,
        if(user.shopId.isEmpty)
        user.fullName.text.bold.make().pOnly(left: 6),
        if (shop != null) 10.heightBox else const SizedBox.shrink(),
        if (shop != null)
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 15,
              ),
              shop!.location.text.make(),
              if (shop!.borough.isNotEmpty)
                ', ${shop!.borough}'.text.make()
              else
                const SizedBox.shrink(),
            ],
          )
        else
          const SizedBox.shrink(),
        12.heightBox,
        headerButton,
        // const Divider(
        //   thickness: 1,
        // ),
      ],
    ).p12();
  }
}
