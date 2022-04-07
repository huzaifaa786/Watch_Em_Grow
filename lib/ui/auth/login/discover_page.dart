import 'package:flutter/material.dart';
import 'package:mipromo/api/auth_api.dart';
import 'package:mipromo/api/database_api.dart';
import 'package:mipromo/app/app.locator.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/ui/main/main_view.dart';
import 'package:mipromo/ui/main/main_viewmodel.dart';
import 'package:mipromo/ui/profile/buyer/buyer_profile_view.dart';
import 'package:mipromo/ui/shared/helpers/styles.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:mipromo/app/app.router.dart';
import 'package:get/get.dart';

class DiscoverPage extends StatefulWidget {
  DiscoverPage({Key? key}) : super(key: key);

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  final _navigationService = locator<NavigationService>();
  Future<void> _navigateToMainView() async {
  await _navigationService.navigateTo(
      Routes.mainView,
      arguments: MainViewArguments(
        selectedIndex: 0,
      ),
    );
  }

  Future _navigateToShopView() async {
     await _navigationService.navigateTo(
      Routes.mainView,
      arguments: MainViewArguments(
        selectedIndex: 3,
      ),
    );
  }

  Future navigatedo({
    required AppUser muser,
  }) async {
    await _navigationService.navigateTo(
      Routes.buyerProfileView,
      arguments: BuyerProfileViewArguments(
        user: muser,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          Container(
            color: Colors.black,
            child: Column(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                Center(
                  // ignore: avoid_unnecessary_containers
                  child: Container(
                    // ignore: prefer_const_constructors
                    margin: EdgeInsets.only(top: 50, bottom: 10),
                    // ignore: prefer_const_constructors
                    child: Column(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        // ignore: prefer_const_constructors
                        Image(
                          image: AssetImage('assets/icon/icon_new.png'),
                          height: 45,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Find services & shops",
                          style: TextStyle(fontSize: 26, color: Colors.white),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.55,
                          child: Text(
                            "Discover services and shops near you or showcast your own business",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
// ignore: prefer_const_constructors
                Container(
                  height: MediaQuery.of(context).size.height*0.35,
                  margin: EdgeInsets.only(top: 140),
                  child: Image(
                    image: AssetImage(
                      'assets/icon/bag.png',
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 20),
              width: MediaQuery.of(context).size.width * 0.95,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () async {
                      await _navigateToMainView();
                    },
                    child: Container(
                      height: 45,
                      padding: EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width * 0.47,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Color(4285464760)),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 12.0),
                              child: ImageIcon(
                                AssetImage('assets/icon/search.png'),
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Browse',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await _navigateToShopView();
                    },
                    child: Container(
                      height: 45,
                      padding: EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width * 0.47,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Color(4285464760)),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Promote your own',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontSize: 12),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 9.0),
                              child: Icon(
                                Icons.arrow_circle_up,
                                color: Colors.white,
                                size: 26,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      )),
    );
  }
}
