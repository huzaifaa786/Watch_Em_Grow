import 'package:flutter/material.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/ui/chats/chats_view.dart';
import 'package:mipromo/ui/inbox/inbox_viewmodel.dart';
import 'package:mipromo/ui/notifications/notifications_view.dart';
import 'package:stacked/stacked.dart';

import '../shared/helpers/styles.dart';

class InboxView extends StatelessWidget {
  const InboxView({
    Key? key,
    required this.currentUser,
  }) : super(key: key);

  final AppUser currentUser;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<InboxViewModel>.reactive(
      builder: (context, model, child) => DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Inbox'),
            centerTitle: true,
            bottom: TabBar(
              labelColor: Theme.of(context).brightness == Brightness.light
                  ? null
                  : Styles.kcPrimaryColor,
              unselectedLabelColor: Colors.grey.shade200,
              tabs: const [
                Tab(
                  child: Text('Notifications'),
                ),
                Tab(
                  child: Text('Chats'),
                )
              ],
            ),
          ),
          body: TabBarView(
            physics: const BouncingScrollPhysics(),
            children: [
              NotificationsView(currentUser: currentUser),
              ChatsView(
                currentUser: currentUser,
                onMainView: true,
              ),
            ],
          ),
        ),
      ),
      viewModelBuilder: () => InboxViewModel(),
    );
  }
}
