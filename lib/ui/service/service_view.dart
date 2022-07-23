import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mipromo/models/order.dart';
import 'package:mipromo/models/shop_service.dart';
import 'package:mipromo/ui/service/service_viewmodel.dart';
import 'package:mipromo/ui/shared/helpers/Constants.dart';
import 'package:mipromo/ui/shared/helpers/enums.dart';
import 'package:mipromo/ui/shared/widgets/basic_loader.dart';
import 'package:mipromo/ui/shared/widgets/busy_loader.dart';
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
  bool isMuted = false;

  @override
  void initState() {
    super.initState();
    if (widget.service.videoUrl != null) initializePlayer();
  }

  initializePlayer() async {
    videoPlayerController = VideoPlayerController.network(widget.service.videoUrl.toString());

    chewieController = ChewieController(
      
      videoPlayerController: videoPlayerController!,
      autoInitialize: true,
      autoPlay: true,
      aspectRatio: 1,
      allowMuting: true,
      showControls: false,
      looping: true,
      allowFullScreen: true,
      fullScreenByDefault: false,
      deviceOrientationsOnEnterFullScreen: [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
      materialProgressColors: ChewieProgressColors(
        playedColor: Colors.purple,
        bufferedColor: Colors.purple.withOpacity(0.4),
      ),
    );
  }

  @override
  Future<void> dispose() async {
    videoPlayerController!.dispose();
    chewieController!.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose(); //change here
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return ViewModelBuilder<ServiceViewModel>.reactive(
      onModelReady: (model) => model.init(widget.service),
      builder: (context, model, child) => model.isBusy
          ? const BasicLoader()
          : SafeArea(
              child: Scaffold(
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
                            AspectRatio(
                              aspectRatio: 1 / 1,
                              child: PageView(
                                controller: model.viewController,
                                children: [
                                  if (widget.service.imageUrl1 != null) ...[
                                    CachedNetworkImage(
                                      imageUrl: widget.service.imageUrl1!,
                                      fit: BoxFit.fill,
                                      placeholder: (context, url) =>
                                          Center(child: SizedBox(height: 35, child: const CircularProgressIndicator())),
                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                    ),
                                  ],
                                  if (widget.service.imageUrl2 != null) ...[
                                    CachedNetworkImage(
                                      imageUrl: widget.service.imageUrl2!,
                                      fit: BoxFit.fill,
                                      placeholder: (context, url) =>
                                          Center(child: SizedBox(height: 35, child: const CircularProgressIndicator())),
                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                    ),
                                  ],
                                  if (widget.service.imageUrl3 != null) ...[
                                    CachedNetworkImage(
                                      imageUrl: widget.service.imageUrl3!,
                                      fit: BoxFit.fill,
                                      placeholder: (context, url) =>
                                          Center(child: SizedBox(height: 35, child: const CircularProgressIndicator())),
                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                    ),
                                  ],
                                  if (widget.service.videoUrl != null) ...[
                                    Stack(
                                      children: [
                                     
                                        GestureDetector(
                                            onTap: () {
                                              // chewieController!.enterFullScreen();
                                            },
                                            child: Chewie(

                                        controller: chewieController!,
                                            ),
                                          ),
                                             Align(
                                          alignment: Alignment.topRight,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Icon(Icons.videocam_sharp,color: Colors.white,size: 30,),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ]
                                ],
                              ),
                            ),
                            4.heightBox,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(model.imagesCount.length, (index) {
                                return Container(
                                  height: 8,
                                  width: 8,
                                  margin: EdgeInsets.only(left: 4),
                                  decoration: BoxDecoration(
                                      color: model.selectedIndex == index ? Color(widget.color) : Colors.grey[400],
                                      borderRadius: BorderRadius.circular(55)),
                                );
                              }),
                            ).px(20),
                            5.heightBox,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                widget.service.name.text.xl.bold
                                    //.fontFamily(fontStyle)
                                    .maxLines(2)
                                    .make()
                                    .box
                                    .width(context.screenWidth / 1.5)
                                    .make(),
                                "£${widget.service.price.toStringAsFixed(2)}".text.lg.make(),
                              ],
                            ).pOnly(top: 12, left: 20, right: 20),
                            if (widget.service.type == "Product")
                              if (widget.service.sizes == null || widget.service.sizes!.isEmpty)
                                const SizedBox.shrink()
                              else
                                Column(
                                  children: [
                                    20.heightBox,
                                    "Available Sizes".text.size(15).fontWeight(FontWeight.w600).make(),
                                    10.heightBox,
                                  ],
                                ).px(20),
                            if (widget.service.type == "Product")
                              if (widget.service.sizes == null || widget.service.sizes!.isEmpty)
                                const SizedBox.shrink()
                              else
                                Wrap(
                                  runSpacing: 7,
                                  children: List.generate(widget.service.sizes!.length, (index) {
                                    return InkWell(
                                      onTap: () {
                                        if (widget.service.ownerId == model.user.id) {
                                        } else {
                                          model.onSizeSelected(index);
                                        }
                                      },
                                      child: Container(
                                        height: 30,
                                        width: 62,
                                        margin: const EdgeInsets.only(right: 8),
                                        decoration: BoxDecoration(
                                            color: model.selectedSizeIndex == index ? Color(widget.color) : null,
                                            borderRadius: BorderRadius.circular(2),
                                            border: Border.all(
                                                color: model.selectedSizeIndex == index
                                                    ? Color(widget.color)
                                                    : Color(0xFFEEEEEE))),
                                        child: Center(
                                          child: Text(
                                            widget.service.sizes![index],
                                            style: TextStyle(
                                                color: model.selectedSizeIndex == index ? Colors.white : null,
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
                            "Item Description".text.size(15).fontWeight(FontWeight.w600).make().px(20),

                            widget.service.description!.text.color(Colors.grey).make().py8().px(20),
                            10.heightBox,
                            Row(
                              children: [
                                Image.asset('assets/icon/shield.png', scale: 10),
                                "Buyer Protection".text.color(Colors.grey).make().px4()
                              ],
                            ).px(20),
                            /*Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                "${Constants.typeLabel} : ${service.type}"
                                    .text
                                    .make(),
                                if (service.type == "Product")
                                  if (service.sizes == null ||
                                      service.sizes!.isEmpty)
                                    const SizedBox.shrink()
                                  else
                                    DropdownButton<int>(
                                      hint: Constants.sizeLabel.text.make(),
                                      underline: const SizedBox.shrink(),
                                      value: model.selectedSize,
                                      items: List<DropdownMenuItem<int>>.generate(
                                        service.sizes!.length,
                                        (index) => DropdownMenuItem(
                                          value: index,
                                          child:
                                              service.sizes![index].text.make(),
                                        ),
                                      ).toList(),
                                      onChanged: (size) {
                                        model.getSelectedSize(size!);
                                      },
                                    )
                                else
                                  const SizedBox.shrink(),
                              ],
                            ),*/
                            20.heightBox,
                            Container(
                              height: 1,
                              width: double.infinity,
                              color: Colors.grey.withOpacity(0.30),
                            ),
                            if (widget.service.ownerId != model.user.id) 20.heightBox else 5.heightBox,

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
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                  child: Row(
                    children: [
                      if (widget.service.ownerId == model.user.id)
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
                        )
                      else
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
                                      if (widget.service.sizes!.isEmpty || widget.service.sizes == null) {
                                        model.navigateToBuyServiceView();
                                      } else {
                                        model.isBuyServiceFormValidate();
                                      }
                                    },
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Row(
                                          children: const [Icon(Icons.calendar_today, size: 25, color: Colors.white)],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
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
                                      model.bookService();
                                    },
                                    color: Color(widget.color),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Row(
                                          children: const [Icon(Icons.calendar_today, size: 25, color: Colors.white)],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
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
                                        model.user.chatIds!.contains(widget.service.ownerId)) {
                                      model.navigateToDirectChatView(widget.service.ownerId);
                                      //model.navigateToChatsView();
                                    } else {
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
                                          Image.asset('assets/icon/chat.png', scale: 7),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
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
            ),
      viewModelBuilder: () => ServiceViewModel(),
    );
  }
}
