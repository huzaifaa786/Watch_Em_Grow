import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/models/order.dart';
import 'package:mipromo/ui/quick_settings/orders/orderlist_viewmodel.dart';
import 'package:mipromo/ui/shared/helpers/styles.dart';
import 'package:mipromo/ui/shared/widgets/busy_loader.dart';
import 'package:stacked/stacked.dart';
import 'package:mipromo/ui/shared/helpers/enums.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:velocity_x/velocity_x.dart';

class BoughtOrderListView extends StatelessWidget {
  final AppUser currentUser;

  const BoughtOrderListView({Key? key, required this.currentUser}) : super(key: key);

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
                        leading: model.orders[index].service.imageUrl1 == null ||
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
                              child: model.orders[index].status.index == 2
                                  ? 'REFUND CASE OPENED'.text.sm.bold.make()
                                  : model.orders[index].status.name.text.sm.bold.make(),
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

class SoldOrderListView extends StatefulWidget {
  final AppUser currentUser;

  const SoldOrderListView({Key? key, required this.currentUser}) : super(key: key);

  @override
  _SoldOrderListViewState createState() => _SoldOrderListViewState();
}

class _SoldOrderListViewState extends State<SoldOrderListView> {
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String bookingStart(order) {
    String bookstart = '';
    if (order.type == OrderType.service) {
      bookstart = DateFormat('h:mm a').format(
        DateTime.fromMicrosecondsSinceEpoch(int.parse(
          '${order.bookingStart!}',
        )),
      );
    }
    return bookstart;
  }

  String bookingEnd(Order order) {
    String bookend = '';
    if (order.type == OrderType.service) {
      bookend = DateFormat('h:mm a').format(DateTime.fromMicrosecondsSinceEpoch(
        int.parse(
          '${order.bookingEnd!}',
        ),
      ));
    }

    return bookend;
  }

  CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  Widget build(BuildContext context) {
       Brightness brightness = Theme.of(context).brightness;
    bool darkModeOn = brightness == Brightness.dark;
    return ViewModelBuilder<SoldOrderListViewModel>.reactive(
      onModelReady: (model) => model.init(currentUser: widget.currentUser),
      builder: (context, model, child) => model.isBusy
          ? const BusyLoader(busy: true)
          : model.orders.isEmpty
              ? Center(
                  child: 'No order yet!'.text.lg.make(),
                )
              : Column(
                  children: [
                    TableCalendar(
                      focusedDay: selectedDay,
                      firstDay: DateTime(2022),
                      lastDay: DateTime(2050),

                      calendarStyle:  CalendarStyle(
                        markerDecoration :BoxDecoration(color: Styles.kcPrimaryColor,
                        borderRadius: BorderRadius.circular(30),
                        ),
                        isTodayHighlighted: true,
                        outsideDaysVisible: false,
                      ),
                      availableCalendarFormats: const {
                        CalendarFormat.month: 'Month',
                      },
                      calendarFormat: format,
                      onFormatChanged: (CalendarFormat _format) {
                        setState(() {
                          format = _format;
                        });
                      },
                      startingDayOfWeek: StartingDayOfWeek.sunday,
                      daysOfWeekVisible: true,

                      //Day Changed
                      onDaySelected: (DateTime selectDay, DateTime focusDay) {
                        setState(() {
                          selectedDay = selectDay;
                          focusedDay = focusDay;
                        });
                        print(focusedDay);
                      },
                      selectedDayPredicate: (DateTime date) {
                        return isSameDay(selectedDay, date);
                      },

                      eventLoader: model.getEventsfromDay,
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, top: 10, bottom: 10),
                          child: Text(
                            'Appoinments',
                            style: TextStyle(fontSize: 17,color : darkModeOn ? Colors.white:  Colors.black.withOpacity(0.6)),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                          padding: const EdgeInsets.all(12),
                          physics: const BouncingScrollPhysics(),
                          itemCount: model.getEventsfromDay(selectedDay).length,
                          itemBuilder: (context, index) {
                            var orders = model.getEventsfromDay(selectedDay);
                            return Card(
                              child: Column(
                                children: [
                                  ListTile(
                                    onTap: () {
                                      model.navigateToOrderDetailView(orders[index]);
                                    },
                                    leading: orders[index].service.imageUrl1 == null ||
                                            orders[index].service.imageUrl1!.isEmpty
                                        ? const Center(
                                            child: Icon(Icons.broken_image_outlined),
                                          )
                                        : ClipRRect(
                                            borderRadius: BorderRadius.circular(6),
                                            child: CachedNetworkImage(
                                              imageUrl: orders[index].service.imageUrl1!,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                    trailing: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        '£${orders[index].service.price}'.text.make(),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 8),
                                          child: orders[index].status.name.text.sm.bold.make(),
                                        )
                                      ],
                                    ),
                                    title: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        orders[index].service.name.text.gray400.make(),
                                        4.heightBox,
                                      ],
                                    ),
                                  ).pSymmetric(v: 10),
                                  if (orders[index].type == OrderType.service)
                                    Container(
                                      padding: EdgeInsets.only(left: 18, right: 18, bottom: 8),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [Text(bookingStart(orders[index]) + '-' + bookingEnd(orders[index]))],
                                      ),
                                    ),
                                ],
                              ),
                            );
                          }),
                    )
                  ],
                ),

      // ListView.builder(
      //     padding: const EdgeInsets.all(12),
      //     physics: const BouncingScrollPhysics(),
      //     itemCount: model.orders.length,
      //     itemBuilder: (context, index) {
      //       final t = model.orders[index].time;
      //       String? date;
      //       String? bookstart;
      //       String? bookend;
      //       final date1 = DateFormat.yMMMd().format(
      //         DateTime.fromMicrosecondsSinceEpoch(
      //           t,
      //         ),
      //       );

      //       final time = DateFormat('h:mm a').format(
      //         DateTime.fromMicrosecondsSinceEpoch(
      //           t,
      //         ),
      //       );
      //       if (model.orders[index].type == OrderType.service)
      //        date = DateFormat.yMMMd().format(
      //         DateTime.fromMicrosecondsSinceEpoch(
      //           model.orders[index].bookingStart!,
      //         ),
      //       );
      //       if (model.orders[index].type == OrderType.service)
      //        bookstart = DateFormat('h:mm a').format(
      //         DateTime.fromMicrosecondsSinceEpoch(
      //          model.orders[index].bookingStart!,
      //         ),
      //       );
      //       if (model.orders[index].type == OrderType.service)
      //        bookend = DateFormat('h:mm a').format(
      //         DateTime.fromMicrosecondsSinceEpoch(
      //           model.orders[index].bookingEnd!,
      //         ),
      //       );

      //       return Card(
      //         child: Column(
      //           children: [
      //             ListTile(
      //               onTap: () {
      //                 model.navigateToOrderDetailView(model.orders[index]);
      //               },
      //               leading: model.orders[index].service.imageUrl1 ==
      //                           null ||
      //                       model.orders[index].service.imageUrl1!.isEmpty
      //                   ? const Center(
      //                       child: Icon(Icons.broken_image_outlined),
      //                     )
      //                   : ClipRRect(
      //                       borderRadius: BorderRadius.circular(6),
      //                       child: Image.network(
      //                         model.orders[index].service.imageUrl1!,
      //                         fit: BoxFit.cover,
      //                       ),
      //                     ),
      //               trailing: Column(
      //                 mainAxisAlignment: MainAxisAlignment.center,
      //                 crossAxisAlignment: CrossAxisAlignment.end,
      //                 children: [
      //                   '£${model.orders[index].service.price}'.text.make(),
      //                   Padding(
      //                     padding: const EdgeInsets.only(top: 8),
      //                     child: model
      //                         .orders[index].status.name.text.sm.bold
      //                         .make(),
      //                   )
      //                 ],
      //               ),
      //               title: Column(
      //                 mainAxisAlignment: MainAxisAlignment.center,
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   model.orders[index].service.name.text.gray400.make(),
      //                   4.heightBox,

      //                 ],
      //               ),
      //             ).pSymmetric(v: 10),
      //              if (model.orders[index].type == OrderType.service)
      //              Container(
      //               padding: EdgeInsets.only(left:18,right: 18,bottom: 8),
      //                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                 children: [
      //                 '$date'.text.make(),
      //                 '$bookstart-$bookend'.text.make(),
      //                ],),
      //              ),

      //           ],
      //         ),
      //       );
      //     },
      //   ),
      viewModelBuilder: () => SoldOrderListViewModel(),
    );
  }
}

class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}
