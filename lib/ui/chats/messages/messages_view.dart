import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/ui/chats/messages/messages_viewmodel.dart';
import 'package:mipromo/ui/chats/messages/widgets/chat_bubble.dart';
import 'package:mipromo/ui/shared/helpers/styles.dart';
import 'package:mipromo/ui/shared/widgets/basic_loader.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';

class MessagesView extends StatelessWidget {
  const MessagesView({
    Key? key,
    required this.currentUser,
    required this.receiver,
  }) : super(key: key);

  final AppUser currentUser;
  final AppUser receiver;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MessagesViewModel>.reactive(
      onModelReady: (model) => model.listenMessages(
        currentUser.id,
        receiver.id,
      ),
      builder: (context, model, child) => model.isBusy
          ? const BasicLoader()
          : SafeArea(
            child: Scaffold(
                appBar: AppBar(
                  title: InkWell(
                    onTap: (){
                      print("Asads");
                      if(receiver.shopId.isNotEmpty){
                        model.toSellerProfile(receiver);
                      }else{
                        model.toBuyerProfile(receiver);
                      }
                    },
                      child: Container(
                          child: Row(
                            children: [
                              Text(receiver.username),
                            ],
                          ))),
                ),
                body: _MessagesBody(
                  currentUser: currentUser,
                  receiver: receiver,
                ),
              ),
          ),
      viewModelBuilder: () => MessagesViewModel(),
    );
  }
}

class _MessagesBody extends HookViewModelWidget<MessagesViewModel> {
  const _MessagesBody({
    Key? key,
    required this.currentUser,
    required this.receiver,
  }) : super(key: key);

  final AppUser currentUser;
  final AppUser receiver;

  @override
  Widget buildViewModelWidget(
    BuildContext context,
    MessagesViewModel model,
  ) {
    final messageController = useTextEditingController();
    final messageFocusNode = useFocusNode();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: ListView.builder(
            reverse: true,
            itemCount: model.chats.length,
            itemBuilder: (context, index) {
              final bool isSent = model.chats[index].senderId != receiver.id;
              return ChatBubble(
                isSent: isSent,
                message: model.chats[index].message,
              );
            },
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Divider(
                thickness: 1,
                height: 0,
              ),
              Container(
                margin: EdgeInsets.only(bottom: 14),
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        focusNode: messageFocusNode,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Type a message',
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: Styles.kcPrimaryColor,
                      ),
                      onPressed: () {
                        model.sendMessage(
                          messageController.text,
                          receiver,
                          currentUser,
                        );
                        messageController.clear();
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
