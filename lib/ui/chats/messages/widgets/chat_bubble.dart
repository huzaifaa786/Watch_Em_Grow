import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:mipromo/ui/shared/helpers/styles.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    Key? key,
    required this.isSent,
    required this.message,
  }) : super(key: key);

  final bool isSent;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Bubble(
      margin: isSent
          ? const BubbleEdges.only(top: 10, right: 20)
          : const BubbleEdges.only(top: 10, left: 20),
      padding: const BubbleEdges.all(15),
      elevation: 5,
      nipRadius: 1,
      nipWidth: 10,
      nipHeight: 10,
      alignment: isSent ? Alignment.topRight : Alignment.topLeft,
      nip: isSent ? BubbleNip.rightTop : BubbleNip.leftTop,
      color: isSent ? Styles.kcPrimaryColor : Colors.grey[200],
      child: Text(
        message,
        style: TextStyle(
          color: isSent ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
