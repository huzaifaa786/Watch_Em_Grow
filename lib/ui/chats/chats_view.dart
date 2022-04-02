import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/ui/chats/chats_viewmodel.dart';
import 'package:mipromo/ui/shared/widgets/avatar.dart';
import 'package:mipromo/ui/shared/widgets/basic_loader.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class ChatsView extends StatelessWidget {
  const ChatsView({
    Key? key,
    required this.currentUser,
    required this.onMainView,
  }) : super(key: key);

  final AppUser currentUser;
  final bool onMainView;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ChatsViewModel>.reactive(
      onModelReady: (model) => model.init(currentUser),
      builder: (context, model, child) => model.isBusy
          ? const BasicLoader()
          : model.users.isEmpty
              ? const Material(
                  child: Center(
                    child: Text(
                      "You haven't had any chats yet...",
                    ),
                  ),
                )
              : Scaffold(
                  appBar: onMainView
                      ? null
                      : AppBar(
                          title: const Text('Chats'),
                        ),
                  body: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: model.users.length,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    itemBuilder: (context, index) {
                      final badgeCount = model.chats
                          .where(
                            (chat) =>
                                chat.senderId == model.users[index].id &&
                                chat.read == false,
                          )
                          .length;

                      return Column(
                        children: [
                          ListTile(
                            horizontalTitleGap: 40,
                            leading: badgeCount <= 0
                                ? Avatar(
                                    radius: 25,
                                    imageUrl: model.users[index].imageUrl,
                                  )
                                : Badge(
                                    badgeContent: badgeCount.text.make(),
                                    child: Avatar(
                                      radius: 25,
                                      imageUrl: model.users[index].imageUrl,
                                    ),
                                  ),
                            title: Text(
                              model.users[index].username,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onTap: () {
                              model.navigateToMessagesView(
                                currentUser,
                                model.users[index],
                              );
                            },
                          ),
                          const Divider(),
                        ],
                      );
                    },
                  ),
                ),
      viewModelBuilder: () => ChatsViewModel(),
    );
  }
}
