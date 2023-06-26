import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/ui/follow/followers/followers_view.dart';
import 'package:mipromo/ui/follow/following/following_view.dart';
import 'package:mipromo/ui/profile/seller/policy.dart';
import 'package:mipromo/ui/profile/seller/seller_profile_viewmodel.dart';
import 'package:mipromo/ui/quick_settings/orders/orders_view.dart';
import 'package:mipromo/ui/shared/helpers/constants.dart';
import 'package:mipromo/ui/shared/helpers/styles.dart';
import 'package:mipromo/ui/shared/widgets/basic_loader.dart';
import 'package:mipromo/ui/shared/widgets/busy_loader.dart';
import 'package:mipromo/ui/shared/widgets/profile_header.dart';
import 'package:mipromo/ui/static_widget/shope_review_card.dart';
import 'package:mipromo/ui/value/colors.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:velocity_x/velocity_x.dart';

class SellerProductView extends StatelessWidget {
  const SellerProductView({
    Key? key,
    required this.seller,
    this.viewingAsProfile = false,
  }) : super(key: key);

  final AppUser seller;

  final bool? viewingAsProfile;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SellerProfileViewModel>.reactive(
      onModelReady: (model) => model.init(
        seller.shopId,
        seller,
        getThemeManager(context).selectedThemeMode == ThemeMode.dark,
      ),
      builder: (context, model, child) => model.isBusy
          ? const BasicLoader()
          : Scaffold(
              appBar: AppBar(
                title: '@${seller.username}'.text.bold.make(),
                leading: viewingAsProfile != true
                    ? BackButton(
                        onPressed: () {
                          // model.backToNotifications();
                          Navigator.pop(context);
                        },
                      )
                    : null,
                actions: [
                  if (model.shop!.ownerId != model.currentUser.id &&
                      viewingAsProfile != true)
                    Builder(
                        builder: (context) => InkWell(
                              onTap: () async {
                                await model.handleReport(context);
                                if (model.selectReport) {
                                  Future.delayed(Duration(milliseconds: 800))
                                      .then((value) {
                                    model.reportedDone(context);
                                  });
                                }
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.error_outline)
                                    /*Text('Report'),*/
                                  ],
                                ),
                              ),
                            ))
                  else
                    const SizedBox.shrink(),
                  if (model.shop!.ownerId == model.currentUser.id &&
                      viewingAsProfile == true)
                    Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(Icons.menu),
                        onPressed: () {
                          Scaffold.of(context).openEndDrawer();
                        },
                      ),
                    )
                  else
                    const SizedBox.shrink(),
                ],
              ),
              body: Stack(
                children: [
                  RefreshIndicator(
                    onRefresh: () async {
                      await Future.delayed(const Duration(milliseconds: 600));
                    },
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          ShopReviewCard(
                            user: seller,
                            shop: model.shop,
                          ),
 Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.5, color: textGrey),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 10.0, right: 10.0, bottom: 20.0, top: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Filter by Size',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontFamily: 'Default')),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: 50,
                      height: 40,
                      decoration: BoxDecoration(
                          border: Border.all(color: textGrey),
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                          child: Text(
                        'XXL',
                        style: TextStyle(fontFamily: 'Default'),
                      )),
                    ),
                    Container(
                      width: 50,
                      height: 40,
                      decoration: BoxDecoration(
                          border: Border.all(color: textGrey),
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                          child: Text('XL',
                              style: TextStyle(fontFamily: 'Default'))),
                    ),
                    Container(
                      width: 50,
                      height: 40,
                      decoration: BoxDecoration(
                          border: Border.all(color: textGrey),
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                          child: Text('L',
                              style: TextStyle(fontFamily: 'Default'))),
                    ),
                    Container(
                      width: 50,
                      height: 40,
                      decoration: BoxDecoration(
                          border: Border.all(color: textGrey),
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                          child: Text('M',
                              style: TextStyle(fontFamily: 'Default'))),
                    ),
                    Container(
                      width: 50,
                      height: 40,
                      decoration: BoxDecoration(
                          border: Border.all(color: textGrey),
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                          child: Text('S',
                              style: TextStyle(fontFamily: 'Default'))),
                    ),
                    Container(
                      width: 50,
                      height: 40,
                      decoration: BoxDecoration(
                          border: Border.all(color: textGrey),
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                          child: Text('XS',
                              style: TextStyle(fontFamily: 'Default'))),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      
                          
                          if (seller.shopId.isEmpty)
                            Column(
                              children: [
                                SvgPicture.asset(
                                  "assets/images/model.shop!.svg",
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
                                    model.navigateToCreateShopView();
                                  },
                                  child: "+ ${Constants.createShopLabel}"
                                      .text
                                      .bold
                                      .color(Styles.kcPrimaryColor)
                                      .make(),
                                ),
                              ],
                            )
                          else
                            Column(
                            children: [
                                if (model.services.isEmpty &&
                                    model.shop!.ownerId == model.currentUser.id)
                                  Column(
                                    children: [
                                      TextButton.icon(
                                        label: Constants.addServiceLabel.text
                                            .make(),
                                        icon: const Icon(
                                          Icons.add,
                                          size: 18,
                                        ),
                                        onPressed: () {
                                          model.navigateToCreateServiceView(
                                            model.shop!,
                                          );
                                        },
                                      ).pSymmetric(v: context.screenHeight / 7),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.info_outline,
                                            color: Colors.amber,
                                          ),
                                          5.widthBox,
                                          Flexible(
                                            child:
                                                "Please add at least one service/product to get listed on our shops catalogue."
                                                    .text
                                                    .color(Colors.grey)
                                                    .make(),
                                          ),
                                        ],
                                      )
                                          .box
                                          .border(color: Colors.amber)
                                          .roundedSM
                                          .p12
                                          .make()
                                          .p12()
                                    ],
                                  )
                                else if (!model.listview)
                                  GridView.builder(
                                      padding: EdgeInsets.only(left:10.0, right:10.0, top:10.0),
                                      shrinkWrap: true,
                                      physics: const BouncingScrollPhysics(),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 10.0,
                                        mainAxisSpacing: 10.0,
                                        childAspectRatio: 1,
                                      ),
                                      itemCount: model.shop!.ownerId ==
                                                  model.currentUser.id &&
                                              viewingAsProfile == true
                                          ? model.services.length
                                          : model.services.length,
                                      itemBuilder: (context, index) {
                                        String imageUrl(
                                          String? image1,
                                          String? image2,
                                          String? image3,
                                        ) {
                                          if (image1 == null) {
                                            if (image2 == null) {
                                              if (image3 == null) {
                                                return 'https://via.placeholder.com/600x600.jpg?text=No+image';
                                              } else {
                                                return image3;
                                              }
                                            } else {
                                              return image2;
                                            }
                                          } else {
                                            return image1;
                                          }
                                        }

                                        return Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  //color: Colors.red,
                                                  // border: Border.all(color: Colors.white, width: 0.5),
                                                  // borderRadius: BorderRadius.circular(10)
                                                  ),
                                              height: context.screenHeight / 6,
                                              width: context.screenHeight / 4.5,
                                              child: Stack(
                                                children: [
                                                  Positioned.fill(
                                                    child: AspectRatio(
                                                      aspectRatio: 1,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: imageUrl(
                                                            model
                                                                .services[index]
                                                                .imageUrl1,
                                                            model
                                                                .services[index]
                                                                .imageUrl2,
                                                            model
                                                                .services[index]
                                                                .imageUrl3,
                                                          ),
                                                          fit: BoxFit.cover,
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              const Icon(
                                                                  Icons.error),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  top: 10.0,
                                                                  right: 10.0),
                                                          child: Container(
                                                            height: 30,
                                                            width: 30,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color: white,
                                                            ),
                                                            child: Icon(
                                                              Icons
                                                                  .favorite_border,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  bottom: 10.0,
                                                                  right: 10.0),
                                                          child: Container(
                                                            height: 30,
                                                            width: 30,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color: white,
                                                            ),
                                                            child: Icon(
                                                                Icons
                                                                    .card_travel,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            model.services[index].name.text.bold
                                                .maxLines(2)
                                                .make()
                                                .pSymmetric(h: 4, v: 2),
                                            "£${model.services[index].price}"
                                                .text
                                                .xs
                                                .make()
                                                .px4(),
                                          ],
                                        ).mdClick(() {
                                          model.navigateToServiceView(
                                            model.services[index],
                                            model.shop!.color,
                                            model.shop!.fontStyle,
                                          );
                                        }).make();
                                      }
                                      // },
                                      )
                                else
                                  ListView.builder(
                                      padding: EdgeInsets.all(0),
                                      shrinkWrap: true,
                                      physics: const BouncingScrollPhysics(),
                                      itemCount: model.shop!.ownerId ==
                                                  model.currentUser.id &&
                                              viewingAsProfile == true
                                          ? model.services.length
                                          : model.services.length,
                                      itemBuilder: (context, index) {
                                        // if (index == model.services.length &&
                                        //     model.shop!.ownerId ==
                                        //         model.currentUser.id &&
                                        //     viewingAsProfile == true) {
                                        //   return Column(
                                        //     mainAxisAlignment:
                                        //         MainAxisAlignment.center,
                                        //     children: [
                                        //       const Icon(Icons.add),
                                        //       Constants.addServiceLabel.text
                                        //           .make(),
                                        //     ],
                                        //   ).mdClick(() {
                                        //     model.navigateToCreateServiceView(
                                        //         model.shop!);
                                        //   }).make();
                                        // } else {
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  //color: Colors.red,
                                                  //border: Border.all(color: Colors.white, width: 0.5)
                                                  ),
                                              //height: context.screenHeight / 7,
                                              width: context.screenWidth,
                                              child: Card(
                                                elevation: 8.0,
                                                margin:
                                                    new EdgeInsets.symmetric(
                                                        horizontal: 10.0,
                                                        vertical: 6.0),
                                                child: Container(
                                                  decoration: BoxDecoration(),
                                                  child: ListTile(
                                                      contentPadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 20.0,
                                                              vertical: 10.0),
                                                      leading: Container(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 12.0),
                                                        decoration: new BoxDecoration(
                                                            border: new Border(
                                                                right: new BorderSide(
                                                                    width: 1.0,
                                                                    color: Colors
                                                                        .black))),
                                                        child: Icon(
                                                            Icons.local_offer,
                                                            color: model
                                                                    .isDarkMode
                                                                ? Colors.white
                                                                : Colors.black),
                                                      ),
                                                      title: Text(
                                                        model.services[index]
                                                            .name,
                                                        style: TextStyle(
                                                            color: model
                                                                    .isDarkMode
                                                                ? Colors.white
                                                                : Colors.black,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                                      subtitle: Row(
                                                        children: <Widget>[
                                                          Icon(
                                                            Icons.description,
                                                            color: model
                                                                    .isDarkMode
                                                                ? Colors.white
                                                                : Colors
                                                                    .blueAccent,
                                                            size: 15.5,
                                                          ),
                                                          Flexible(
                                                            child: Container(
                                                              child: Text(
                                                                  model
                                                                      .services[
                                                                          index]
                                                                      .description!,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .ellipsis,
                                                                  style: TextStyle(
                                                                      color: model.isDarkMode
                                                                          ? Colors
                                                                              .white
                                                                          : Colors
                                                                              .black)),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      trailing: Icon(
                                                          Icons
                                                              .keyboard_arrow_right,
                                                          color: model
                                                                  .isDarkMode
                                                              ? Colors.white
                                                              : Colors.black,
                                                          size: 30.0)),
                                                ),
                                              ),
                                            ),
                                            /*model.services[index].name.text
                                                .maxLines(2)
                                                .make()
                                              .pSymmetric(h: 4, v: 2),*/

                                            /*"£${model.services[index].price}"
                                                .text
                                                .xs
                                                .make()
                                                .px4(),*/
                                          ],
                                        ).mdClick(() {
                                          model.navigateToServiceView(
                                            model.services[index],
                                            model.shop!.color,
                                            model.shop!.fontStyle,
                                          );
                                        }).make();
                                      }
                                     
                                      ),
                              ],
                            ) //.pSymmetric(h: 0)
                        ],
                      ),
                    ),
                  ),
                  BusyLoader(busy: model.isApiLoading),
                ],
              ),
            ),
      viewModelBuilder: () => SellerProfileViewModel(),
    );
  }
}
