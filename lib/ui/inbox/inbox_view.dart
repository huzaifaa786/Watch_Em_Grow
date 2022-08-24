import 'package:flutter/material.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/ui/chats/chats_view.dart';
import 'package:mipromo/ui/chats/chats_viewmodel.dart';
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
    return ViewModelBuilder<ChatsViewModel>.reactive(
      onModelReady: (model) => model.init(currentUser),
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
              tabs:  [
                Tab(
                  child: Text('Notifications'),
                ),
                Tab(
                     child: model.chatNotifications > 0 ? 
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Chats'),
                          Padding(
                            padding: const EdgeInsets.only(bottom:8.0,left: 8),
                            child: Text('•',style: TextStyle(color: Colors.red[700],fontSize: 36),),
                          ),
                        ],
                      )
                      : Text("Chats"),
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
      viewModelBuilder: () => ChatsViewModel(),
    );
  }
}
