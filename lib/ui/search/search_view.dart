import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mipromo/models/shop.dart';
import 'package:mipromo/ui/search/search_viewmodel.dart';
import 'package:mipromo/ui/search/widgets/search_bar.dart';
import 'package:mipromo/ui/shared/widgets/basic_loader.dart';
import 'package:mipromo/ui/shared/widgets/shop_card.dart';
import 'package:mipromo/ui/shared/widgets/small_shop_card.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:velocity_x/velocity_x.dart';

class SearchView extends StatelessWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SearchViewModel>.reactive(
      onModelReady: (model) => Future.delayed(Duration.zero, () async {
        model.init();
      }),
      builder: (context, model, child) => model.isBusy ? const BasicLoader() : SearchWidget(),
      viewModelBuilder: () => SearchViewModel(),
    );
  }
}

class SearchWidget extends HookViewModelWidget<SearchViewModel> {
  @override
  Widget buildViewModelWidget(BuildContext context, SearchViewModel model) {
    final TextEditingController controller = useTextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SearchBar(
              controller: controller,
              onChanged: model.onSearchTextChanged,
              onPressed: () {
                controller.clear();
                model.onSearchTextChanged('');
              },
            ),
            Expanded(
              child: model.searchedShops.isNotEmpty || controller.text.isNotEmpty
                  ? GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        //crossAxisCount: 2,
                        crossAxisCount: 1,
                        //crossAxisSpacing: 8,
                        crossAxisSpacing: 2,
                        //mainAxisSpacing: 8,
                        mainAxisSpacing: 0,
                        childAspectRatio: 1.8,
                      ),
                      itemCount: model.searchedShops.length,
                      itemBuilder: (context, i) {
                        final Shop shop = model.searchedShops[i];

                        final owner = model.shopOwners!.singleWhere((owner) => owner.shopId == shop.id);

                        return ShopCard(
                          owner: owner,
                          shop: shop,
                          services: model.allServices!.where((service) => service.shopId == shop.id).toList(),
                        );
                        /*return SmallShopCard(
                          shop: shop,
                          shopOwner: model.shopOwners.singleWhere(
                            (owner) => owner.shopId == shop.id,
                          ),
                          onClick: () {
                            model.navigateToShopView(
                              shop: shop,
                              owner: owner,
                              services: model.allServices
                                  .where(
                                    (s) =>
                                        s.shopId == model.searchedShops[i].id,
                                  )
                                  .toList(),
                            );
                          },
                        );*/
                      },
                    ).p8()
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/search.png',
                            height: context.screenHeight / 4,
                          ),
                          12.heightBox,
                          'Search for Shops'.text.make(),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
