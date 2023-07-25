import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/models/shop.dart';
import 'package:mipromo/models/shop_service.dart';
import 'package:mipromo/ui/category/category_viewmodel.dart';
import 'package:mipromo/ui/shared/widgets/basic_loader.dart';
import 'package:mipromo/ui/shared/widgets/shop_card.dart';
import 'package:mipromo/ui/value/colors.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:velocity_x/velocity_x.dart';

class CategoryView extends StatelessWidget {
  final String category;
  final List<Shop> categoryShops;
  final List<ShopService> categoryShopServices;
  final List<Shop> allOtherShops;
  final List<AppUser> allSellers;
  final List<ShopService> allServices;

  const CategoryView({
    Key? key,
    required this.category,
    required this.categoryShops,
    required this.categoryShopServices,
    required this.allOtherShops,
    required this.allSellers,
    required this.allServices,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CategoryViewModel>.reactive(
      onModelReady: (model) => model.init(categoryShops, categoryShopServices),
      builder: (context, model, child) {
        return model.isBusy
            ? const BasicLoader()
            : Scaffold(
                appBar: AppBar(
                  title: category.text.lg.make(),
                  leading: const BackButton(),
                  actions: const [
                    SizedBox.shrink(),
                  ],
                ),
                drawer: Drawer(
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text('Sort By:'),
                          Expanded(
                            child: Column(
                              children: [
                                RadioListTile<CategorySortBy>(
                                  value: CategorySortBy.featured,
                                  groupValue: model.sortBy,
                                  onChanged: model.toggleSort,
                                  title: const Text('Featured'),
                                ),
                                RadioListTile<CategorySortBy>(
                                  value: CategorySortBy.ratings,
                                  groupValue: model.sortBy,
                                  onChanged: model.toggleSort,
                                  title: const Text('Ratings'),
                                ),
                                RadioListTile<CategorySortBy>(
                                  value: CategorySortBy.priceRangeLowToHigh,
                                  groupValue: model.sortBy,
                                  onChanged: model.toggleSort,
                                  title: const Text('Price Range: Low to High'),
                                ),
                                RadioListTile<CategorySortBy>(
                                  value: CategorySortBy.priceRangeHighToLow,
                                  groupValue: model.sortBy,
                                  onChanged: model.toggleSort,
                                  title: const Text('Price Range: High to Low'),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  model.sort();
                                },
                                child: const Text('Done'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                endDrawer: Drawer(
                  child: SafeArea(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: () {
                                model.searchedLocations.clear();
                                model.shops = model.chachedShops;
                                model.filteredLocation = '';
                                model.notifyListeners();
                              },
                              child: const Text(
                                'Clear',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                model.searchedLocations.clear();
                                model.searchedLocations
                                    .add(model.filteredLocation);

                                if (model.filteredLocation.isNotEmpty) {
                                  model.shops = model.shops
                                      .where((s) =>
                                          s.location ==
                                              model.filteredLocation ||
                                          s.borough == model.filteredLocation)
                                      .toList();
                                  model.notifyListeners();
                                  Navigator.pop(context);
                                }
                              },
                              child: const Text(
                                'Apply',
                              ),
                            ),
                          ],
                        ).pOnly(top: 2),
                        const Divider(
                          height: 1,
                          thickness: 1,
                        ),
                        _SearchLocations(),
                        Expanded(
                          child: ListView.builder(
                            itemCount: model.searchedLocations.length,
                            itemBuilder: (context, index) =>
                                RadioListTile<String>(
                              value: model.searchedLocations[index],
                              groupValue: model.filteredLocation,
                              onChanged: (v) {
                                model.filteredLocation = v!;
                                model.notifyListeners();
                              },
                              title: Text(model.searchedLocations[index]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                body: model.services.isEmpty
                    ? "No Services in this Category".text.makeCentered()
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Container(
                                //     height: MediaQuery.of(context).size.height / 19,
                                //     child: Image.asset('assets/images/logo_new_sub.png'
                                //     )),
                              ],
                            ),
                            SizedBox(
                              height: 50,
                              width: double.infinity,
                              //color: Colors.redAccent,
                              child: Builder(
                                builder: (context) => Row(
                                  children: [
                                    Expanded(
                                      child: TextButton.icon(
                                        onPressed: () {
                                          Scaffold.of(context).openDrawer();
                                        },
                                        label: "Sort"
                                            .text
                                            .color(Colors.grey)
                                            .make(),
                                        icon: const Icon(
                                          Icons.swap_vert,
                                          size: 18,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    const VerticalDivider(
                                      thickness: 1.5,
                                    ).h(25),
                                    Expanded(
                                      child: TextButton.icon(
                                        onPressed: () {
                                          Scaffold.of(context).openEndDrawer();
                                        },
                                        label: "Filter"
                                            .text
                                            .color(Colors.grey)
                                            .make(),
                                        icon: const Icon(
                                          Icons.filter_alt_outlined,
                                          size: 18,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GridView.builder(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 3.0,
                                  mainAxisSpacing: 3.0,
                                  childAspectRatio: 1,
                                ),
                                itemCount: model.services.length,
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
                                    // mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: context.screenHeight / 6.5,
                                        width: context.screenHeight / 5.2,
                                        child: Stack(
                                          children: [
                                            Positioned.fill(
                                              child: AspectRatio(
                                                aspectRatio: 1,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: CachedNetworkImage(
                                                    imageUrl: imageUrl(
                                                      model.services[index]
                                                          .imageUrl1,
                                                      model.services[index]
                                                          .imageUrl2,
                                                      model.services[index]
                                                          .imageUrl3,
                                                    ),
                                                    fit: BoxFit.cover,
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons.error),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.bottomLeft,
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10.0,
                                                            bottom: 10),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        shape:
                                                            BoxShape.rectangle,
                                                        color: Vx.black,
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          'New',
                                                          style: TextStyle(
                                                              color: white),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.35,
                                                child: model.services[index]
                                                    .name.text.bold
                                                    .maxLines(2)
                                                    .make()
                                                    .pSymmetric(h: 4, v: 2),
                                              ),
                                              "£${model.services[index].price}"
                                                  .text
                                                  .xs
                                                  .make()
                                                  .px4(),
                                            ],
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Container(
                                              height: 30,
                                              width: 30,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: white,
                                              ),
                                              child: Icon(
                                                Icons.favorite_border,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ).mdClick(() {
                                    // model.navigateToServiceView(
                                    //   model.services[index],
                                    //   model.services[index]shop!.color,
                                    //   model.shop!.fontStyle,
                                    // );
                                  }).make();
                                }
                                // },
                                )
                          ],
                        ),
                      ),
              );
      },
      viewModelBuilder: () => CategoryViewModel(),
    );
  }
}

class _SearchLocations extends HookViewModelWidget<CategoryViewModel> {
  @override
  Widget buildViewModelWidget(
    BuildContext context,
    CategoryViewModel model,
  ) {
    final TextEditingController controller = useTextEditingController();

    return Card(
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Search location',
          border: InputBorder.none,
          isCollapsed: true,
          suffix: const Icon(
            Icons.close,
            size: 16,
          ).onInkTap(
            () {
              controller.clear();
              model.onLocationsSearchTextChanged('');
            },
          ),
        ),
        onChanged: model.onLocationsSearchTextChanged,
      ).p8(),
    ).pLTRB(12, 12, 12, 0);
  }
}
