import 'package:flutter/material.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/ui/profile/buyer/buyer_profile_viewmodel.dart';
import 'package:mipromo/ui/shared/helpers/constants.dart';
import 'package:mipromo/ui/shared/widgets/avatar.dart';
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
          : SafeArea(
              child: Scaffold(
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
                    if (viewingAsProfile != true)
                      Builder(
                          builder: (context) => InkWell(
                                onTap: () async {
                                  await model.handleReport(context);
                                  if (model.selectReport) {
                                    Future.delayed(Duration(milliseconds: 800)).then((value) {
                                      model.reportedDone(context);
                                    });
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.error_outline)
                                      /*Text('Report'),*/
                                    ],
                                  ),
                                ),
                              ))
                    else if (user.id == model.currentUser.id)
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
                body: SingleChildScrollView(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        // ignore: prefer_if_elements_to_conditional_expressions
                        user.imageUrl == ''
                            ? CircleAvatar(
                                backgroundImage: AssetImage('assets/images/default.png'),
                                radius: 55,
                              )
                            : Avatar(
                                radius: context.screenWidth / 7,
                                imageUrl: user.imageUrl,
                              ),
                        SizedBox(
                          height: 50,
                        ),

                        Text(
                          'Buyer Profile',
                          style: TextStyle(fontSize: 22),
                        ),
                        SizedBox(
                          height: 50,
                        ),

                        Column(
                          children: [
                            (user.following > 999
                                    ? "${(user.following / 1000).toDoubleStringAsFixed(digit: 1)}k"
                                    : "${user.following}")
                                .text
                                .lg
                                .bold
                                .make(),
                            'Following'.text.lg.make(),
                          ],
                        ).onTap(() {
                          model.navigateToFollowingView(user.id /*model.currentUser.id*/);
                        }),
                        SizedBox(
                          height: 40,
                        ),

                        Text(
                          'Transactions Completed : ${user.purchases}',
                          style: TextStyle(fontSize: 15),
                        ),
                        SizedBox(
                          height: 60,
                        ),
                        Image(
                          image: AssetImage('assets/icon/bag.png'),
                          height: 160,
                          width: 160,
                        ),
                        Container(
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

                              if (viewingAsProfile == true)
                                ElevatedButton(
                                  onPressed: () {
                                    model.showCreateSellerProfileDialog(user);
                                  },
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<OutlinedBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                  ),
                                  child: Constants.openShopLabel.text.white.bold.make(),
                                ),
                            ],
                          ),
                        ),

                        BusyLoader(busy: model.isApiLoading),
                      ],
                    ),
                  ),
                ),
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
