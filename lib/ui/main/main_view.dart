import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mipromo/ui/home/home_view.dart';
import 'package:mipromo/ui/inbox/inbox_view.dart';
import 'package:mipromo/ui/main/create_username/create_username_view.dart';
import 'package:mipromo/ui/main/main_viewmodel.dart';
import 'package:mipromo/ui/profile/profile_view.dart';
import 'package:mipromo/ui/search/search_view.dart';
import 'package:mipromo/ui/shared/helpers/styles.dart';
import 'package:mipromo/ui/shared/widgets/basic_loader.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:badges/badges.dart';

class MainView extends StatelessWidget {
  const MainView({Key? key, this.selectedIndex = 0}) : super(key: key);
  final int selectedIndex;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(
      onModelReady: (model) => model.init(selectedIndex),
      builder: (context, model, child) => viewSelector(model, selectedIndex),
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
      } else {
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
        pageController.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);
          
      }

    // if (model.currentIndex == 3) {
    //   changePage(2);
    // }

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
          InboxView(currentUser: model.currentUser),
          ProfileView(
            user: model.currentUser,
          ),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(),
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
                label: 'Discover',
              ),
              const BottomNavigationBarItem(
                icon: Icon(
                  Icons.search,
                ),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: model.badgeCnt == 0
                    ? Icon(model.currentIndex == 2 ? Icons.mail : Icons.mail_outlined)
                    : Badge(
                        badgeContent: Text('${model.badgeCnt}'),
                        child: Icon(
                          model.currentIndex == 2 ? Icons.mail : Icons.mail_outlined,
                        ),
                      ),
                label: 'Inbox',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  model.currentIndex == 3 ? Icons.person : Icons.person_outline,
                ),
                label: 'Profile',
              ),
            ],
            onTap: (index) {
              changePage(index);
            },
          ),
        ],
      ),
    );
  }
}
