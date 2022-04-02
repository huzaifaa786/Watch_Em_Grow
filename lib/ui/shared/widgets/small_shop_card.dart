import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/models/shop.dart';
import 'package:mipromo/ui/shared/widgets/avatar.dart';
import 'package:velocity_x/velocity_x.dart';

class SmallShopCard extends StatelessWidget {
  final Shop shop;
  final AppUser shopOwner;
  final void Function() onClick;

  const SmallShopCard({
    Key? key,
    required this.shop,
    required this.shopOwner,
    required this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      elevation: 0,
      color: Color(shop.color),
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Avatar(
                    imageUrl: shopOwner.imageUrl,
                    radius: 12,
                  ).objectCenterLeft(),
                ),
                Expanded(
                  child: (shopOwner.followers > 999
                          ? "${(shopOwner.followers / 1000).toDoubleStringAsFixed(digit: 1)}k"
                          : "${shopOwner.followers}")
                      .richText
                      .black
                      .sm
                      .center
                      .withTextSpanChildren([
                    "\nFollowers".textSpan.size(10).black.make(),
                  ]).make(),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                shop.name.text.sm.center.black
                    .maxLines(1)
                    .fontFamily(shop.fontStyle)
                    .make(),
                shop.category.text.black.size(8).make().p4(),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (shop.rating != 0)
                  "No reviews".text.xs.black.make()
                else
                  RatingStars(
                    value: shop.rating,
                    starSize: 10,
                    valueLabelVisibility: false,
                  ),
                (shop.lowestPrice == 0
                        ? "£${shop.highestPrice.toInt()}"
                        : "£${shop.lowestPrice.toInt()} - ${shop.highestPrice.toInt()}")
                    .richText
                    .xs
                    .black
                    .center
                    .withTextSpanChildren([
                  "\nItem Range".textSpan.size(10).black.make(),
                ]).make(),
              ],
            ).objectTopCenter(),
          ),
        ],
      ).p8(),
    ).click(onClick).make();
  }
}
