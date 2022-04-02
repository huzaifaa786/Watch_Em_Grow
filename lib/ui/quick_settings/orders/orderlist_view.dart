import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/ui/quick_settings/orders/orderlist_viewmodel.dart';
import 'package:mipromo/ui/shared/widgets/busy_loader.dart';
import 'package:stacked/stacked.dart';
import 'package:mipromo/ui/shared/helpers/enums.dart';
import 'package:velocity_x/velocity_x.dart';

class BoughtOrderListView extends StatelessWidget {
  final AppUser currentUser;

  const BoughtOrderListView({Key? key, required this.currentUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BoughtOrderListViewModel>.reactive(
      onModelReady: (model) => model.init(currentUser: currentUser),
      builder: (context, model, child) => model.isBusy
          ? const BusyLoader(busy: true)
          : model.orders.isEmpty
              ? Center(
                  child: 'No order yet!'.text.lg.make(),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  physics: const BouncingScrollPhysics(),
                  itemCount: model.orders.length,
                  itemBuilder: (context, index) {
                    final t = model.orders[index].time;

                    final date = DateFormat.yMMMd().format(
                      DateTime.fromMicrosecondsSinceEpoch(
                        t,
                      ),
                    );

                    final time = DateFormat('h:mm a').format(
                      DateTime.fromMicrosecondsSinceEpoch(
                        t,
                      ),
                    );

                    return Card(
                      child: ListTile(
                        onTap: () {
                          model.navigateToOrderDetailView(model.orders[index]);
                        },
                        leading: model.orders[index].service.imageUrl1 ==
                                    null ||
                                model.orders[index].service.imageUrl1!.isEmpty
                            ? const Center(
                                child: Icon(Icons.broken_image_outlined),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.network(
                                  model.orders[index].service.imageUrl1!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            '£${model.orders[index].service.price.toStringAsFixed(2)}'.text.make(),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: model.orders[index].status.index == 2 ?
                              'REFUND CASE OPENED'.text.sm.bold.make() :
                              model.orders[index].status.name.text.sm.bold.make(),
                            )
                          ],
                        ),
                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            model.orders[index].service.name.text.make(),
                            4.heightBox,
                            '$date-$time'.text.xs.gray400.make(),
                          ],
                        ),
                      ).pSymmetric(v: 10),
                    );
                  },
                ),
      viewModelBuilder: () => BoughtOrderListViewModel(),
    );
  }
}

class SoldOrderListView extends StatelessWidget {
  final AppUser currentUser;

  const SoldOrderListView({Key? key, required this.currentUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SoldOrderListViewModel>.reactive(
      onModelReady: (model) => model.init(currentUser: currentUser),
      builder: (context, model, child) => model.isBusy
          ? const BusyLoader(busy: true)
          : model.orders.isEmpty
              ? Center(
                  child: 'No order yet!'.text.lg.make(),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  physics: const BouncingScrollPhysics(),
                  itemCount: model.orders.length,
                  itemBuilder: (context, index) {
                    final t = model.orders[index].time;

                    final date = DateFormat.yMMMd().format(
                      DateTime.fromMicrosecondsSinceEpoch(
                        t,
                      ),
                    );

                    final time = DateFormat('h:mm a').format(
                      DateTime.fromMicrosecondsSinceEpoch(
                        t,
                      ),
                    );

                    return Card(
                      child: ListTile(
                        onTap: () {
                          model.navigateToOrderDetailView(model.orders[index]);
                        },
                        leading: model.orders[index].service.imageUrl1 ==
                                    null ||
                                model.orders[index].service.imageUrl1!.isEmpty
                            ? const Center(
                                child: Icon(Icons.broken_image_outlined),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.network(
                                  model.orders[index].service.imageUrl1!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            '£${model.orders[index].service.price}'.text.make(),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: model
                                  .orders[index].status.name.text.sm.bold
                                  .make(),
                            )
                          ],
                        ),
                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            model.orders[index].service.name.text.make(),
                            4.heightBox,
                            '$date-$time'.text.xs.gray400.make(),
                          ],
                        ),
                      ).pSymmetric(v: 10),
                    );
                  },
                ),
      viewModelBuilder: () => SoldOrderListViewModel(),
    );
  }
}
