import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/models/shop.dart';
import 'package:mipromo/models/shop_service.dart';
import 'package:mipromo/ui/category/category_viewmodel.dart';
import 'package:mipromo/ui/home/home_viewmodel.dart';
import 'package:mipromo/ui/shared/widgets/basic_loader.dart';
import 'package:mipromo/ui/shared/widgets/shop_card.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:velocity_x/velocity_x.dart';

class ShopView extends StatelessWidget {
  // final String category;
  // final List<Shop> categoryShops;
  // final List<Shop> allShops;
  // final List<AppUser> allSellers;
  // final List<ShopService> allServices;
  // final AppUser user;

  const ShopView({
    Key? key,
    // required this.category,
    // required this.categoryShops,
    // required this.allShops,
    // required this.allSellers,
    // required this.allServices,
    // required this.user,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      // onModelReady: (model) => model.init(allShops),
      onModelReady: (model) => model.init(),
      builder: (context, model, child) {
        return model.isBusy
            ? const BasicLoader()
            : Scaffold(
                appBar: AppBar(
                  title:const Text("Tops"),
                   centerTitle: true,
                  actions: const [
                    SizedBox.shrink(),
                  ],
                ),
                 
                body: model.allSellers.isEmpty
                    ? "No Shops".text.makeCentered()
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
                           
                            Padding(
                              padding: const EdgeInsets.all(8),
                             child:ListView.builder(
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
                           
                            ),
                            
                         
                          ],
                        ),
                      ),
              );
      },
      viewModelBuilder: () => HomeViewModel(),
    );
  }
}

