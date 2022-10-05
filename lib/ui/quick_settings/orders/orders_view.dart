import 'package:flutter/material.dart';
import 'package:mipromo/ui/quick_settings/orders/orderlist_view.dart';
import 'package:mipromo/ui/shared/widgets/basic_loader.dart';
import 'package:mipromo/ui/shared/widgets/busy_loader.dart';
import 'package:stacked/stacked.dart';

import '../../shared/helpers/styles.dart';
import 'orders_viewmodel.dart';

class OrdersView extends StatelessWidget {
    int  index;

   OrdersView({Key? key, this.index=0}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OrdersViewModel>.reactive(
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => model.isBusy
          ? const BasicLoader()
          :
      model.currentUser.userType == 'seller'
          ? DefaultTabController(
            initialIndex: index,
              length: 2,
              child: Scaffold(
                appBar: AppBar(
                  title: const Text('Orders'),
                  bottom: TabBar(
                    labelColor: Theme.of(context).brightness == Brightness.light
                        ? null
                        : Styles.kcPrimaryColor,
                    unselectedLabelColor: Colors.grey.shade200,
                    tabs: const [
                      Tab(
                        child: Text('Bought'),
                      ),
                      Tab(
                        child: Text('Sold'),
                      )
                    ],
                  ),
                ),
                body: TabBarView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    BoughtOrderListView(
                      currentUser: model.currentUser,
                    ),
                    SoldOrderListView(
                      currentUser: model.currentUser,
                    ),
                  ],
                ),
              ),
            )
          : Scaffold(
              appBar: AppBar(
                title: const Text('Orders'),
              ),
              body: BoughtOrderListView(
                currentUser: model.currentUser,
              ),
            ),
      viewModelBuilder: () => OrdersViewModel(),
    );
  }
}
