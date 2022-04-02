import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/models/shop.dart';
import 'package:mipromo/models/shop_service.dart';
import 'package:mipromo/ui/category/category_viewmodel.dart';
import 'package:mipromo/ui/shared/widgets/basic_loader.dart';
import 'package:mipromo/ui/shared/widgets/shop_card.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:velocity_x/velocity_x.dart';

class CategoryView extends StatelessWidget {
  final String category;
  final List<Shop> categoryShops;
  final List<Shop> allOtherShops;
  final List<AppUser> allSellers;
  final List<ShopService> allServices;

  const CategoryView({
    Key? key,
    required this.category,
    required this.categoryShops,
    required this.allOtherShops,
    required this.allSellers,
    required this.allServices,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CategoryViewModel>.reactive(
      onModelReady: (model) => model.init(categoryShops),
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
                                          s.location == model.filteredLocation || s.borough == model.filteredLocation)
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
                body: model.shops.isEmpty
                    ? "No Shops in this Category".text.makeCentered()
                    : SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    height: MediaQuery.of(context).size.height / 19,
                                    child: Image.asset('assets/images/logo_new_sub.png'
                                    )),
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
                                        label: "Sort".text.color(Colors.grey).make(),
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
                                        label: "Filter".text.color(Colors.grey).make(),
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
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: model.shops.length,
                                itemBuilder: (context, index) {
                                  final AppUser owner = allSellers.singleWhere(
                                    (seller) =>
                                        seller.shopId == model.shops[index].id,
                                  );

                                  return ShopCard(
                                    owner: owner,
                                    shop: model.shops[index],
                                    services: allServices
                                        .where((service) =>
                                            service.shopId ==
                                            model.shops[index].id)
                                        .toList(),
                                  );
                                },
                              ),
                            ),
                            const Divider(
                              thickness: 1,
                            ),
                            "You may also like".text.xl.bold.make().p8(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: allOtherShops.length,
                                itemBuilder: (context, index) {
                                  final AppUser owner = allSellers.singleWhere(
                                      (e) => e.shopId == allOtherShops[index].id);

                                  return ShopCard(
                                    owner: owner,
                                    shop: allOtherShops[index],
                                    services: allServices
                                        .where((s) =>
                                            s.shopId == allOtherShops[index].id)
                                        .toList(),
                                  );
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                /*bottomNavigationBar: Builder(
                  builder: (context) => BottomAppBar(
                    child: Row(
                      children: [
                        Expanded(
                          child: TextButton.icon(
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            },
                            label: "Sort".text.color(Colors.grey).make(),
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
                            label: "Filter".text.color(Colors.grey).make(),
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
                ),*/
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
