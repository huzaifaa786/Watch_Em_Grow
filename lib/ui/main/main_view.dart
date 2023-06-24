import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mipromo/ui/auth/buyer_signup/profile_update.dart';
import 'package:mipromo/ui/auth/login/discover_page.dart';
import 'package:mipromo/ui/home/home_view.dart';
import 'package:mipromo/ui/inbox/inbox_view.dart';
import 'package:mipromo/ui/main/create_username/create_username_view.dart';
import 'package:mipromo/ui/main/main_viewmodel.dart';
import 'package:mipromo/ui/profile/profile_view.dart';
import 'package:mipromo/ui/search/search_view.dart';
import 'package:mipromo/ui/shared/helpers/styles.dart';
import 'package:mipromo/ui/shared/widgets/basic_loader.dart';
import 'package:mipromo/ui/shop/create_shop_view.dart';
import 'package:mipromo/user_interface/product/top_product.dart';
import 'package:mipromo/user_interface/store/store_product.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:badges/badges.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class MainView extends StatefulWidget {
  const MainView({Key? key, this.selectedIndex = 0}) : super(key: key);
  final int selectedIndex;

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(
      onModelReady: (model) => model.init(widget.selectedIndex,context),
      builder: (context, model, child) =>
          viewSelector(model, widget.selectedIndex),
      viewModelBuilder: () => MainViewModel(),
    );
  }

  /// Selects a View according to User Data
  Widget viewSelector(MainViewModel model, int index) {
    if (model.isBusy) {
      return const BasicLoader();
    } else {
      
      if (model.currentUser.username.isEmpty) {
        return const CreateUsernameView();
      // } else if (model.currentUser.imageUrl.isEmpty &&
      //     model.currentUser.skip == 0) {
      //   return ProfileUpdate(user: model.currentUser);
      // } 
      }else {
        return _MainView();
      }
    }
  }
}

class _MainView extends HookViewModelWidget<MainViewModel> {
  @override
  Widget buildViewModelWidget(
    BuildContext context,
    MainViewModel model,
  ) {
    final mkey = GlobalKey<State<BottomNavigationBar>>();
    final pageController = usePageController();
    model.pageController = pageController;

    changePage(int index) {
      model.onNavigationIconTap(index);
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        pageController.animateToPage(index,
            duration: Duration(milliseconds: 500), curve: Curves.ease);
      });
    }

    return Scaffold(
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          model.onNavigationIconTap(index);
        },
        children: [
          const HomeView(),
          const SearchView(),
          const StoreProductScreen(),
          InboxView(currentUser: model.currentUser),
          ProfileView(
            user: model.currentUser,
          ),
          // CreateShopView( user: model.currentUser,)
          // TopProductScreen()
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(),
          Stack(
            children: [
             BottomNavigationBar(
              key: mkey,
              type: BottomNavigationBarType.fixed,
              currentIndex: model.currentIndex,
              selectedItemColor: Styles.kcPrimaryColor,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(
                    model.currentIndex == 0 ? Icons.home : Icons.home_outlined,
                  ),
                  label: '',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(
                    Icons.search,
                  ),
                  label: '',
                ),
                const BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(right:8.0),
                    child: Icon(
                      FontAwesomeIcons.shirt,
                      size: 50,
                    ),
                  ),
                  label: 'SELL',
                ),
                BottomNavigationBarItem(
                  icon: model.badgeCnt == 0
                      ? Icon(model.currentIndex == 2
                          ? Icons.mail
                          : Icons.mail_outlined)
                      : Badge(
                          badgeContent: Text('${model.badgeCnt}'),
                          child: Icon(
                            model.currentIndex == 2
                                ? Icons.mail
                                : Icons.mail_outlined,
                          ),
                        ),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    model.currentIndex == 3 ? Icons.person : Icons.person_outline,
                  ),
                  label: '',
                ),
              ],
              onTap: (index) {
                changePage(index);
              },
            ),
         ], ),
        ],
      ),
    );
  }
}
