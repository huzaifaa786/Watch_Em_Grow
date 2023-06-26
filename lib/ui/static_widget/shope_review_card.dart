import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/models/shop.dart';
import 'package:mipromo/ui/shared/widgets/avatar.dart';
import 'package:mipromo/ui/value/colors.dart';
import 'package:velocity_x/velocity_x.dart';

class ShopReviewCard extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  ShopReviewCard({
    Key? key,
    required this.user,
    this.shop,
  }) : super(key: key);
  final AppUser user;
  final Shop? shop;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFE6D9CB),
        border: Border(
          bottom: BorderSide(width: 1.5, color: textGrey),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0, top: 10.0),
                child: Row(
                  children: [
                    Container(
                      height: 55,
                      width: 55,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(user.imageUrl),
                            fit: BoxFit.cover,
                          ),
                          border: Border.all(color: hintText),
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              shop!.name.text.semiBold.xl
                                  .fontFamily(shop!.fontStyle)
                                  .make(),
                            ],
                          ),
                          Row(
                            children: [
                              RatingStars(
                                value: shop!.rating,
                                starSize: 16,
                                valueLabelVisibility: false,
                                starOffColor: white,
                              ),
                              5.widthBox,
                              '(${shop!.ratingCount})'.text.make(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: white,
                      ),
                      child: Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
          SizedBox(
            height: 40,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10.0, right: 10.0),
              child: Text(
                'Member Since 2021',
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 14, color: Color(0xff666666)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
