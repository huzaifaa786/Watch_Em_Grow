import 'package:flutter/material.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/ui/profile/buyer/buyer_profile_viewmodel.dart';
import 'package:mipromo/ui/shared/helpers/constants.dart';
import 'package:mipromo/ui/shared/widgets/basic_loader.dart';
import 'package:mipromo/ui/shared/widgets/busy_loader.dart';
import 'package:mipromo/ui/shared/widgets/profile_header.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class BuyerProfileView extends StatelessWidget {
  const BuyerProfileView({
    Key? key,
    required this.user,
    this.viewingAsProfile = false,
  }) : super(key: key);

  final AppUser user;
  final bool? viewingAsProfile;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BuyerProfileViewModel>.reactive(
      onModelReady: (model) => model.init(user),
      builder: (context, model, child) => model.isBusy
          ? const BasicLoader()
          : Scaffold(
              appBar: AppBar(
                title: '@${user.username}'.text.bold.make(),
                leading: viewingAsProfile != true
                    ? BackButton(
                        onPressed: () {
                          model.backToNotifications();
                        },
                      )
                    : null,
                actions: [
                  if (user.id == model.currentUser.id)
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
                            /*ListTile(
                              leading: Icon(
                                Icons.info_outline,
                                color: Colors.grey.shade700,
                              ),
                              title: "About".text.make(),
                            ),*/
                            ListTile(
                              leading: Icon(
                                Icons.list_alt,
                                color: Colors.grey.shade700,
                              ),
                              title: 'Orders'.text.make(),
                              onTap: () {
                                model.navigateToOrders();
                              },
                            ),
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
                        height: 0,
                        thickness: 0.5,
                      ),
                      ListTile(
                        dense: true,
                        leading: const Icon(Icons.settings_outlined),
                        title: "Settings".text.make(),
                        onTap: () {
                          model.navigateToBuyerSettingsView();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              body: Stack(
                children: [
                  Column(
                    children: [
                      ProfileHeader(
                        user: user,
                        onFollowersTap: () {
                          model.navigateToFollowersView(
                              user.id /*model.currentUser.id*/);
                        },
                        onFollowingTap: () {
                          model.navigateToFollowingView(
                              user.id /*model.currentUser.id*/);
                        },
                        headerButton: user.id == model.currentUser.id
                            ? OutlinedButton(
                                onPressed: () {
                                  model.navigateToEditProfile(user);
                                },
                                child: 'Edit Profile'.text.make(),
                              )
                            : model.currentfollowingIds.contains(user.id)
                                ? OutlinedButton(
                                    onPressed: model.unfollowed
                                        ? null
                                        : () {
                                            model.unfollow(user.id);
                                          },
                                    child: const Text('Following'),
                                  )
                                : ElevatedButton(
                                    onPressed: () {
                                      model.follow(user.id);
                                    },
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                      ),
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                        Color(4284402649),
                                      ),
                                    ),
                                    child: const Text('Follow'),
                                  ),
                      ),
                      // Expanded(
                      Container(
                        height: MediaQuery.of(context).size.height * 0.56,
                        // color: Colors.green,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            /*_Data(
                          title: Constants.broughtLabel,
                          value: user.purchases.toString(),
                      ),
                      _Data(
                          title: Constants.referralsLabel,
                          value: user.referrals.toString(),
                      ),
                      _Data(
                          title: Constants.earnedLabel,
                          value: "£${user.earnByRef == 0 ? 0 : user.earnByRef}",
                      ),*/
                            // ignore: prefer_const_constructors
                            Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                               border: Border.all(
                                 width: 3,
                                 color: Colors.black,
                               ),
                               borderRadius: BorderRadius.circular(50),
                              ),
                              child: Icon(Icons.person_pin_outlined,
                              size:35,
                              ),
                            ),
                            SizedBox(height:8 ),
                            Text(
                              "Photos and Video of You ",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              "When you open a Shop your Post will appear here.",
                            ),
                            SizedBox(height: 10),
                            if (viewingAsProfile == true)
                              ElevatedButton(
                                onPressed: () {
                                  model.showCreateSellerProfileDialog(user);
                                },
                                style: ButtonStyle(
                                  shape:
                                      MaterialStateProperty.all<OutlinedBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                child: Constants.openShopLabel.text.white.bold
                                    .make(),
                              ),
                          ],
                        ),
                      ),
                      // ),
                    ],
                  ),
                  BusyLoader(busy: model.isApiLoading),
                ],
              ),
            ),
      viewModelBuilder: () => BuyerProfileViewModel(),
    );
  }
}

class _Data extends StatelessWidget {
  final String title;
  final String value;

  const _Data({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        title.text.gray500.xl2.make().pOnly(
              bottom: 20,
            ),
        value.text.xl2.make(),
      ],
    );
  }
}
