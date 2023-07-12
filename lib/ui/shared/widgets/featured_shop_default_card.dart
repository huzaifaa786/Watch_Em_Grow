import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/models/shop.dart';
import 'package:mipromo/ui/shared/widgets/avatar.dart';
import 'package:mipromo/ui/shared/widgets/avatar_assest.dart';
import 'package:mipromo/ui/value/colors.dart';
import 'package:velocity_x/velocity_x.dart';

class FeaturedShopDefaultCard extends StatefulWidget {
  // final Shop shop;
  // final AppUser shopOwner;

  const FeaturedShopDefaultCard({
    Key? key,
    // required this.shop,
    required this.shop,
    // required this.shopOwner,
    required this.shopOwner,
    required this.category,
    required this.shopName,
    required this.lowestPrice,
    required this.highestPrice,
    required this.imageUrl,
    // required this.followers,
  }) : super(key: key);
  final String shop;
  final String shopOwner;
  final String category;
  final String shopName;
  final String imageUrl;
  final String lowestPrice;
  final String highestPrice;

  @override
  _FeaturedShopDefaultCardState createState() => _FeaturedShopDefaultCardState();
}

class _FeaturedShopDefaultCardState extends State<FeaturedShopDefaultCard> {
   void didChangeDependencies() {
    precacheImage(AssetImage("assets/images/child.jpg"), context);
    precacheImage(AssetImage("assets/images/product3.jpg'"), context);
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return Card(
      color: Color(0xFFD09A4E),
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
                            // value: shop.rating,
                            value: 3,
                            starSize: 15,
                            starColor: Color(0xFFD09A4E),
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
                          // "@${shopOwner.username}".text.maxLines(2).make(),
                          widget.shopOwner.text.maxLines(2).make(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // shop.category.text
                              widget.category.text
                                  .color(
                                    Colors.grey,
                                  )
                                  .sm
                                  .make(),
                              // (shopOwner.followers > 999
                              //         ? "${(shopOwner.followers / 1000).toDoubleStringAsFixed(digit: 1)}k"
                              //         : "${shopOwner.followers}") 
                                      ('22'
                                      )
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
                    // shop.name.text.xl
                    widget.shopName.text.xl
                        .fontFamily('Default')
                        .maxLines(2)
                        .make(),
                    // (shop.lowestPrice == 0
                    // (lowestPrice == 0
                    //         ? "£${shop.highestPrice.toInt()}"
                    //         : "£${shop.lowestPrice.toInt()} - ${shop.highestPrice.toInt()}")       
                                  (widget.lowestPrice == 0
                            ? "£${widget.highestPrice}"
                            : "£${widget.lowestPrice} - ${widget.highestPrice}")
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


            AvatarAssets(
              radius: context.screenWidth / 12,
              // imageUrl: shopOwner.imageUrl,
              imageUrl: 'assets/images/poster.jpg',
              
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
