import 'package:flutter/material.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/ui/profile/buyer/buyer_profile_view.dart';
import 'package:mipromo/ui/profile/no_shop_profile_view.dart';
import 'package:mipromo/ui/profile/profile_viewmodel.dart';
import 'package:mipromo/ui/profile/seller/seller_profile_view.dart';
import 'package:mipromo/ui/shared/widgets/basic_loader.dart';
import 'package:stacked/stacked.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({
    Key? key,
    required this.user,
  }) : super(key: key);

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel>.reactive(
      builder: (context, model, child) => profileViewSelector(model, user),
      viewModelBuilder: () => ProfileViewModel(),
    );
  }

  Widget profileViewSelector(
    ProfileViewModel model,
    AppUser user,
  ) {
    if (model.isBusy) {
      return const BasicLoader();
    } else {
      if (user.userType == 'seller') {
        if (user.shopId.isEmpty) {
          return NoShopProfileView(
            user: user,
          );
        } else {
          return SellerProfileView(
            seller: user,
            viewingAsProfile: true,
          );
        }
      } else {
        return BuyerProfileView(user: user, viewingAsProfile: true,);
      }
    }
  }
}
