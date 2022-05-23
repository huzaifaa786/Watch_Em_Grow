import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:intl/intl.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/models/order.dart';
import 'package:mipromo/ui/quick_settings/orders/orderdetail_viewmodel.dart';
//import 'package:mipromo/ui/shared/helpers/Constants.dart';
import 'package:mipromo/ui/shared/helpers/constants.dart';
import 'package:mipromo/ui/shared/helpers/enums.dart';
import 'package:mipromo/ui/shared/widgets/basic_loader.dart';
import 'package:mipromo/ui/shared/widgets/busy_loader.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class OrderDetailView extends StatelessWidget {
  final Order order;
  final int color;
  final String fontStyle;
  final AppUser currentUser;

  const OrderDetailView({
    Key? key,
    required this.order,
    required this.color,
    required this.fontStyle,
    required this.currentUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ViewModelBuilder<OrderDetailViewModel>.reactive(
      onModelReady: (model) => model.init(order.service, order),
      builder: (context, model, child) => model.isBusy
          ? const BasicLoader()
          : Scaffold(
              appBar: AppBar(
                title: order.service.name.text.make(),
              ),
              body: Stack(
                children: [
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ///Shop card
                          InkWell(
                            onTap: () {
                              order.userId == currentUser.id
                                  ? model.navigateToShopView(model.shopOwner)
                                  : model.navigateToBuyerView(
                                      owner: model.buyer);
                            },
                            child: Row(
                              children: [
                                Container(
                                  width: size.width * 0.18,
                                  padding: const EdgeInsets.all(8),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                          order.userId == currentUser.id
                                              ? model.shopOwner.imageUrl
                                              : model.buyer.imageUrl)),
                                ),
                                5.widthBox,
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    order.userId == currentUser.id
                                        ? model.shopDetails.name.text
                                            .minFontSize(15)
                                            .make()
                                        : model.buyer.username.text
                                            .minFontSize(15)
                                            .make(),
                                  ],
                                ),
                                Spacer(),
                                Icon(Icons.arrow_forward_ios_outlined, size: 15)
                                    .px(8)
                              ],
                            ).h(size.height * 0.09),
                          ),
                          Divider(color: Colors.grey),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  DateFormat.yMMMMd('en_US')
                                      .format(
                                        DateTime.fromMicrosecondsSinceEpoch(
                                            order.time),
                                      )
                                      .text
                                      .size(13)
                                      .make(),
                                  (size.height * 0.004).heightBox,
                                  Row(
                                    children: [
                                      'Order ID:'
                                          .text
                                          .size(13)
                                          .fontWeight(FontWeight.w600)
                                          .make(),
                                      2.widthBox,
                                      '#${order.orderId}'
                                          .text
                                          .size(13)
                                          .fontWeight(FontWeight.w600)
                                          .make(),
                                    ],
                                  ),
                                ],
                              ).pOnly(left: size.width * 0.02),
                              //Spacer(),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  'Amount'
                                      .text
                                      .size(13)
                                      .fontWeight(FontWeight.w600)
                                      .make(),
                                  (size.height * 0.004).heightBox,
                                  "£${order.service.price.toStringAsFixed(2)}"
                                      .text
                                      .size(13)
                                      .make(),
                                ],
                              ).pOnly(right: size.width * 0.02),
                            ],
                          ).h(size.height * 0.09),

                          Divider(color: Colors.grey),

                          ///order details card
                          /*Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  'Order details'.text.minFontSize(18).make(),
                                  SizedBox(
                                    width: context.screenWidth,
                                    height: context.screenHeight / 3,
                                    child: PageView(
                                      children: [
                                        if (order.service.imageUrl1 !=
                                            null) ...[
                                          Image.network(
                                            order.service.imageUrl1!,
                                          ),
                                        ],
                                        if (order.service.imageUrl2 !=
                                            null) ...[
                                          Image.network(
                                            order.service.imageUrl2!,
                                          ),
                                        ],
                                        if (order.service.imageUrl3 !=
                                            null) ...[
                                          Image.network(
                                            order.service.imageUrl3!,
                                          ),
                                        ]
                                      ],
                                    ),
                                  ),
                                  16.heightBox,
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        'order date:'.text.lg.make(),
                                        DateFormat.yMMMMd('en_US')
                                            .format(
                                              DateTime
                                                  .fromMicrosecondsSinceEpoch(
                                                order.time,
                                              ),
                                            )
                                            .text
                                            .make()
                                      ]),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      order.service.name.text.black.xl.bold
                                          .fontFamily(fontStyle)
                                          .maxLines(2)
                                          .color(
                                            Color(color),
                                          )
                                          .make()
                                          .box
                                          .width(context.screenWidth / 1.5)
                                          .make(),
                                      "£${order.service.price}".text.lg.make(),
                                    ],
                                  ).pOnly(
                                    top: 12,
                                  ),
                                  if(order.shopId == currentUser.shopId)
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      if(order.status == OrderStatus.completed)
                                      'Processing fee: '.text.xs
                                          .make()
                                          .box
                                          .width(context.screenWidth / 1.5)
                                          .make(),
                                      if(order.status == OrderStatus.completed)
                                        "£${(order.service.price * 0.20)}".text.xs.make()
                                    ],
                                  ).pOnly(
                                    top: 5,
                                  ),
                                  order.service.description!.text
                                      .color(Colors.grey)
                                      .make()
                                      .py8(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      "${Constants.typeLabel} : ${order.service.type}"
                                          .text
                                          .make(),
                                      if (order.service.type == "Product")
                                        if (order.selectedSize == null ||
                                            order.service.sizes == null ||
                                            order.service.sizes!.isEmpty)
                                          const SizedBox.shrink()
                                        else
                                          order.service
                                              .sizes![order.selectedSize!].text
                                              .make()
                                      else
                                        const SizedBox.shrink(),
                                    ],
                                  ).pOnly(
                                    bottom: 10
                                  ),

                                  if (order.status == OrderStatus.completed &&
                                      order.userId == currentUser.id)
                                    Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          if (order.rate != 0 && order.rate != null)
                                            'Your rating: '.text.make()
                                          else
                                            'Rate this order'.text.make(),

                                          if (order.rate != 0 && order.rate != null)
                                            RatingStars(
                                              value: double.parse(order.rate.toString()),
                                              starSize: 16,
                                              valueLabelVisibility: false,
                                            )
                                          else
                                            RatingStars(
                                              value: model.rating,
                                              starSize: 16,
                                              onValueChanged: (value) {
                                                //model.setRating(value, order);
                                              },
                                              valueLabelVisibility: false,
                                            )
                                        ]),
                                ],
                              ),
                            ),
                          ),*/

                          ///order Status
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  model.order.status.name.text.capitalize
                                      .fontWeight(FontWeight.w600)
                                      .size(15)
                                      .make(),
                                  (size.height * 0.004).heightBox,
                                  DateFormat.yMMMMd('en_US')
                                      .format(
                                        DateTime.fromMicrosecondsSinceEpoch(
                                            order.time),
                                      )
                                      .text
                                      .size(13)
                                      .make(),
                                ],
                              ).pOnly(left: size.width * 0.02),
                              //Spacer(),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      height: size.height * 0.03,
                                      child: Image.asset(
                                          'assets/icon/ic_statusGreen.png',
                                          scale: 2))
                                ],
                              ).pOnly(right: size.width * 0.03),
                            ],
                          ).h(size.height * 0.09),

                          Divider(color: Colors.grey),

                          ///status roadMap
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    renderStatusIcons(
                                        model.order.status.name, size.height),
                                  ],
                                ),
                              ),
                            ],
                          ).py(size.height * 0.02),

                          Divider(color: Colors.grey),
                          // 5.heightBox,

                          /*if (order.status == OrderStatus.progress &&
                              order.userId == currentUser.id)
                            'Buyer Details'
                                .text
                                .minFontSize(18)
                                .make()
                                .pOnly(left: 12),*/
                          /*if (order.status == OrderStatus.completed &&
                              order.userId == currentUser.id)*/

                          //5.heightBox,
                          // if (order.type == OrderType.product)
                          //   'Delivery address'.text.minFontSize(18).make(),
                          // if (order.type == OrderType.product)
                          //   Card(
                          //     child: Padding(
                          //       padding: const EdgeInsets.all(16.0),
                          //       child: Column(children: [
                          //         Row(children: [
                          //           Expanded(child: 'Address:'.text.make()),
                          //           if (order.address != null)
                          //             Expanded(
                          //                 flex: 2,
                          //                 child:
                          //                     order.address!.text.bold.make())
                          //         ]),
                          //         Row(children: [
                          //           Expanded(child: 'PostCode:'.text.make()),
                          //           if (order.postCode != null)
                          //             Expanded(
                          //                 flex: 2,
                          //                 child:
                          //                     order.postCode!.text.bold.make())
                          //         ])
                          //       ]),
                          //     ),
                          //   ),

                          ///Order details

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      order.service.type == 'Product' ?
                                      'Order Details'
                                          .text
                                          .minFontSize(18)
                                          .make() :
                                      'Booking Details'
                                          .text
                                          .minFontSize(18)
                                          .make(),
                                    ],
                                  ),
                                  10.heightBox,
                                  Row(
                                    children: [
                                      'Product Name:'.text.make(),
                                      10.widthBox,
                                      order.service.name.text.make(),
                                    ],
                                  ),
                                  5.heightBox,
                                  if(order.service.sizes != null)
                                  Row(
                                    children: [
                                      'Size:'.text.make(),
                                      10.widthBox,
                                      order.service.sizes![order.selectedSize!].text.make(),
                                    ],
                                  ),
                                  if(order.service.sizes != null)
                                  5.heightBox,

                                  if(order.shopId == currentUser.shopId)
                                  Row(
                                    children: [
                                      'Processing fee:'.text.make(),
                                      10.widthBox,
                                      model.processingFee.toStringAsFixed(0).text.make(),
                                      '%'.text.make(),
                                    ],
                                  ),
                                  if(order.shopId == currentUser.shopId)
                                  5.heightBox,
                                ]),
                          ),

                          Divider(color: Colors.grey),

                          ///Buyer details
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  /*Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        if (order.rate != 0 && order.rate != null)
                                          'Your rating: '.text.make()
                                        else
                                          'Your rating?'.text.make(),

                                        if (order.rate != 0 && order.rate != null)
                                        RatingStars(
                                          value: double.parse(order.rate.toString()),
                                          starSize: 16,
                                          valueLabelVisibility: false,
                                        )
                                        else
                                          RatingStars(
                                            value: model.rating,
                                            starSize: 16,
                                            onValueChanged: (value) {
                                              model.setRating(value, order);
                                            },
                                            valueLabelVisibility: false,
                                          )
                                      ],
                                    ),*/

                                  Row(
                                    children: [
                                      'Buyer Details'
                                          .text
                                          .minFontSize(18)
                                          .make(),
                                    ],
                                  ),
                                  10.heightBox,
                                  Row(
                                    children: [
                                      'Full Name:'.text.make(),
                                      15.widthBox,
                                      order.name!.text.make(),
                                    ],
                                  ),
                                  5.heightBox,
                                  Row(
                                    children: [
                                      'Address:'.text.make(),
                                      15.widthBox,
                                      order.address!.text.make(),
                                    ],
                                  ),
                                  5.heightBox,
                                  Row(
                                    children: [
                                      'PostCode:'.text.make(),
                                      15.widthBox,
                                      order.postCode!.text.make(),
                                    ],
                                  ),
                                  5.heightBox,
                                  // Padding(
                                  //   padding: const EdgeInsets.only(top: 8),
                                  //   child: MaterialButton(
                                  //     onPressed: () {
                                  //       if (model.isApiLoading) {
                                  //         return;
                                  //       }
                                  //       model.handleMakeCompleted(order);
                                  //     },
                                  //     color: Color(color),
                                  //     child: Text(
                                  //       order.type == OrderType.product
                                  //           ? 'Mark as delivered'
                                  //           : 'Mark as completed',
                                  //       style: const TextStyle(
                                  //         color: Colors.black,
                                  //         fontWeight: FontWeight.bold,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                ]),
                          ),

                          Divider(color: Colors.grey),

                          ///Product Received card
                          if (order.status == OrderStatus.progress &&
                              order.userId == currentUser.id)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                'Have you received your product?'
                                    .text
                                    .size(size.height * 0.017)
                                    .fontWeight(FontWeight.w500)
                                    .make(),
                                Spacer(),
                                Container(
                                  //color: Colors.red,
                                  child: Row(
                                    children: [
                                      Container(
                                        //height: size.height * 0.07,
                                        //width: size.height * 0.07,
                                        /*decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(color: Colors.black12),
                                            borderRadius: BorderRadius.circular(55)
                                        ),*/
                                        child: Center(
                                          child: Icon(
                                              Icons.watch_later_outlined,
                                              size: size.height * 0.060),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                'Service Received'
                                                    .text
                                                    .size(size.height * 0.018)
                                                    .fontWeight(FontWeight.w600)
                                                    .make(),
                                              ],
                                            ),
                                            2.heightBox,
                                            'Confirm you have received your product after the delivery'
                                                .text
                                                .size(size.height * 0.015)
                                                .fontWeight(FontWeight.w500)
                                                .make(),
                                          ],
                                        ).px(5),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              if (model.isApiLoading) {
                                                return;
                                              }
                                              model.handleRequestReceivedProduct(order);
                                            },
                                            child: Container(
                                              height: size.height * 0.035,
                                              width: size.width * 0.25,
                                              decoration: BoxDecoration(
                                                  color: Color(0xff828CFC),
                                                  border: Border.all(
                                                      color: Colors.black12),
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Center(
                                                child: 'Received'
                                                    .text
                                                    .size(13)
                                                    .white
                                                    .fontWeight(FontWeight.w500)
                                                    .make(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ).h(size.height * 0.1),
                                // Divider(color: Colors.red),
                              ],
                            )
                                .px(size.width * 0.03)
                                .py(size.height * 0.008)
                                .h(size.height * 0.15),

                          ///service Received card
                          if (order.status == OrderStatus.bookApproved &&
                              order.userId == currentUser.id)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                'Have you received your service?'
                                    .text
                                    .size(15)
                                    .fontWeight(FontWeight.w500)
                                    .make(),
                                Spacer(),
                                Container(
                                  //color: Colors.red,
                                  child: Row(
                                    children: [
                                      Container(
                                        child: Center(
                                          child: Icon(
                                              Icons.watch_later_outlined,
                                              size: size.height * 0.065),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                'Service Received'
                                                    .text
                                                    .size(15)
                                                    .fontWeight(FontWeight.w600)
                                                    .make(),
                                              ],
                                            ),
                                            2.heightBox,
                                            'Confirm you have received your service after the appointment'
                                                .text
                                                .size(11)
                                                .fontWeight(FontWeight.w400)
                                                .make(),
                                          ],
                                        ).px(5),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              if (model.isApiLoading) {
                                                return;
                                              }
                                              model
                                                  .handleRequestReceivedService(
                                                      order);
                                            },
                                            child: Container(
                                              height: size.height * 0.035,
                                              width: size.width * 0.28,
                                              decoration: BoxDecoration(
                                                  color: Color(0xff828CFC),
                                                  border: Border.all(
                                                      color: Colors.black12),
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Center(
                                                child: 'Received'
                                                    .text
                                                    .size(13)
                                                    .white
                                                    .fontWeight(FontWeight.w500)
                                                    .make(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ).h(size.height * 0.1),
                                Divider(color: Colors.grey),
                              ],
                            )
                                .px(size.width * 0.03)
                                .py(size.height * 0.008)
                                .h(size.height * 0.175),

                          ///give rating
                          if ((model.order.status == OrderStatus.completed ||
                                  model.order.status ==
                                      OrderStatus.refundCaseClosed) &&
                              model.order.userId == currentUser.id &&
                              model.order.rate == 0)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                'Review Order'
                                    .text
                                    .size(15)
                                    .fontWeight(FontWeight.w600)
                                    .make(),
                                Spacer(),
                                Container(
                                  //color: Colors.red,
                                  child: Row(
                                    children: [
                                      Container(
                                        height: size.height * 0.05,
                                        width: size.height * 0.05,
                                        decoration: BoxDecoration(
                                            //color: Colors.white,
                                            border:
                                                Border.all(color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(55)),
                                        child: Center(
                                          child: Icon(Icons.star,
                                              color: Colors.yellow,
                                              size: size.height * 0.03),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                'Leave your feedback'
                                                    .text
                                                    .size(size.height * 0.017)
                                                    .fontWeight(FontWeight.w600)
                                                    .make(),
                                              ],
                                            ),
                                            3.heightBox,
                                            'Tell us that how was your experience with this seller'
                                                .text
                                                .size(size.height * 0.015)
                                                .fontWeight(FontWeight.w500)
                                                .make(),
                                          ],
                                        ).px(5),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              showModalBottomSheet(
                                                  isScrollControlled: true,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  context: context,
                                                  builder: (context) {
                                                    return RatingSheet(
                                                      user: model.user,
                                                      order: order,
                                                    );
                                                  }).then((value) {
                                                model
                                                    .updateOrder(order.orderId);
                                              });
                                            },
                                            child: Container(
                                              height: size.height * 0.035,
                                              width: size.width * 0.28,
                                              decoration: BoxDecoration(
                                                  color: Color(0xff828CFC),
                                                  border: Border.all(
                                                      color: Colors.black12),
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Center(
                                                child: 'Give Reviews'
                                                    .text
                                                    .size(size.height * 0.015)
                                                    .white
                                                    .fontWeight(FontWeight.w500)
                                                    .make(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ).h(size.height * 0.08),
                                Divider(color: Colors.grey),
                              ],
                            )
                                .px(size.width * 0.03)
                                .py(size.height * 0.007)
                                .h(size.height * 0.16)
                          else if (model.order.rate != 0)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (model.order.userId == currentUser.id)
                                  'Your Review'
                                      .text
                                      .size(15)
                                      .fontWeight(FontWeight.w600)
                                      .make()
                                else
                                  'Review'
                                      .text
                                      .size(15)
                                      .fontWeight(FontWeight.w600)
                                      .make(),
                                Spacer(),
                                Container(
                                  child: Row(
                                    children: [
                                      RatingStars(
                                        value: double.parse(
                                            model.order.rate.toString()),
                                        starSize: size.height * 0.025,
                                        valueLabelVisibility: true,
                                      )
                                    ],
                                  ),
                                ).h(size.height * 0.045),
                                Divider(color: Colors.grey),
                              ],
                            )
                                .px(size.width * 0.03)
                                .py(size.height * 0.005)
                                .h(size.height * 0.12),

                          ///appointment details
                          if (order.type == OrderType.service &&
                              order.status != OrderStatus.bookCancelled &&
                              order.service.bookingNote != null)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                'Appointment Note'
                                    .text
                                    .size(15)
                                    .fontWeight(FontWeight.w600)
                                    .make(),
                                (size.height * 0.008).heightBox,

                                //'Mask must be worn on arrival, Any question please message me.'
                                order.service.bookingNote!.text
                                    .size(13)
                                    .fontWeight(FontWeight.w500)
                                    .maxLines(2)
                                    .make(),
                                Divider(color: Colors.grey),
                              ],
                            ).px(size.width * 0.03).h(size.height * 0.13),

                          SizedBox(
                            width: context.screenWidth,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // if (order.status == OrderStatus.completed &&
                                //     order.userId == currentUser.id)
                                //   MaterialButton(
                                //     onPressed: () {
                                //       if (model.isApiLoading) {
                                //         return;
                                //       } else {
                                //         model.handleRefundCase(order, context);
                                //       }
                                //     },
                                //     color: Color(color),
                                //     child: Stack(
                                //       alignment: Alignment.center,
                                //       children: [
                                //         Align(
                                //           alignment: Alignment.bottomLeft,
                                //           child: Padding(
                                //             padding: const EdgeInsets.only(
                                //                 left: 100),
                                //             child: SizedBox(
                                //               width: 20,
                                //               height: 20,
                                //               child: model.isApiLoading
                                //                   ? const CircularProgressIndicator()
                                //                   : null,
                                //             ),
                                //           ),
                                //         ),
                                //         const Text(
                                //           'Something wrong?',
                                //           style: TextStyle(
                                //             color: Colors.white,
                                //             fontWeight: FontWeight.bold,
                                //           ),
                                //         ),
                                //       ],
                                //     ),
                                //   ),
                                if (order.status ==
                                        OrderStatus.refundRequested &&
                                    order.userId == currentUser.id)
                                  MaterialButton(
                                    onPressed: () {
                                      if (model.isApiLoading) {
                                        return;
                                      } else {
                                        model.handleCancelRefundCase(order);
                                      }
                                    },
                                    color: Color(color),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Align(
                                          alignment: Alignment.bottomLeft,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 100),
                                            child: SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: model.isApiLoading
                                                  ? const CircularProgressIndicator()
                                                  : null,
                                            ),
                                          ),
                                        ),
                                        const Text(
                                          'Cancel refund case',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                /*if (order.status == OrderStatus.progress &&
                                    order.userId == currentUser.id)
                                  OutlinedButton(
                                    onPressed: () {
                                      if (model.isApiLoading) {
                                        return;
                                      }
                                      model.handleRequestReceivedProduct(order);
                                    },
                                    child: Text(
                                      'Received product',
                                      style: TextStyle(
                                        color: Color(color),
                                      ),
                                    ),
                                  ),*/
                              ],
                            ),
                          ),
                          SizedBox(
                            width: context.screenWidth,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (order.status == OrderStatus.progress &&
                                    order.shopId == currentUser.shopId)
                                  MaterialButton(
                                    onPressed: () {
                                      if (model.isApiLoading) {
                                        return;
                                      }
                                      model.handleRefund(order);
                                    },
                                    color: Colors.red,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: const [
                                        Text(
                                          'Cancel Order',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                if (order.status == OrderStatus.progress &&
                                    order.userId == currentUser.id)
                                  OutlinedButton(
                                    onPressed: () {
                                      if (model.isApiLoading) {
                                        return;
                                      }
                                      model.handleCancelRefund(order);
                                      //model.handleRequestRefund(order);
                                    },
                                    child: Text(
                                      'Something wrong?',
                                      style: TextStyle(
                                        color: Color(color),
                                      ),
                                    ),
                                  ),
                                if (order.status == OrderStatus.bookRequested &&
                                    order.service.ownerId == currentUser.id)
                                  MaterialButton(
                                    onPressed: () {
                                      if (model.isApiLoading) {
                                        return;
                                      }
                                      model.handleApproveAppointment(order);
                                    },
                                    color: Color(color),
                                    child: const Text(
                                      'Approve appointment',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                if (order.status == OrderStatus.bookRequested ||
                                    order.status == OrderStatus.bookApproved)
                                  OutlinedButton(
                                    onPressed: () {
                                      if (model.isApiLoading) {
                                        return;
                                      }
                                      model.handleMakeCancel(order);
                                    },
                                    child: const Text(
                                      'Cancel appointments',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                /*if (order.status == OrderStatus.bookApproved &&
                                    order.userId == currentUser.id)
                                  MaterialButton(
                                    onPressed: () {
                                      if (model.isApiLoading) {
                                        return;
                                      }
                                      model.handleRequestReceivedService(order);
                                      //model.navigateToBookServiceView(order);
                                    },
                                    color: Color(color),
                                    child: const Text(
                                      'Received Service',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),*/
                              ],
                            ),
                          ),
                        ],
                      ).p20(),
                    ),
                  ),
                  BusyLoader(busy: model.isApiLoading),
                ],
              ),
            ),
      viewModelBuilder: () => OrderDetailViewModel(),
    );
  }

  Widget renderStatusIcons(String status, double height) {
    switch (status) {
      case 'PROGRESS':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///order Requested or received
            if (order.shopId == currentUser.shopId)
              renderCheckIcon(
                  height, true, "Order Received", "You have received an order")
            else
              renderCheckIcon(height, true, "Order Requested",
                  "You have requested an order"),
            renderCheckDivider(height, true),

            ///order accepted
            if (order.shopId == currentUser.shopId)
              renderCheckIcon(
                  height, true, "Order Accepted", "Order has been accepted")
            else
              renderCheckIcon(height, true, "Order Accepted",
                  "Your order has been accepted"),
            renderCheckDivider(height, false),

            ///order received
            if (order.shopId == currentUser.shopId)
              renderCheckIcon(height, false, "Service Delivered",
                  "You have Delivered service")
            else
              renderCheckIcon(height, false, "Received Service",
                  "You have received your service"),
            renderCheckDivider(height, false),

            ///order accepted
            renderCheckIcon(height, false, "Completed", "Order Completed"),
          ],
        );
      case 'REFUNDED':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///order Requested or received
            if (order.shopId == currentUser.shopId)
              renderCheckIcon(
                  height, true, "Order Received", "You have received an order")
            else
              renderCheckIcon(height, true, "Order Requested",
                  "You have requested an order"),
            renderCheckDivider(height, false),

            ///order accepted
            if (order.shopId == currentUser.shopId)
              renderCheckIcon(
                  height, false, "Order Accepted", "Order has been accepted")
            else
              renderCheckIcon(height, false, "Order Accepted",
                  "Your order has been accepted"),
            renderCheckDivider(height, false),

            ///order received
            if (order.shopId == currentUser.shopId)
              renderCheckIcon(height, false, "Service Delivered",
                  "You have Delivered service")
            else
              renderCheckIcon(height, false, "Received Service",
                  "You have received your service"),
            renderCheckDivider(height, false),

            ///order accepted
            renderCheckIcon(height, false, "Completed", "Order Completed"),
          ],
        );
      case 'COMPLETED':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///order Requested or received
            if (order.shopId == currentUser.shopId)
              renderCheckIcon(
                  height, true, "Order Received", "You have received an order")
            else
              renderCheckIcon(height, true, "Order Requested",
                  "You have requested an order"),
            renderCheckDivider(height, true),

            ///order accepted
            if (order.shopId == currentUser.shopId)
              renderCheckIcon(
                  height, true, "Order Accepted", "Order has been accepted")
            else
              renderCheckIcon(height, true, "Order Accepted",
                  "Your order has been accepted"),
            renderCheckDivider(height, true),

            ///order received
            if (order.shopId == currentUser.shopId)
              renderCheckIcon(height, true, "Service Delivered",
                  "You have Delivered service")
            else
              renderCheckIcon(height, true, "Received Service",
                  "You have received your service"),
            renderCheckDivider(height, true),

            ///order accepted
            renderCheckIcon(height, true, "Completed", "Order Completed"),
          ],
        );
      case 'BOOK REQUESTED':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///order Requested or received
            if (order.shopId == currentUser.shopId)
              renderCheckIcon(height, true, "Service Received",
                  "You have received service request")
            else
              renderCheckIcon(height, true, "Service Requested",
                  "You have requested service"),
            renderCheckDivider(height, false),

            ///order accepted
            if (order.shopId == currentUser.shopId)
              renderCheckIcon(height, false, "Service Accepted",
                  "Service has been accepted")
            else
              renderCheckIcon(height, false, "Service Accepted",
                  "Your service has been accepted"),
            renderCheckDivider(height, false),

            ///order received
            if (order.shopId == currentUser.shopId)
              renderCheckIcon(height, false, "Service Delivered",
                  "You have Delivered service")
            else
              renderCheckIcon(height, false, "Received Service",
                  "You have received your service"),
            renderCheckDivider(height, false),

            ///order accepted
            renderCheckIcon(height, false, "Completed", "Service Completed"),
          ],
        );
      case 'CANCELLED':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///order Requested or received
            if (order.shopId == currentUser.shopId)
              renderCheckIcon(height, true, "Service Received",
                  "You have received service request")
            else
              renderCheckIcon(height, true, "Service Requested",
                  "You have requested service"),
            renderCheckDivider(height, false),

            ///order accepted
            if (order.shopId == currentUser.shopId)
              renderCheckIcon(height, false, "Service Accepted",
                  "Service has been accepted")
            else
              renderCheckIcon(height, false, "Service Accepted",
                  "Your service has been accepted"),
            renderCheckDivider(height, false),

            ///order received
            if (order.shopId == currentUser.shopId)
              renderCheckIcon(height, false, "Service Delivered",
                  "You have Delivered service")
            else
              renderCheckIcon(height, false, "Received Service",
                  "You have received your service"),
            renderCheckDivider(height, false),

            ///order accepted
            renderCheckIcon(height, false, "Completed", "Service Completed"),
          ],
        );
      case 'BOOK APPROVED':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///order Requested or received
            if (order.shopId == currentUser.shopId)
              renderCheckIcon(height, true, "Service Received",
                  "You have received service request")
            else
              renderCheckIcon(height, true, "Service Requested",
                  "You have requested service"),
            renderCheckDivider(height, true),

            ///order accepted
            if (order.shopId == currentUser.shopId)
              renderCheckIcon(
                  height, true, "Service Accepted", "Service has been accepted")
            else
              renderCheckIcon(height, true, "Service Accepted",
                  "Your service has been accepted"),
            renderCheckDivider(height, false),

            ///order received
            if (order.shopId == currentUser.shopId)
              renderCheckIcon(height, false, "Service Delivered",
                  "You have Delivered service")
            else
              renderCheckIcon(height, false, "Received Service",
                  "You have received your service"),
            renderCheckDivider(height, false),

            ///order accepted
            renderCheckIcon(height, false, "Completed", "Service Completed"),
          ],
        );
      case 'REFUND REQUESTED':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///order Requested or received
            if (order.shopId == currentUser.shopId)
              renderCheckIcon(
                  height, true, "Order Received", "You have received an order")
            else
              renderCheckIcon(height, true, "Order Requested",
                  "You have requested an order"),
            renderCheckDivider(height, true),

            ///order accepted
            if (order.shopId == currentUser.shopId)
              renderCheckIcon(
                  height, true, "Order Accepted", "Order has been accepted")
            else
              renderCheckIcon(height, true, "Order Accepted",
                  "Your order has been accepted"),
            renderCheckDivider(height, true),

            ///order received
            if (order.shopId == currentUser.shopId)
              renderCheckIcon(height, true, "Service Delivered",
                  "You have Delivered service")
            else
              renderCheckIcon(height, true, "Received Service",
                  "You have received your service"),
            renderCheckDivider(height, true),

            ///order accepted
            renderCheckIcon(height, true, "Completed", "Order Completed"),
          ],
        );
      case 'REFUND CASE CLOSED':
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///order Requested or received
            if (order.shopId == currentUser.shopId)
              renderCheckIcon(
                  height, true, "Order Received", "You have received an order")
            else
              renderCheckIcon(height, true, "Order Requested",
                  "You have requested an order"),
            renderCheckDivider(height, true),

            ///order accepted
            if (order.shopId == currentUser.shopId)
              renderCheckIcon(
                  height, true, "Order Accepted", "Order has been accepted")
            else
              renderCheckIcon(height, true, "Order Accepted",
                  "Your order has been accepted"),
            renderCheckDivider(height, true),

            ///order received
            if (order.shopId == currentUser.shopId)
              renderCheckIcon(height, true, "Service Delivered",
                  "You have Delivered service")
            else
              renderCheckIcon(height, true, "Received Service",
                  "You have received your service"),
            renderCheckDivider(height, true),

            ///order accepted
            renderCheckIcon(height, true, "Completed", "Order Completed"),
          ],
        );
    }
    return Container();
  }

  Widget renderCheckIcon(
      double height, bool enable, String title, String subTitle) {
    return Row(
      children: [
        Container(
            height: height * 0.028,
            width: height * 0.028,
            decoration: BoxDecoration(
                color:
                    enable ? Constants.enabledColor : Constants.disabledColor,
                borderRadius: BorderRadius.circular(55)),
            child: Center(
                child: enable
                    ? Icon(Icons.check,
                        size: height * 0.017, color: Colors.white)
                    : Icon(Icons.watch_later_outlined,
                        size: height * 0.017, color: Colors.white))),
        10.widthBox,
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                title.text
                    //.color(Color(0xff151515))
                    .size(height * 0.016)
                    .fontWeight(FontWeight.w600)
                    .make()
              ],
            ),
            Row(
              children: [
                subTitle.text
                    //.color(Color(0xff828282))
                    .size(height * 0.013)
                    // .lineHeight(1)
                    .fontWeight(FontWeight.w400)
                    .make()
              ],
            ),
          ],
        ),
      ],
    ).px(10);
  }

  Widget renderCheckDivider(double height, bool enable) {
    return Container(
      width: 2,
      height: height * 0.040,
      margin: EdgeInsets.only(left: 21),
      color: enable ? Constants.enabledColor : Constants.disabledColor,
    );
  }

  Widget renderStatusDivider(double height) {
    return Container(
      height: height * 0.033,
    );
  }
}

class RatingSheet extends StatelessWidget {
  const RatingSheet({Key? key, required this.user, required this.order})
      : super(key: key);

  final AppUser user;
  final Order order;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    double height = media.height;
    double width = media.width;

    return ViewModelBuilder<OrderDetailViewModel>.reactive(
      //onModelReady: (model) => model.init(order.service, order),
      builder: (context, model, child) => Stack(
        children: [
          Wrap(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                ),
                child: Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                              height: height * 0.04,
                              width: width * 0.08,
                              //color: Colors.red,
                              margin: EdgeInsets.only(
                                  top: height * 0.005, right: width * 0.01),
                              child: Icon(Icons.clear, size: 19)),
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                      child: Column(
                        //crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: height * 0.02),
                                child: 'Give Ratings'
                                        ''
                                    .text
                                    .bold
                                    .size(20)
                                    .make(),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          RatingStars(
                            value: model.rating,
                            starSize: height * 0.035,
                            onValueChanged: (value) {
                              model.updateRating(value);
                            },
                            valueLabelVisibility: false,
                          ),
                          SizedBox(
                            height: height * 0.02,
                          ),
                          Container(
                            height: height * 0.045,
                            width: width * 0.95,
                            decoration: BoxDecoration(
                              color: Color(4286745852),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: MaterialButton(
                              onPressed: () {
                                model.setRating(order);
                              },
                              child: model.isRatingLoading
                                  ? CircularProgressIndicator(
                                      color: Colors.white)
                                  : const Text(
                                      'Submit',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 16),
                                    ),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.015,
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          BusyLoader(busy: model.isBusy),
        ],
      ),
      viewModelBuilder: () => OrderDetailViewModel(),
    );
  }
}
