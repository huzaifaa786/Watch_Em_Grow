import 'package:flutter/material.dart';
import 'package:mipromo/ui/chats/chats_viewmodel.dart';
import 'package:mipromo/user_interface/order/current_screen.dart';
import 'package:mipromo/user_interface/order/history_screen.dart';
import 'package:stacked/stacked.dart';


class OrderInboxView extends StatefulWidget {
  const OrderInboxView({
    Key? key,
    // required this.currentUser,
  }) : super(key: key);

  // final AppUser currentUser;

  @override
  _OrderInboxViewState createState() => _OrderInboxViewState();
}

class _OrderInboxViewState extends State<OrderInboxView> {
  List<bool> _isSelected = [true,false,];

  @override
  Widget build(BuildContext context) {
    return 
        ViewModelBuilder<ChatsViewModel>.reactive(
      onModelReady: (model) => model.init,
      builder: (context, model, child) => DefaultTabController(
        length: 2,
           child: Scaffold(
            appBar: AppBar(
              title: const Text('Order'),
              // centerTitle: true,
              bottom: TabBar(
                labelColor: Colors.grey.shade200,
                unselectedLabelColor: Colors.grey.shade200,
                tabs:  [
                  Tab(
                    child: Text('Current'),
                  ),
                  Tab(
                       child:_isSelected[0] ? 
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('History'),
                            // Padding(
                            //   padding: const EdgeInsets.only(bottom:8.0,left: 8),
                            //   child: Text('•',style: TextStyle(color: Colors.red[700],fontSize: 36),),
                            // ),
                          ],
                        )
                        : Text("History"),
                  )
                ],
              ),
            ),
                 
            body: TabBarView(
              physics: const BouncingScrollPhysics(),
              children: [
               CurrentOrderScreen(),
               OrderHistoryScreen()
              ],
            ),
                 ),
         ), viewModelBuilder: ()=> ChatsViewModel(),
      );
      // viewModelBuilder: () => ChatsViewModel();
  
  }
}
