import 'package:flutter/material.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mipromo/api/database_api.dart';

import 'package:mipromo/app/app.locator.dart';
import 'package:mipromo/models/shop.dart';
import 'package:mipromo/ui/search/search_viewmodel.dart';
import 'package:mipromo/ui/search/widgets/search_bar.dart';
import 'package:mipromo/ui/shared/widgets/basic_loader.dart';
import 'package:mipromo/ui/shared/widgets/featured_shop_card.dart';
import 'package:mipromo/ui/shared/widgets/shop_card.dart';
import 'package:mipromo/ui/shared/widgets/small_shop_card.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:velocity_x/velocity_x.dart';

class SearchView extends StatefulWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  ScrollController scrollController = ScrollController();
  final _databaseApi = locator<DatabaseApi>();


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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                model.following == false
                    ? Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          "Suggested",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      )
                    : Text('')
              ],
            ),
            Expanded(
              child: model.searchedShops.isNotEmpty || controller.text.isNotEmpty
                  ? ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      controller: model.controller,
                      itemCount: model.searchedShops.length,
                      itemBuilder: (context, i) {
                        final Shop shop = model.searchedShops[i];

                        final owner = model.shopOwners!.singleWhere((owner) => owner.shopId == shop.id);

                        return ShopCard(
                          owner: owner,
                          shop: shop,
                          services: model.allServices!.where((service) => service.shopId == shop.id).toList(),
                        ).p8();
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
                          'Search for Vendors'.text.make(),
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
