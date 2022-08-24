import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/models/shop.dart';
import 'package:mipromo/ui/shared/widgets/avatar.dart';
import 'package:velocity_x/velocity_x.dart';

class FeaturedShopCard extends StatelessWidget {
  final Shop shop;
  final AppUser shopOwner;

  const FeaturedShopCard({
    Key? key,
    required this.shop,
    required this.shopOwner,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return Card(
      color: Color(shop.color),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Card(
        
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: EdgeInsets.only(
          bottom: 14,//14
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: SizedBox(),
                    ),
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          RatingStars(
                            value: shop.rating,
                            starSize: 15,
                            starColor: Color(shop.color),
                            valueLabelVisibility: false,
                          ).pLTRB(2, 8, 2, 3),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(
                  color: Colors.grey,
                ),
                Row(
                  children: [
                    const Expanded(
                      child: SizedBox(),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          "@${shopOwner.username}".text.maxLines(2).make(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              shop.category.text
                                  .color(
                                    Colors.grey,
                                  )
                                  .sm
                                  .make(),
                              (shopOwner.followers > 999
                                      ? "${(shopOwner.followers / 1000).toDoubleStringAsFixed(digit: 1)}k"
                                      : "${shopOwner.followers}")
                                  .richText
                                  .center
                                  .withTextSpanChildren([
                                "\nFollowers"
                                    .textSpan
                                    .size(12)
                                    .color(
                                      Colors.grey,
                                    )
                                    .make(),
                              ]).make(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ).pOnly(right: 12),
                // const Spacer(flex: 1,),
                6.heightBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    /*Text(
                        shop.name,
                      maxLines: 2,
                      style: TextStyle(
                        fontFamily: shop.fontStyle,
                        fontSize: h * 0.024
                      ),
                    ),*/
                    shop.name.text.xl
                        .fontFamily(shop.fontStyle)
                        .maxLines(2)
                        .make(),
                    (shop.lowestPrice == 0
                            ? "£${shop.highestPrice.toInt()}"
                            : "£${shop.lowestPrice.toInt()} - ${shop.highestPrice.toInt()}")
                        .richText
                        .size(13)
                        .center
                        .withTextSpanChildren([
                      "\nItem Range"
                          .textSpan
                          .size(11)
                          .color(
                            Colors.grey,
                          )
                          .make(),
                    ]).make(),
                  ],
                ).pSymmetric(
                  h: 12,  
                ),
              ],
            ),
            Avatar(
              radius: context.screenWidth / 12,
              imageUrl: shopOwner.imageUrl,
              border: 1.5,
            ).p12(),
          ],
        ),
      ),
    ).pOnly(
      left: 20,
      right: 20,
    );
  }
}
