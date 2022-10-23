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
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class SellerProfileView extends StatelessWidget {
  const SellerProfileView({
    Key? key,
    required this.seller,
    this.viewingAsProfile = false,
  }) : super(key: key);

  final AppUser seller;

  final bool? viewingAsProfile;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SellerProfileViewModel>.reactive(
      onModelReady: (model) => model.init(seller.shopId, seller),
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
                  if (model.shop!.ownerId != model.currentUser.id && viewingAsProfile != true)
                    Builder(
                        builder: (context) => InkWell(
                              onTap: () async {
                                await model.handleReport(context);
                                if (model.selectReport) {
                                  Future.delayed(Duration(milliseconds: 800)).then((value) {
                                    model.reportedDone(context);
                                  });
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
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
                  if (model.shop!.ownerId == model.currentUser.id && viewingAsProfile == true)
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
              endDrawer: SafeArea(
                child: Drawer(
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          children: [
                            ListTile(
                              leading: const Icon(
                                Icons.account_balance_wallet_outlined,
                              ),
                              title: 'Earnings'.text.make(),
                              onTap: () {
                                model.navigateToEarningsView(seller);
                              },
                            ),
                            ListTile(
                              leading: const Icon(
                                Icons.list_alt,
                              ),
                              title: 'Orders'.text.make(),
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => OrdersView()),
                                ).then((val) => {model.init(seller.shopId, seller)});
                                // model.navigateToOrdersView();
                              },
                            ),
                            ExpansionTile(
                              title: 'Referral Code'.text.make(),
                              leading: const Icon(Icons.copyright_rounded),
                              children: [
                                ListTile(
                                  title: model.currentUser.referCode.toString().text.make(),
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.copy,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      Clipboard.setData(
                                        ClipboardData(
                                          text: model.currentUser.referCode.toString(),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                            ListTile(
                              leading: const Icon(Icons.edit_outlined),
                              title: const Text('Edit Shop'),
                              onTap: () {
                                model.navigateToEditShopView();
                              },
                            ),
                            // ListTile(
                            //   leading: const Icon(Icons.calendar_today),
                            //   title: const Text('Set Availability'),
                            //   onTap: () {
                            //     model.navigateToBookingView();
                            //   },
                            // ),
                          ],
                        ),
                      ),
                      ListTile(
                        dense: true,
                        leading: const Icon(Icons.mail_outline),
                        title: "Contact us".text.make(),
                        onTap: () {
                          model.navigateToContactUsView();
                        },
                      ),
                      const Divider(
                        height: 1,
                        thickness: 1,
                      ),
                      ListTile(
                        dense: true,
                        leading: const Icon(Icons.settings_outlined),
                        title: "Settings".text.make(),
                        onTap: () {
                          model.navigateToSellerSettingsView();
                        },
                      ),
                    ],
                  ),
                ),
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
                          ProfileHeader(
                              user: seller,
                              shop: model.shop,
                              onFollowersTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => FollowersView(sellerId: seller.id)),
                                ).then((val) => {model.init(seller.shopId, seller)});

                                // model.navigateToFollowersView(seller.id).then((value) {
                                //   print("ab chal gya yha");
                                //   model.init(model.shop!.id, seller);
                                // });
                              },
                              onFollowingTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => FollowingView(sellerId: seller.id)),
                                ).then((val) => {model.init(seller.shopId, seller)});
                                // model
                                //     .navigateToFollowingView(seller.id)
                                //     .then((value) => model.init(model.shop!.id, seller));
                              },
                              headerButton: model.shop != null
                                  ? model.shop!.ownerId == model.currentUser.id
                                      ? Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.46,
                                              child: OutlinedButton(
                                                onPressed: () {
                                                  model.navigateToEditProfile();
                                                },
                                                child: 'Edit Profile'.text.make(),
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.46,
                                              child: OutlinedButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => OrdersView(
                                                              index: 1,
                                                            )),
                                                  ).then((val) => {model.init(seller.shopId, seller)});
                                                },
                                                child: 'Calender'.text.make(),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            model.currentfollowingIds.contains(seller.id)
                                                ? SizedBox(
                                                    width: MediaQuery.of(context).size.width * 0.46,
                                                    child: OutlinedButton(
                                                      onPressed: model.unfollowed
                                                          ? null
                                                          : () {
                                                              //model.unfollowed = true;
                                                              //model.notifyListeners();
                                                              model.unfollow(seller.id).whenComplete(() {
                                                                model.unfollowed = false;
                                                                model.notifyListeners();
                                                              });
                                                            },
                                                      child: const Text('Following'),
                                                    ),
                                                  )
                                                : SizedBox(
                                                    width: MediaQuery.of(context).size.width * 0.46,
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        model.follow(seller.id);
                                                      },
                                                      style: ButtonStyle(
                                                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                          RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(6),
                                                          ),
                                                        ),
                                                        backgroundColor: MaterialStateProperty.all<Color>(
                                                          Color(model.shop!.color),
                                                        ),
                                                      ),
                                                      child:
                                                          const Text('Follow', style: TextStyle(color: Colors.white)),
                                                    ),
                                                  ),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.46,
                                              child: ElevatedButton(
                                                onPressed: () {
                                                  print(model.shop!.policy.length);
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => PolicyScreen(policy: model.shop!.policy)),
                                                  ).then((val) => {model.init(seller.shopId, seller)});
                                                },
                                                style: ButtonStyle(
                                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(6),
                                                    ),
                                                  ),
                                                  backgroundColor: MaterialStateProperty.all<Color>(
                                                    Color(model.shop!.color),
                                                  ),
                                                ),
                                                child: const Text('Policy', style: TextStyle(color: Colors.white)),
                                              ),
                                            ),
                                          ],
                                        )
                                  : Container()),
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
                                  child: "+ ${Constants.createShopLabel}".text.bold.color(Styles.kcPrimaryColor).make(),
                                ),
                              ],
                            )
                          else
                            Column(
                              children: [
                                // model.shop!.name.text.xl2
                                //     .fontFamily(model.shop!.fontStyle)
                                //     .color(Color(model.shop!.color))
                                //     .make(),
                                // 10.heightBox,
                                // RatingStars(
                                //   value: model.shop!.rating,
                                //   starSize: 16,
                                //   valueLabelVisibility: false,
                                // ),
                                // 10.heightBox,
                                // 10.heightBox,
                                // model.shop!.description.text.center.make(),
                                // const Divider(
                                //   thickness: 1,
                                // ),
                                if (model.services.isEmpty && model.shop!.ownerId == model.currentUser.id)
                                  Column(
                                    children: [
                                      TextButton.icon(
                                        label: Constants.addServiceLabel.text.make(),
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
                                      ).box.border(color: Colors.amber).roundedSM.p12.make().p12()
                                    ],
                                  )
                                else
                                  GridView.builder(
                                      padding: EdgeInsets.all(0),
                                      shrinkWrap: true,
                                      physics: const BouncingScrollPhysics(),
                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 1.5,
                                        mainAxisSpacing: 1.5,
                                        childAspectRatio: 1,
                                      ),
                                      itemCount: model.shop!.ownerId == model.currentUser.id && viewingAsProfile == true
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
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  //color: Colors.red,
                                                  //border: Border.all(color: Colors.white, width: 0.5)
                                                  ),
                                              //height: context.screenHeight / 7,
                                              //width: context.screenHeight / 2.5,
                                              child: AspectRatio(
                                                aspectRatio: 1,
                                                child: ClipRRect(
                                                  //borderRadius: BorderRadius.circular(2),
                                                  child: CachedNetworkImage(
                                                    imageUrl: imageUrl(
                                                      model.services[index].imageUrl1,
                                                      model.services[index].imageUrl2,
                                                      model.services[index].imageUrl3,
                                                    ),
                                                    fit: BoxFit.cover,
                                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                                  ),
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
                                      // },
                                      )
                              ],
                            ) //.pSymmetric(h: 0)
                        ],
                      ),
                    ),
                  ),
                  BusyLoader(busy: model.isApiLoading),
                ],
              ),
              floatingActionButton: (model.shop!.ownerId == model.currentUser.id && viewingAsProfile == true)
                  ? FloatingActionButton(
                      onPressed: () {
                        model.navigateToCreateServiceView(model.shop!);
                      },
                      child: Icon(Icons.add),
                      backgroundColor: Styles.kcPrimaryColor,
                      foregroundColor: Colors.white,
                    )
                  : null,
            ),
      viewModelBuilder: () => SellerProfileViewModel(),
    );
  }
}
