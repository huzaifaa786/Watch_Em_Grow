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
  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainViewModel>.reactive(
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => viewSelector(model),
      viewModelBuilder: () => MainViewModel(),
    );
  }

  /// Selects a View according to User Data
  Widget viewSelector(MainViewModel model) {
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
    final pageController = usePageController();
    model.pageController = pageController;
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
              model.onNavigationIconTap(index);
              pageController.jumpToPage(index);
            },
          ),
        ],
      ),
    );
  }
}
