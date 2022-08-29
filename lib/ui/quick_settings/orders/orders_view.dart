import 'package:flutter/material.dart';
import 'package:mipromo/app/app.locator.dart';
import 'package:mipromo/ui/quick_settings/orders/orderlist_view.dart';
import 'package:mipromo/ui/shared/widgets/basic_loader.dart';
import 'package:mipromo/ui/shared/widgets/busy_loader.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../shared/helpers/styles.dart';
import 'orders_viewmodel.dart';

class OrdersView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      final _navigationService = locator<NavigationService>();
    return ViewModelBuilder<OrdersViewModel>.reactive(
      onModelReady: (model) => model.init(),
      builder: (context, model, child) => model.isBusy
          ? const BasicLoader()
          :
      model.currentUser.userType == 'seller'
          ? DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: AppBar(
                  // leading: BackButton(
                  //       onPressed: () {
                  //         _navigationService.back(result: true);
                  //       },
                  //     ),
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
