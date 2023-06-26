import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:mipromo/models/order.dart';
import 'package:mipromo/models/shop_service.dart';
import 'package:mipromo/ui/service/service_viewmodel.dart';
import 'package:mipromo/ui/shared/helpers/Constants.dart';
import 'package:mipromo/ui/shared/helpers/enums.dart';
import 'package:mipromo/ui/shared/widgets/avatar.dart';
import 'package:mipromo/ui/shared/widgets/basic_loader.dart';
import 'package:mipromo/ui/shared/widgets/busy_loader.dart';
import 'package:mipromo/ui/value/colors.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:video_player/video_player.dart';

class ServiceView extends StatefulWidget {
  final ShopService service;
  final int color;
  final String fontStyle;

  const ServiceView({
    Key? key,
    required this.service,
    required this.color,
    required this.fontStyle,
  }) : super(key: key);

  @override
  _ServiceViewState createState() => _ServiceViewState();
}

class _ServiceViewState extends State<ServiceView> {
  ChewieController? chewieController;
  VideoPlayerController? videoPlayerController;
  bool videoLoading = false;
  bool videoPlaying = false;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();

    if (widget.service.videoUrl != null) initializePlayer();
  }

  initializePlayer() async {
    setState(() {
      videoLoading = true;
    });
    videoPlayerController =
        VideoPlayerController.network(widget.service.videoUrl.toString());

    print(widget.service.videoUrl.toString());

    chewieController = ChewieController(
      aspectRatio: widget.service.aspectRatio,
      videoPlayerController: videoPlayerController!,
      // autoInitialize: true,
      allowMuting: true,
      // autoPlay : true,
      showControls: false,
      looping: true,
      allowFullScreen: true,
      fullScreenByDefault: false,
      deviceOrientationsOnEnterFullScreen: [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown
      ],
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.purple,
        bufferedColor: Colors.purple.withOpacity(0.4),
      ),
    );
    // videoPlayerController!.addListener(checkVideo);

    _initializeVideoPlayerFuture = videoPlayerController!.initialize().then(
        (value) => {
              videoPlayerController!.setLooping(true),
              videoPlayerController!.play()
            });
  }

  // checkVideo() {
  //   if (videoPlayerController!.value.isInitialized) {
  //     videoPlaying = true;
  //   }
  // }

  void dispose() {
    videoPlayerController!.dispose();
    chewieController!.dispose();
    chewieController!.pause();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return ViewModelBuilder<ServiceViewModel>.reactive(
      onModelReady: (model) => model.init(widget.service),
      builder: (context, model, child) => model.isBusy
          ? const BasicLoader()
          : Scaffold(
              //backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Color(widget.color),
                centerTitle: true,
                title: widget.service.type == Constants.productLabel
                    ? const Text('Buy Product')
                    : const Text('Book Service'),
              ),
              body: Stack(
                children: [
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Container(
                                  height: 55,
                                  width: 55,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            model.shopowner.imageUrl),
                                        fit: BoxFit.cover,
                                      ),
                                      border: Border.all(color: hintText),
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        ' ' + model.shop.name,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.location_on_outlined,
                                            size: 15,
                                          ),
                                          model.shop.location.text.make(),
                                          if (model.shop.borough.isNotEmpty)
                                            ', ${model.shop.borough}'
                                                .text
                                                .make()
                                          else
                                            const SizedBox.shrink(),
                                        ],
                                      ),
                                    ]),
                              ],
                            ),
                          ),
                          AspectRatio(
                            aspectRatio: model.service.aspectRatio!,
                            child: PageView(
                              controller: model.viewController,
                              children: [
                                if (widget.service.imageUrl1 != null) ...[
                                  CachedNetworkImage(
                                    imageUrl: widget.service.imageUrl1!,
                                    fit: BoxFit.fitHeight,
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ],
                                if (widget.service.imageUrl2 != null) ...[
                                  CachedNetworkImage(
                                    imageUrl: widget.service.imageUrl2!,
                                    fit: BoxFit.fill,
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ],
                                if (widget.service.imageUrl3 != null) ...[
                                  CachedNetworkImage(
                                    imageUrl: widget.service.imageUrl3!,
                                    fit: BoxFit.fill,
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ],
                                if (widget.service.videoUrl != null) ...[
                                  FutureBuilder(
                                      future: _initializeVideoPlayerFuture,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          // If the VideoPlayerController has finished initialization, use
                                          // the data it provides to limit the aspect ratio of the video.
                                          return AspectRatio(
                                            aspectRatio:
                                                widget.service.aspectRatio!,
                                            child: Chewie(
                                              controller: chewieController!,
                                            ),
                                          );
                                        } else {
                                          // If the VideoPlayerController is still initializing, show a
                                          // loading spinner.
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      }),

                                  // Align(
                                  //   alignment: Alignment.topRight,
                                  //   child: Padding(
                                  //     padding: const EdgeInsets.all(8.0),
                                  //     child: Icon(
                                  //       Icons.videocam_sharp,
                                  //       color: Colors.white,
                                  //       size: 30,
                                  //     ),
                                  //   ),
                                  // ),
                                ]
                              ],
                            ),
                          ),
                          3.heightBox,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(model.imagesCount.length,
                                (index) {
                              return Container(
                                height: 4,
                                width: 10,
                                margin: EdgeInsets.only(left: 4),
                                decoration: BoxDecoration(
                                    color: model.selectedIndex == index
                                        ? Color(widget.color)
                                        : Colors.grey[400],
                                    borderRadius: BorderRadius.circular(55)),
                              );
                            }),
                          ).px(20),
                          5.heightBox,

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0, top: 15.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    widget.service.name.text.xl.bold
                                        //.fontFamily(fontStyle)
                                        .maxLines(2)
                                        .xl2
                                        .make(),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    "£${widget.service.price.toStringAsFixed(2)}"
                                        .text
                                        .lg
                                        .make(),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Container(
                                      width: 70,
                                      height: 35,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Center(
                                          child: Text(
                                        'New',
                                        style: TextStyle(
                                            color: white,
                                            fontFamily: 'Default'),
                                      )),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: 15.0, bottom: 25.0),
                                child: Icon(
                                  Icons.favorite_border_outlined,
                                  color: hintText,
                                ),
                              )
                            ],
                          ),
                          20.heightBox,
                          Container(
                            height: 1,
                            width: double.infinity,
                            color: Colors.grey.withOpacity(0.30),
                          ),
                          if (widget.service.type == "Product")
                            if (widget.service.sizes == null ||
                                widget.service.sizes!.isEmpty)
                              const SizedBox.shrink()
                            else
                              Column(
                                children: [
                                  20.heightBox,
                                  "Select Sizes"
                                      .text
                                      .size(15)
                                      .fontWeight(FontWeight.w600)
                                      .make(),
                                  10.heightBox,
                                ],
                              ).px(20),
                          if (widget.service.type == "Product")
                            if (widget.service.sizes == null ||
                                widget.service.sizes!.isEmpty)
                              const SizedBox.shrink()
                            else
                              Wrap(
                                runSpacing: 7,
                                children: List.generate(
                                    widget.service.sizes!.length, (index) {
                                  return InkWell(
                                    onTap: () {
                                      if (widget.service.ownerId ==
                                          model.user.id) {
                                      } else {
                                        model.onSizeSelected(index);
                                      }
                                    },
                                    child: Container(
                                      height: 30,
                                      width: 62,
                                      margin: const EdgeInsets.only(right: 8),
                                      decoration: BoxDecoration(
                                          color:
                                              model.selectedSizeIndex == index
                                                  ? Color(widget.color)
                                                  : null,
                                          borderRadius:
                                              BorderRadius.circular(2),
                                          border: Border.all(
                                              color: model.selectedSizeIndex ==
                                                      index
                                                  ? Color(widget.color)
                                                  : Color(0xFFEEEEEE))),
                                      child: Center(
                                        child: Text(
                                          widget.service.sizes![index],
                                          style: TextStyle(
                                              color: model.selectedSizeIndex ==
                                                      index
                                                  ? Colors.white
                                                  : null,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ).px(20),
                          20.heightBox,
                          Container(
                            height: 1,
                            width: double.infinity,
                            color: Colors.grey.withOpacity(0.30),
                          ),
                          20.heightBox,
                          "Item Description"
                              .text
                              .size(15)
                              .fontWeight(FontWeight.w600)
                              .make()
                              .px(20),

                          widget.service.description!.text
                              .color(Colors.grey)
                              .make()
                              .py8()
                              .px(20),
                          10.heightBox,
                          Row(
                            children: [
                              Image.asset('assets/icon/shield.png', scale: 10),
                              "Buyer Protection"
                                  .text
                                  .color(Colors.grey)
                                  .make()
                                  .px4()
                            ],
                          ).px(20),
                        
                          20.heightBox,
                          Container(
                            height: 1,
                            width: double.infinity,
                            color: Colors.grey.withOpacity(0.30),
                          ),
                          if (widget.service.ownerId != model.user.id)
                            20.heightBox
                          else
                            5.heightBox,

                          // model.user.chatIds != null &&
                          //         model.user.chatIds!.contains(service.ownerId)
                          //     ? SizedBox(
                          //         width: context.screenWidth,
                          //         child: Column(
                          //           crossAxisAlignment:
                          //               CrossAxisAlignment.stretch,
                          //           children: [
                          //             OutlinedButton(
                          //               onPressed: () {
                          //                 model.navigateToChatsView();
                          //               },
                          //               child: const Text('Chat'),
                          //             ),
                          //             MaterialButton(
                          //               onPressed: () {},
                          //               color: Color(color),
                          //               child: const Text(
                          //                 'Book',
                          //                 style: TextStyle(
                          //                   color: Colors.black,
                          //                   fontWeight: FontWeight.bold,
                          //                 ),
                          //               ),
                          //             )
                          //           ],
                          //         ),
                          //       )
                          //     : MaterialButton(
                          //         minWidth: context.screenWidth,
                          //         color: Color(color),
                          //         onPressed: () {
                          //           model.bookService(service.ownerId);
                          //         },
                          //         child: Constants.bookLabel.text.lg.make(),
                          //       ),
                        ],
                      ),
                    ),
                  ),
                  BusyLoader(busy: model.isApiRunning)
                ],
              ),
              bottomNavigationBar: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (widget.service.ownerId == model.user.id) ...[
                      InkWell(
                        onTap: () {
                          model.deleteService(widget.service);
                        },
                        child: Container(
                          height: size.height * 0.05,
                          width: size.width * 0.35,
                          decoration: BoxDecoration(
                              /*border: Border(
                                top: BorderSide(color: Colors.red, width: 1),
                                bottom: BorderSide(color: Colors.red, width: 1))*/
                              ),
                          child: Row(
                            children: [
                              10.widthBox,
                              'Delete'.text.bold.make(),
                            ],
                          ),
                        ).px(2),
                      ),
                      InkWell(
                        onTap: () {
                          model.navigateToEditServiceView(widget.service);
                        },
                        child: Container(
                          height: size.height * 0.05,
                          width: size.width * 0.15,
                          decoration: BoxDecoration(
                              /*border: Border(
                                top: BorderSide(color: Colors.red, width: 1),
                                bottom: BorderSide(color: Colors.red, width: 1))*/
                              ),
                          child: Row(
                            children: [
                              10.widthBox,
                              'Edit'.text.bold.make(),
                            ],
                          ),
                        ).px(2),
                      )
                    ] else
                      Container(
                        width: context.screenWidth * 0.95,
                        padding: EdgeInsets.only(bottom: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (widget.service.type == Constants.productLabel)
                              Expanded(
                                child: MaterialButton(
                                  minWidth: context.screenWidth,
                                  color: Color(widget.color),
                                  onPressed: () {
                                    if (widget.service.sizes!.isEmpty ||
                                        widget.service.sizes == null) {
                                      if (widget.service.videoUrl != null) {
                                        chewieController!.pause();
                                      }
                                      model.navigateToBuyServiceView();
                                    } else {
                                      if (widget.service.videoUrl != null) {
                                        chewieController!.pause();
                                      }
                                      model.isBuyServiceFormValidate();
                                    }
                                  },
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Row(
                                        children: const [
                                          Icon(Icons.calendar_today,
                                              size: 25, color: Colors.white)
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Text(
                                            'Buy',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          /*Constants
                                                    .buyLabel.text.white.lg
                                                    .make(),*/
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            else
                              Expanded(
                                child: MaterialButton(
                                  onPressed: () {
                                    if (widget.service.videoUrl != null) {
                                      chewieController!.pause();
                                    }
                                    model.bookService();
                                  },
                                  color: Color(widget.color),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Row(
                                        children: const [
                                          Icon(Icons.calendar_today,
                                              size: 25, color: Colors.white)
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          Text(
                                            'Book',
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          /*Constants
                                                    .bookLabel.text.white.lg
                                                    .make(),*/
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            10.widthBox,
                            Expanded(
                              child: MaterialButton(
                                //padding: EdgeInsets.symmetric(horizontal: 10),
                                onPressed: () {
                                  if (model.user.chatIds != null &&
                                      model.user.chatIds!
                                          .contains(widget.service.ownerId)) {
                                    if (widget.service.videoUrl != null) {
                                      chewieController!.pause();
                                    }
                                    model.navigateToDirectChatView(
                                        widget.service.ownerId);
                                    //model.navigateToChatsView();
                                  } else {
                                    if (widget.service.videoUrl != null) {
                                      chewieController!.pause();
                                    }
                                    model.updateChat(widget.service.ownerId);
                                  }
                                },
                                color: Color(widget.color),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        //Icon(Icons.chat, size: 20, color: Colors.white)
                                        Image.asset('assets/icon/chat.png',
                                            scale: 7),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text(
                                          'Message',
                                          //textScaleFactor: 1.125,
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
      viewModelBuilder: () => ServiceViewModel(),
    );
  }
}
