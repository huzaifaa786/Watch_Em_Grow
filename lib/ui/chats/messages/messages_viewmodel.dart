import 'package:mipromo/api/database_api.dart';
import 'package:mipromo/app/app.locator.dart';
import 'package:mipromo/app/app.router.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/models/chat.dart';
import 'package:mipromo/services/user_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class MessagesViewModel extends BaseViewModel {
  final _databaseApi = locator<DatabaseApi>();
  final _userService = locator<UserService>();
  final _navigationService = locator<NavigationService>();

  List<Chat> chats = [];

  Future sendMessage(
    String message,
    AppUser receiver,
    AppUser sender,
  ) async {
    final chat = Chat(
      senderId: sender.id,
      receiverId: receiver.id,
      senderName: sender.username,
      recieverName: receiver.username,
      message: message,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );

    await _databaseApi.createMessage(chat);
    await _databaseApi.updateChatIds(userId: sender.id, receiverId:  receiver.id);
    var token = await _databaseApi.getToken(receiver.id);
    if(token != null){
      print("Sending notification: " + receiver.username);
      var test = _databaseApi.postNotification(
          orderID: '',
          title: 'New Message',
          body: 'You have received a new message from ${sender.username}',
          forRole: 'message',
          userID: sender.id,
          receiverToken: token.toString());
    }
  }

  void listenMessages(
    String senderId,
    String receiverId,
  ) {
    setBusy(true);

    _databaseApi.listenChats(senderId, receiverId).listen(
      (chatsData) {
        chats = chatsData;
        notifyListeners();
      },
    );

    _databaseApi.readChats(
      currentUserId: _userService.currentUser.id,
    );

    setBusy(false);
  }

  Future<void> toSellerProfile(AppUser receiver) async {
    await _navigationService.navigateTo(
      Routes.sellerProfileView,
      arguments: SellerProfileViewArguments(
        seller: receiver,
      ),
    );
  }

  Future<void> toBuyerProfile(AppUser receiver) async {
    await _navigationService.navigateTo(
      Routes.buyerProfileView,
      arguments: BuyerProfileViewArguments(
          user: receiver
      ),
    );
  }
}
