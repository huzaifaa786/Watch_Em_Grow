import 'package:flutter/material.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
import 'package:mipromo/ui/home/home_viewmodel.dart';
import 'package:mipromo/ui/shared/widgets/basic_loader.dart';
import 'package:mipromo/ui/shared/widgets/featured_shop_card.dart';
import 'package:mipromo/ui/shared/widgets/shop_card.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return ViewModelBuilder<HomeViewModel>.reactive(
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => model.isBusy
          ? const BasicLoader()
          : model.allShops.isEmpty
              ? const Material(
                  child: Center(
                    child: Text('No Shops Yet!'),
                  ),
                )
              : Scaffold(
                  appBar: AppBar(
                    title: const Text('Home'),
                  ),
                  body: SafeArea(
                    child: RefreshIndicator(
                      onRefresh: model.reload,
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                "Featured"
                                    .text
                                    .xl
                                    .bold
                                    .make()
                                    .pLTRB(22, 12, 0, 12),
                                Expanded(
                                  child: Swiper(
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: model.featuredShops.length/* <= 3
                                        ? model.allShops.length
                                        : 3*/,
                                    autoplay: true,
                                    loop: false,
                                    curve: Curves.easeInOutQuart,
                                    duration: 800,
                                    itemBuilder: (context, index) =>
                                        FeaturedShopCard(
                                      shop: model.featuredShops[index],
                                      shopOwner: model.allSellers.singleWhere(
                                        (owner) =>
                                            owner.shopId ==
                                            model.featuredShops[index].id,
                                      ),
                                    ).mdClick(() {
                                      model.navigateToShopView(
                                        shop: model.featuredShops[index],
                                        owner: model.allSellers.singleWhere(
                                          (owner) =>
                                              owner.shopId ==
                                              model.featuredShops[index].id,
                                        ),
                                      );
                                    }).make(),
                                  ),
                                ),
                              ],
                            )
                                .box
                                .height(context.screenHeight * 0.27)/// 3.2)
                                .width(context.screenWidth)
                                .make(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                "Shop by Category"
                                    .text
                                    .xl
                                    .bold
                                    .make()
                                    .pLTRB(22, 12, 0, 12),
                                SizedBox(
                                  height: context.screenWidth / 3,
                                  child: ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: model.categories.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      final assetImage = AssetImage(
                                        model.categories[index].imageUrl,
                                      );
                                      precacheImage(assetImage, context);

                                      return Column(
                                        children: [
                                          CircleAvatar(
                                            radius: context.screenWidth / 12,
                                            backgroundColor: Colors.grey[300],
                                            child: ClipOval(
                                              child: SizedBox(
                                                width: double.infinity,
                                                height: double.infinity,
                                                child: Image(
                                                  image: assetImage,
                                                  fit: BoxFit.cover,
                                                  loadingBuilder: (
                                                    context,
                                                    child,
                                                    loadingProgress,
                                                  ) {
                                                    if (loadingProgress ==
                                                        null) {
                                                      return child;
                                                    }
                                                    return Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        value: loadingProgress
                                                                    .expectedTotalBytes !=
                                                                null
                                                            ? loadingProgress
                                                                    .cumulativeBytesLoaded /
                                                                loadingProgress
                                                                    .expectedTotalBytes!
                                                            : null,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          )
                                              .card
                                              .withRounded(value: 100)
                                              .elevation(4)
                                              .make()
                                              .p12()
                                              .click(
                                            () {
                                              model.navigateToCategoryView(
                                                model.categories[index].name,
                                              );
                                            },
                                          ).make(),
                                          model.categories[index].name.text
                                              .make(),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            if(model.bestSellers.isNotEmpty)
                            "Best Sellers"
                                .text
                                .xl
                                .bold
                                .make()
                                .pLTRB(22, 12, 0, 0),
                            ListView.builder(
                              padding:    
                                  const EdgeInsets.symmetric(horizontal: 12),
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: model.bestSellers.length,
                              itemBuilder: (context, index) => ShopCard(
                                owner: model.allSellers.singleWhere(
                                  (e) => e.id == model.bestSellers[index].ownerId,
                                ),
                                shop: model.bestSellers[index],
                                services: model.allServices
                                    .where(
                                      (s) =>
                                          s.shopId == model.bestSellers[index].id,
                                    )
                                    .toList(),
                              ).p8(),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
      viewModelBuilder: () => HomeViewModel(),
    );
  }
}
