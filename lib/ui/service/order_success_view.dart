import 'package:flutter/material.dart';
import 'package:mipromo/ui/shared/widgets/busy_loader.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'order_success_viewmodel.dart';
import 'package:lottie/lottie.dart';

class OrderSuccessView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OrderSuccessViewModel>.reactive(
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => Scaffold(
        body: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: InkWell(
                  onTap: () {
                    model.onClose();
                  },
                  child: Container(
                      height: 50,
                      width: 50,
                      //color: Colors.redAccent,
                      child: Icon(Icons.clear, size: 20)),
                ),
              ),
            ),
            Column(
              //mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 120,
                  //width: 180,
                  //color: Colors.red,
                  child: Lottie.asset(
                    'assets/images/order_success.json',
                    fit: BoxFit.fill,
                    repeat: true,
                  ),
                ),
                5.heightBox,
                "Order Placed Successfully"
                    .text
                    .bold
                    .xl
                    .center
                    // .color(Colors.black)
                    .make(),
                3.heightBox,
                "Congratulations, your order has been placed successfully"
                    .text
                    .center
                    .color(Colors.grey)
                    .make()
                    .px(40),
                10.heightBox,
                "We’ll keep your funds safe until you’ve confirmed that you have received the service"
                    .text
                    .center
                    .color(Colors.grey)
                    .make()
                    .px(40),
                10.heightBox,
                InkWell(
                  onTap: () {
                    model.navigateToOrder();
                  },
                  child: Container(
                    height: 40,
                    width: 180,
                    decoration: BoxDecoration(
                        color: Color(4291861070),
                        borderRadius: BorderRadius.circular(55)),
                    child: Center(
                      child: const Text(
                        'View Order Status',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                /*Container(
                    height: 30,
                    child: Image.asset('assets/icon/shield.png')),*/
              ],
            ),
          ],
        ),
      ),
      viewModelBuilder: () => OrderSuccessViewModel(),
    );
  }
}
