import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:mipromo/api/database_api.dart';
import 'package:mipromo/app/app.locator.dart';
import 'package:mipromo/app/app.router.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/models/chat.dart';
import 'package:mipromo/services/user_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ChatsViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _userService = locator<UserService>();
  final _databaseApi = locator<DatabaseApi>();
  var chatNotifications = 0 ;

  StreamSubscription<List<AppUser>>? _chatUsersSubscription;

  List<AppUser> users = [];
  List<Chat> chats = [];

  void init(AppUser user) {
    setBusy(true);

    //if (user.chatIds != null) {
    _databaseApi.sortChatUsersID(user).listen((usersData) {
      users = usersData;
      notifyListeners();
      setBusy(false);
    });

    /*_chatUsersSubscription =
          _databaseApi.listenChatUsers(user.chatIds!).listen(
        (usersData) {
          users = usersData;
          notifyListeners();
          setBusy(false);
        },
      );*/

    _databaseApi.listenCurrentUserChats(_userService.currentUser.id).listen(
      (chts) {
        chats = chts;
        chatNotifications = chats.where((chat) => chat.read == false).length;
        notifyListeners();
      },
      
    );

    /*} else {
      setBusy(false);
    }*/
  }

  Future<void> navigateToMessagesView(
    AppUser currentUser,
    AppUser receiver,
  ) async {
    await _navigationService.navigateTo(
      Routes.messagesView,
      arguments: MessagesViewArguments(
        currentUser: currentUser,
        receiver: receiver,
      ),
    );
  }

  @override
  void dispose() {
    _chatUsersSubscription!.cancel();
    super.dispose();
  }
}
