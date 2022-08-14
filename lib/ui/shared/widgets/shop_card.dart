import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mipromo/app/app.locator.dart';
import 'package:mipromo/app/app.router.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/models/shop.dart';
import 'package:mipromo/models/shop_service.dart';
import 'package:mipromo/ui/shared/helpers/constants.dart';
import 'package:mipromo/ui/shared/widgets/avatar.dart';
import 'package:mipromo/ui/shared/widgets/followers_counter.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:velocity_x/velocity_x.dart';

class ShopCard extends StatelessWidget {
  final AppUser owner;
  final Shop shop;
  final List<ShopService> services;

  const ShopCard({
    Key? key,
    required this.owner,
    required this.shop,
    required this.services,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<_ShopCardViewModel>.reactive(
      builder: (context, model, child) => Column(
        children: [
          Row(
            children: [
              Avatar(
                radius: context.screenWidth / 20,
                imageUrl: owner.imageUrl,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  shop.name.text.fontFamily(shop.fontStyle).make(),
                  FollowersCounter(
                    followers: owner.followers,
                    richText: false,
                  ),
                ],
              ).px12(),
              const Spacer(),
              TextButton(
                onPressed: () {
                  model.navigateToShopView(
                    owner,
                  );
                },
                child: Constants.viewShopLabel.text.color(Theme.of(context).primaryColor).make(),
              ),
            ],
          ),
          if (services.isNotEmpty)
            SizedBox(
              height: context.screenHeight / 7.2,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: services.length < 3 ? services.length : 3,
                itemBuilder: (context, index) => Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: services[index].imageUrl1 == null || services[index].imageUrl1!.isEmpty
                      ? const Center(
                          child: Icon(Icons.broken_image_outlined),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: CachedNetworkImage(
                            imageUrl: services[index].imageUrl1!,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                          ),
                        ),
                ).box.width(context.screenWidth / 3.4).make().px2().mdClick(
                  () {
                    model.navigateToServiceView(
                      services[index],
                      shop.color,
                      shop.fontStyle,
                    );
                  },
                ).make(),
              ),
            )
          else
            const SizedBox.shrink(),
        ],
      ),
      viewModelBuilder: () => _ShopCardViewModel(),
    );
  }
}

class _ShopCardViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();

  Future navigateToShopView(
    AppUser owner,
  ) async {
    await _navigationService.navigateTo(
      Routes.sellerProfileView,
      arguments: SellerProfileViewArguments(
        seller: owner,
      ),
    );
  }

  Future navigateToServiceView(
    ShopService service,
    int color,
    String font,
  ) async {
    await _navigationService.navigateTo(
      Routes.serviceView,
      arguments: ServiceViewArguments(
        service: service,
        color: color,
        fontStyle: font,
      ),
    );
  }
}
