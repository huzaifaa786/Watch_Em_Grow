import 'package:flutter/material.dart';
import 'package:mipromo/ui/static_widget/empy_screen_card.dart';
import 'package:mipromo/user_interface/order/order_index.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            EmptyScreenCard(
                title: 'Order Placed Successfully',
                subtitle: 'congratulation your order is placed successfully',
                buttonTitle: 'View Order Status',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const OrderInboxView()),
                  );
                },
                onTap: () {}),
          ],
        ),
      )),
    );
  }
}
