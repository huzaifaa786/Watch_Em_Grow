import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
import 'package:mipromo/ui/home/home_viewmodel.dart';
import 'package:mipromo/ui/search/search_view.dart';
import 'package:mipromo/ui/search/widgets/search_bar.dart';
import 'package:mipromo/ui/shared/widgets/basic_loader.dart';
import 'package:mipromo/ui/shared/widgets/featured_shop_card.dart';
import 'package:mipromo/ui/shared/widgets/shop_card.dart';
import 'package:mipromo/ui/static_widget/banner_card.dart';
import 'package:mipromo/ui/static_widget/category_card.dart';
import 'package:mipromo/ui/static_widget/categorys_card.dart';
import 'package:mipromo/user_interface/product/top_product.dart';
import 'package:mipromo/user_interface/store/store_product.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  void didChangeDependencies() {
    precacheImage(AssetImage("assets/images/child.jpg"), context);
    precacheImage(AssetImage("assets/images/product3.jpg'"), context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    return ViewModelBuilder<HomeViewModel>.reactive(
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => model.isBusy
          ? const BasicLoader()
          : model.allShops.isEmpty
              ? Material(
                  child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Container(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 40,
                        ),
                        Card(
                          child: ListTile(
                            title: TextField(
                              // controller: controller,
                              decoration: const InputDecoration(
                                hintText: 'Search',
                                border: InputBorder.none,
                              ),
                              // onChanged: onChanged,
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.search),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const SearchView()),
                                );
                              },
                            ),
                          ),
                        ).p8(),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 160,
                          child: Swiper(
                            physics: const BouncingScrollPhysics(),
                            itemCount: [
                              0,1,2
                            ].length /* <= 3
                                          ? model.allShops.length
                                          : 3*/
                            ,
                            autoplay: true,
                            loop: false,
                            curve: Curves.easeInOutQuart,
                            duration: 800,
                            itemBuilder: (context, index) => FeaturedShopCard(
                              shop: 'FeaturedShop',
                              shopOwner: 'Haseeb',
                              category: 'Tops',
                              imageUrl: "https://www.google.com/url?sa=i&url=https%3A%2F%2Fimglarger.com%2F&psig=AOvVaw32Sg8-HgX-GdMDXw_H2dXX&ust=1685259433806000&source=images&cd=vfe&ved=0CBEQjRxqFwoTCNiCr-n-lP8CFQAAAAAdAAAAABAE",
                              shopName: 'Nahide Stall',
                              lowestPrice: '200',
                              highestPrice: '500',
                              // shop: model.featuredShops[index],
                              // shopOwner: model.allSellers.singleWhere(
                              //   (owner) =>
                              //       owner.shopId ==
                              //       model.featuredShops[index].id,
                              // ),
                            ).mdClick(() {
                              // model.navigateToShopView(
                              // shop: model.featuredShops[index],
                              // owner: model.allSellers.singleWhere(
                              //   (owner) =>
                              //       owner.shopId ==
                              //       model.featuredShops[index].id,
                              // ),
                              // );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const TopProductScreen()),
                              );
                            }).make(),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                         BannerCard(
                          onPressed: (){
                            Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const TopProductScreen()),
                                    );
                        },),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                Column(
                                  children: [
                                    CategoryCard(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const TopProductScreen()),
                                        );
                                      },
                                      title: 'outware',
                                      image: 'assets/images/product3.jpg',
                                    ),
                                    CategoryCard(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const TopProductScreen()),
                                        );
                                      },
                                      title: 'Accessories',
                                      image: 'assets/images/product3.jpg',
                                    )
                                  ],
                                )
                              ],
                            ),
                            Row(
                              children: [
                                CategorysCard(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const TopProductScreen()),
                                    );
                                  },
                                  title: 'Tops',
                                  image: 'assets/images/product3.jpg',
                                )
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Row(
                              children: [
                                CategoryCard(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const TopProductScreen()),
                                    );
                                  },
                                  title: 'bottom',
                                  image: 'assets/images/product3.jpg',
                                )
                              ],
                            ),
                            Row(
                              children: [
                                CategoryCard(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const TopProductScreen()),
                                    );
                                  },
                                  image: 'assets/images/product3.jpg',
                                  title: 'Tops',
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ))
              : Scaffold(
                  body: SafeArea(
                    child: RefreshIndicator(
                      onRefresh: model.reload,
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Container(
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
                                  // Container(
                                  //   height: 160,
                                  //   child: Swiper(
                                  //     physics: const BouncingScrollPhysics(),
                                  //     itemCount: model.featuredShops
                                  //         .length /* <= 3
                                  //         ? model.allShops.length
                                  //         : 3*/
                                  //     ,
                                  //     autoplay: true,
                                  //     loop: false,
                                  //     curve: Curves.easeInOutQuart,
                                  //     duration: 800,
                                  //     itemBuilder: (context, index) =>
                                  //         FeaturedShopCard(
                                  //       shop: model.featuredShops[index],
                                  //       shopOwner: model.allSellers.singleWhere(
                                  //         (owner) =>
                                  //             owner.shopId ==
                                  //             model.featuredShops[index].id,
                                  //       ),
                                  //     ).mdClick(() {
                                  //       model.navigateToShopView(
                                  //         shop: model.featuredShops[index],
                                  //         owner: model.allSellers.singleWhere(
                                  //           (owner) =>
                                  //               owner.shopId ==
                                  //               model.featuredShops[index].id,
                                  //         ),
                                  //       );
                                  //     }).make(),
                                  //   ),
                                  // ),
                                ],
                              ),
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
                                    height: context.screenWidth / 2.7,
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
                                            SizedBox(
                                                width: 110,
                                                child: Text(
                                                    model
                                                        .categories[index].name,
                                                    textAlign:
                                                        TextAlign.center)),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              if (model.bestSellers.isNotEmpty)
                                "Best Sellers"
                                    .text
                                    .xl
                                    .bold
                                    .make()
                                    .pLTRB(22, 12, 0, 0),
                              ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: model.bestSellers.length,
                                  itemBuilder: (context, index) {
                                    final owner = model.allSellers.singleWhere(
                                        (owner) =>
                                            owner.id ==
                                            model.bestSellers[index].ownerId);

                                    final mservices = model.allServices
                                        .where((s) =>
                                            s.shopId ==
                                            model.bestSellers[index].id)
                                        .toList();
                                    return ShopCard(
                                      owner: owner,
                                      shop: model.bestSellers[index],
                                      services: mservices,
                                    ).p8();
                                  })
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
      viewModelBuilder: () => HomeViewModel(),
    );
  }
}
