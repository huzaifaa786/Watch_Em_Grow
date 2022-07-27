import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:helpers/helpers/widgets/text.dart';
import 'package:helpers/helpers/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/models/shop.dart';
import 'package:mipromo/ui/service/create_service_viewmodel.dart';
import 'package:mipromo/ui/shared/helpers/constants.dart';
import 'package:mipromo/ui/shared/helpers/styles.dart';
import 'package:mipromo/ui/shared/helpers/validators.dart';
import 'package:mipromo/ui/shared/widgets/basic_loader.dart';
import 'package:mipromo/ui/shared/widgets/busy_button.dart';
import 'package:mipromo/ui/shared/widgets/inputfield.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:video_editor/domain/bloc/controller.dart';
import 'package:video_editor/ui/cover/cover_selection.dart';
import 'package:video_editor/ui/cover/cover_viewer.dart';
import 'package:video_editor/ui/crop/crop_grid.dart';
import 'package:helpers/helpers.dart'
    show OpacityTransition, SwipeTransition, AnimatedInteractiveViewer;
import 'package:video_editor/ui/trim/trim_slider.dart';
import 'package:video_editor/ui/trim/trim_timeline.dart';

class CreateServiceView extends StatefulWidget {
  const CreateServiceView({
    Key? key,
    required this.user,
    required this.shop,
  }) : super(key: key);

  final AppUser user;
  final Shop shop;

  @override
  _CreateServiceViewState createState() => _CreateServiceViewState();
}

class _CreateServiceViewState extends State<CreateServiceView> {
  final ImagePicker _picker = ImagePicker();
  File parseToFile(file) {
    return File(file.path.toString());
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CreateServiceViewModel>.reactive(
      onModelReady: (model) => model.init(widget.user, widget.shop),
      builder: (context, model, child) => model.isBusy
          ? const BasicLoader()
          : Scaffold(
              appBar: AppBar(
                title: Constants.addServiceLabel.text.make(),
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: context.screenHeight / 2.5,
                      width: context.screenWidth,
                      child: PageView.builder(
                        itemCount: model.images.length < 3
                            ? model.images.length + 1
                            : model.images.length,
                        itemBuilder: (context, index) {
                          if (index == model.images.length) {
                            return SizedBox(
                              width: context.screenWidth,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.add,
                                    color: Styles.kcPrimaryColor,
                                  ),
                                  'Add Image'
                                      .text
                                      .color(Styles.kcPrimaryColor)
                                      .make(),
                                ],
                              ).mdClick(
                                () {
                                  if (model.finalImage1 == null) {
                                    model.selectImage1();
                                  } else {
                                    if (model.finalImage2 == null) {
                                      model.selectImage2();
                                    } else {
                                      model.selectImage3();
                                    }
                                  }
                                },
                              ).make(),
                            );
                          }

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Image.file(
                                  model.images[index],
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  model.removeImage(model.images[index], index);
                                },
                                child: 'Remove'.text.make(),
                              ),
                              const Text(
                                'Swipe left to add more images >>>',
                                style: TextStyle(color: Colors.grey),
                              ).shimmer()
                            ],
                          );
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final PickedFile? file =
                            await _picker.getVideo(source: ImageSource.gallery);

                        if (file != null) {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoEditor(
                                file: File(file.path),
                                user: widget.user,
                                shop: widget.shop,
                              ),
                            ),
                          ).then((val) {
                            print(val);
                            model.selectedVideo1 = parseToFile(val);
                          });
                        }
                      },
                      // model.selectVideo();

                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Icon(
                              Icons.add,
                              color: Styles.kcPrimaryColor,
                            ),
                          ),
                          Text(
                            "Add Video",
                            style: TextStyle(
                                color: Styles.kcPrimaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                model.videoName == null
                                    ? 'no video selected'
                                    : model.videoName.toString(),
                                maxLines: 2,
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    InputField(
                      hintText: Constants.serviceNameLabel,
                      validate: model.autoValidate,
                      validator: (serviceName) =>
                          Validators.emptyStringValidator(
                        serviceName,
                        'Service Name',
                      ),
                      onChanged: (name) {
                        model.serviceName = name;
                      },
                    ),
                    InputField(
                      hintText: Constants.descriptionLabel,
                      validate: model.autoValidate,
                      maxLines: null,
                      maxLength: 150,
                      counter: '',
                      textInputType: TextInputType.multiline,
                      validator: (description) =>
                          Validators.emptyStringValidator(
                        description,
                        'Description',
                      ),
                      onChanged: (description) {
                        model.description = description;
                      },
                    ),
                    DropdownButtonFormField<String>(
                      autovalidateMode: model.autoValidate
                          ? AutovalidateMode.always
                          : AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration.collapsed(
                        hintText: 'Type',
                      ),
                      validator: (value) => Validators.emptyStringValidator(
                        value,
                        'Service Type',
                      ),
                      value: model.selectedType,
                      onChanged: (type) {
                        model.getSelectedType(type!);
                      },
                      items: <DropdownMenuItem<String>>[
                        DropdownMenuItem(
                          value: Constants.serviceLabel,
                          child: Constants.serviceLabel.text.make(),
                        ),
                        DropdownMenuItem(
                          value: Constants.productLabel,
                          child: Constants.productLabel.text.make(),
                        ),
                      ],
                    )
                        .p12()
                        .centered()
                        .box
                        .border(color: Colors.grey)
                        .height(55)
                        .withRounded(value: 12)
                        //.color(Colors.grey.shade800)
                        .make()
                        .pSymmetric(
                          v: 12,
                        ),
                    if (model.selectedType == Constants.productLabel)
                      if (widget.shop.category == 'Trainers' ||
                          widget.shop.category == 'Clothing')
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Constants.selectSizesLabel.text.gray600
                                .make()
                                .py4(),
                            Wrap(
                              spacing: 10,
                              children: [
                                FilterChip(
                                  selectedColor: Colors.lightBlue.shade100,
                                  selected: model.oneSize,
                                  label: '1'.text.sm.make(),
                                  onSelected: (value) {
                                    model.oneSize = value;
                                    model.selectedSizes('1');
                                  },
                                ),
                                FilterChip(
                                  selectedColor: Colors.lightBlue.shade100,
                                  selected: model.twoSize,
                                  label: '2'.text.sm.make(),
                                  onSelected: (value) {
                                    model.twoSize = value;
                                    model.selectedSizes('2');
                                  },
                                ),
                                FilterChip(
                                  selectedColor: Colors.lightBlue.shade100,
                                  selected: model.threeSize,
                                  label: '3'.text.sm.make(),
                                  onSelected: (value) {
                                    model.threeSize = value;
                                    model.selectedSizes('3');
                                  },
                                ),
                                FilterChip(
                                  selectedColor: Colors.lightBlue.shade100,
                                  selected: model.fourSize,
                                  label: '4'.text.sm.make(),
                                  onSelected: (value) {
                                    model.fourSize = value;
                                    model.selectedSizes('4');
                                  },
                                ),
                                FilterChip(
                                  selectedColor: Colors.lightBlue.shade100,
                                  selected: model.fiveSize,
                                  label: '5'.text.sm.make(),
                                  onSelected: (value) {
                                    model.fiveSize = value;
                                    model.selectedSizes('5');
                                  },
                                ),
                                FilterChip(
                                  selectedColor: Colors.lightBlue.shade100,
                                  selected: model.sixSize,
                                  label: '6'.text.sm.make(),
                                  onSelected: (value) {
                                    model.sixSize = value;
                                    model.selectedSizes('6');
                                  },
                                ),
                                FilterChip(
                                  selectedColor: Colors.lightBlue.shade100,
                                  selected: model.sevenSize,
                                  label: '7'.text.sm.make(),
                                  onSelected: (value) {
                                    model.sevenSize = value;
                                    model.selectedSizes('7');
                                  },
                                ),
                                FilterChip(
                                  selectedColor: Colors.lightBlue.shade100,
                                  selected: model.eightSize,
                                  label: '8'.text.sm.make(),
                                  onSelected: (value) {
                                    model.eightSize = value;
                                    model.selectedSizes('8');
                                  },
                                ),
                                FilterChip(
                                  selectedColor: Colors.lightBlue.shade100,
                                  selected: model.nineSize,
                                  label: '9'.text.sm.make(),
                                  onSelected: (value) {
                                    model.nineSize = value;
                                    model.selectedSizes('9');
                                  },
                                ),
                                FilterChip(
                                  selectedColor: Colors.lightBlue.shade100,
                                  selected: model.tenSize,
                                  label: '10'.text.sm.make(),
                                  onSelected: (value) {
                                    model.tenSize = value;
                                    model.selectedSizes('10');
                                  },
                                ),
                                FilterChip(
                                  selectedColor: Colors.lightBlue.shade100,
                                  selected: model.elevenSize,
                                  label: '11'.text.sm.make(),
                                  onSelected: (value) {
                                    model.elevenSize = value;
                                    model.selectedSizes('11');
                                  },
                                ),
                                FilterChip(
                                  selectedColor: Colors.lightBlue.shade100,
                                  selected: model.twelveSize,
                                  label: '12'.text.sm.make(),
                                  onSelected: (value) {
                                    model.twelveSize = value;
                                    model.selectedSizes('12');
                                  },
                                ),
                                FilterChip(
                                  selectedColor: Colors.lightBlue.shade100,
                                  selected: model.thirteenSize,
                                  label: '13'.text.sm.make(),
                                  onSelected: (value) {
                                    model.thirteenSize = value;
                                    model.selectedSizes('13');
                                  },
                                ),
                                FilterChip(
                                  selectedColor: Colors.lightBlue.shade100,
                                  selected: model.fourteenSize,
                                  label: '14'.text.sm.make(),
                                  onSelected: (value) {
                                    model.fourteenSize = value;
                                    model.selectedSizes('14');
                                  },
                                ),
                              ],
                            ),
                            Wrap(
                              spacing: 10,
                              children: [
                                FilterChip(
                                  selectedColor: Colors.lightBlue.shade100,
                                  selected: model.xsValue,
                                  label: Constants.xsLabel.text.sm.make(),
                                  onSelected: (value) {
                                    if (model.onesizeValue) {
                                    } else {
                                      model.xsValue = value;
                                      model.selectedSizes(Constants.xsLabel);
                                    }
                                  },
                                ),
                                FilterChip(
                                  selectedColor: Colors.lightBlue.shade100,
                                  selected: model.sValue,
                                  label: Constants.sLabel.text.sm.make(),
                                  onSelected: (value) {
                                    if (model.onesizeValue) {
                                    } else {
                                      model.sValue = value;
                                      model.selectedSizes(Constants.sLabel);
                                    }
                                  },
                                ),
                                FilterChip(
                                  selectedColor: Colors.lightBlue.shade100,
                                  selected: model.mValue,
                                  label: Constants.mLabel.text.sm.make(),
                                  onSelected: (value) {
                                    if (model.onesizeValue) {
                                    } else {
                                      model.mValue = value;
                                      model.selectedSizes(Constants.mLabel);
                                    }
                                  },
                                ),
                                FilterChip(
                                  selectedColor: Colors.lightBlue.shade100,
                                  selected: model.lValue,
                                  label: Constants.lLabel.text.sm.make(),
                                  onSelected: (value) {
                                    if (model.onesizeValue) {
                                    } else {
                                      model.lValue = value;
                                      model.selectedSizes(Constants.lLabel);
                                    }
                                  },
                                ),
                                FilterChip(
                                  selectedColor: Colors.lightBlue.shade100,
                                  selected: model.xlValue,
                                  label: Constants.xlLabel.text.sm.make(),
                                  onSelected: (value) {
                                    if (model.onesizeValue) {
                                    } else {
                                      model.xlValue = value;
                                      model.selectedSizes(Constants.xlLabel);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        )
                      else
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Constants.selectSizesLabel.text.gray600
                                .make()
                                .py4(),
                            Wrap(
                              spacing: 10,
                              children: [
                                FilterChip(
                                  selectedColor: Colors.lightBlue.shade100,
                                  selected: model.onesizeValue,
                                  label: Constants.onesizeLabel.text.sm.make(),
                                  onSelected: (value) {
                                    if (model.xsValue ||
                                        model.sValue ||
                                        model.mValue ||
                                        model.lValue ||
                                        model.xlValue ||
                                        model.xxlValue) {
                                    } else {
                                      model.onesizeValue = value;
                                      model.selectedSizes(
                                        Constants.onesizeLabel,
                                      );
                                    }
                                  },
                                ),
                                FilterChip(
                                  selectedColor: Colors.lightBlue.shade100,
                                  selected: model.xsValue,
                                  label: Constants.xsLabel.text.sm.make(),
                                  onSelected: (value) {
                                    if (model.onesizeValue) {
                                    } else {
                                      model.xsValue = value;
                                      model.selectedSizes(Constants.xsLabel);
                                    }
                                  },
                                ),
                                FilterChip(
                                  selectedColor: Colors.lightBlue.shade100,
                                  selected: model.sValue,
                                  label: Constants.sLabel.text.sm.make(),
                                  onSelected: (value) {
                                    if (model.onesizeValue) {
                                    } else {
                                      model.sValue = value;
                                      model.selectedSizes(Constants.sLabel);
                                    }
                                  },
                                ),
                                FilterChip(
                                  selectedColor: Colors.lightBlue.shade100,
                                  selected: model.mValue,
                                  label: Constants.mLabel.text.sm.make(),
                                  onSelected: (value) {
                                    if (model.onesizeValue) {
                                    } else {
                                      model.mValue = value;
                                      model.selectedSizes(Constants.mLabel);
                                    }
                                  },
                                ),
                                FilterChip(
                                  selectedColor: Colors.lightBlue.shade100,
                                  selected: model.lValue,
                                  label: Constants.lLabel.text.sm.make(),
                                  onSelected: (value) {
                                    if (model.onesizeValue) {
                                    } else {
                                      model.lValue = value;
                                      model.selectedSizes(Constants.lLabel);
                                    }
                                  },
                                ),
                                FilterChip(
                                  selectedColor: Colors.lightBlue.shade100,
                                  selected: model.xlValue,
                                  label: Constants.xlLabel.text.sm.make(),
                                  onSelected: (value) {
                                    if (model.onesizeValue) {
                                    } else {
                                      model.xlValue = value;
                                      model.selectedSizes(Constants.xlLabel);
                                    }
                                  },
                                ),
                                FilterChip(
                                  selectedColor: Colors.lightBlue.shade100,
                                  selected: model.xxlValue,
                                  label: Constants.xxlLabel.text.sm.make(),
                                  onSelected: (value) {
                                    if (model.onesizeValue) {
                                    } else {
                                      model.xxlValue = value;
                                      model.selectedSizes(Constants.xxlLabel);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        )
                    else
                      const SizedBox.shrink(),
                    InputField(
                      hintText: Constants.priceLabel,
                      maxLength: 5,
                      counter: "",
                      textInputType: TextInputType.number,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(left: 10.0, top: 12),
                        child: '£'.text.lg.make(),
                      ),
                      validate: model.autoValidate,
                      validator: (price) =>
                          Validators.emptyStringValidator(price, 'Price'),
                      onChanged: (price) {
                        model.price = price;
                      },
                    ),
                    if (model.selectedType == Constants.serviceLabel)
                      InputField(
                        hintText: "Duration/min",
                        maxLength: 60,
                        counter: "",
                        controller: model.durationController,
                        textInputType: TextInputType.number,
                        validate: model.autoValidate,
                        validator: (duration) =>
                            Validators.emptyStringValidator(
                          duration,
                          'Duration',
                        ),
                      ),
                    if (model.selectedType == Constants.serviceLabel)
                      InputField(
                        hintText: "Bookings available from the hours",
                        maxLength: 24,
                        counter: "",
                        controller: model.startController,
                        textInputType: TextInputType.number,
                        validate: model.autoValidate,
                        validator: (startHour) =>
                            Validators.emptyStringValidator(
                          startHour,
                          'Bookings available from',
                        ),
                      ),
                    if (model.selectedType == Constants.serviceLabel)
                      InputField(
                        hintText: "Booking available till",
                        maxLength: 24,
                        counter: "",
                        controller: model.endController,
                        textInputType: TextInputType.number,
                        validate: model.autoValidate,
                        validator: (endHour) => Validators.emptyStringValidator(
                          endHour,
                          'Booking available till',
                        ),
                      ),
                    InputField(
                      hintText: "Appointment note",
                      //maxLength: 5,
                      counter: "",
                      controller: model.noteController,
                      textInputType: TextInputType.text,
                      validate: false,
                    ),
                    BusyButton(
                      busy: model.isBusy,
                      icon: Icons.done,
                      onPressed: () {
                        model.createService();
                      },
                    ).objectCenterRight(),
                  ],
                ),
              ),
            ),
      viewModelBuilder: () => CreateServiceViewModel(),
    );
  }
}

class VideoEditor extends StatefulWidget {
  VideoEditor(
      {Key? key, required this.file, required this.user, required this.shop})
      : super(key: key);

  final File file;
  final AppUser user;
  final Shop shop;
  @override
  _VideoEditorState createState() => _VideoEditorState();
}

class _VideoEditorState extends State<VideoEditor> {
  final _exportingProgress = ValueNotifier<double>(0.0);
  final _isExporting = ValueNotifier<bool>(false);
  final double height = 60;

  bool _exported = false;
  String _exportText = "";
  late VideoEditorController _controller;

  @override
  void initState() {
    _controller = VideoEditorController.file(widget.file,
        maxDuration: Duration(seconds: 30))
      ..initialize().then((_) => setState(() {}));

    super.initState();
  }

  @override
  void dispose() {
    _exportingProgress.dispose();
    _isExporting.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _openCropScreen() => Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => CropScreen(controller: _controller)));

  _exportVideo() async {
    Future.delayed(
        Duration(milliseconds: 1000), () => _isExporting.value = true);
    //NOTE: To use [-crf 17] and [VideoExportPreset] you need ["min-gpl-lts"] package
    File? file = await _controller.exportVideo(
      // preset: VideoExportPreset.ultrafast,
      // customInstruction: "-crf 17",
      onProgress: (statics) {
        _exportingProgress.value =
            statics.time / _controller.video.value.duration.inMilliseconds;
      },
    );
    _isExporting.value = false;
    log('dccccccccccccccccccccccccccc');

    if (file != null) {
      print(file);
      _exportText = "Video success export!";
      _controller =
          VideoEditorController.file(file, maxDuration: Duration(seconds: 30));
    } else
      _exportText = "Error on export video :(";

    setState(() => _exported = true);
    Future.delayed(
        Duration(milliseconds: 1000), () => setState(() => _exported = false));
  }

  void _exportCover() async {
    setState(() => _exported = false);
    final File? cover = await _controller.extractCover();

    if (cover != null)
      _exportText = "Cover exported! ${cover.path}";
    else
      _exportText = "Error on cover exportation :(";

    setState(() => _exported = true);
    Future.delayed(
        Duration(milliseconds: 2000), () => setState(() => _exported = false));
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CreateServiceViewModel>.reactive(
        onModelReady: (model) => model.init(widget.user, widget.shop),
        builder: (context, model, child) => model.isBusy
            ? const BasicLoader()
            : Scaffold(
                backgroundColor: Colors.black,
                body: _controller.initialized
                    ? SafeArea(
                        child: Stack(children: [
                        Column(children: [
                          Expanded(
                              child: DefaultTabController(
                                  length: 2,
                                  child: Column(children: [
                                    Expanded(
                                        child: TabBarView(
                                      physics: NeverScrollableScrollPhysics(),
                                      children: [
                                        Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              CropGridViewer(
                                                controller: _controller,
                                                showGrid: false,
                                              ),
                                              AnimatedBuilder(
                                                animation: _controller.video,
                                                builder: (_, __) =>
                                                    OpacityTransition(
                                                  visible:
                                                      !_controller.isPlaying,
                                                  child: GestureDetector(
                                                    onTap:
                                                        _controller.video.play,
                                                    child: Container(
                                                      width: 40,
                                                      height: 40,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Icon(
                                                          Icons.play_arrow,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ]),
                                        CoverViewer(controller: _controller)
                                      ],
                                    )),
                                    // Container(
                                    //     height: 200,
                                    //     child: Column(children: [
                                    //       TabBar(
                                    //         indicatorColor: Colors.white,
                                    //         tabs: [
                                    //           Row(
                                    //               mainAxisAlignment: MainAxisAlignment.center,
                                    //               children: [Icon(Icons.content_cut), Text('Trim')]),
                                    //           Row(
                                    //               mainAxisAlignment: MainAxisAlignment.center,
                                    //               children: [Icon(Icons.video_label), Text('Cover')]),
                                    //         ],
                                    //       ),
                                    //       Expanded(
                                    //         child: TabBarView(
                                    //           children: [
                                    //             Container(
                                    //                 child: Column(
                                    //                     mainAxisAlignment: MainAxisAlignment.center, children: _trimSlider())),
                                    //             Container(
                                    //               child: Column(
                                    //                   mainAxisAlignment: MainAxisAlignment.center, children: [_coverSelection()]),
                                    //             ),
                                    //           ],
                                    //         ),
                                    //       )
                                    //     ])),
                                    // _customSnackBar(),
                                    // ValueListenableBuilder(
                                    //   valueListenable: _isExporting,
                                    //   builder: (_, bool export, __) => AlertDialog(
                                    //     backgroundColor: Colors.white,
                                    //     title: ValueListenableBuilder(
                                    //       valueListenable: _exportingProgress,
                                    //       builder: (_, double value, __) => TextDesigned(
                                    //         "Exporting video ${(value * 100).ceil()}%",
                                    //         color: Colors.black,
                                    //         bold: true,
                                    //       ),
                                    //     ),
                                    //   ),
                                    // )
                                    // _topNavBar(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        // Expanded(
                                        //   child: GestureDetector(
                                        //     onTap: () => _controller.rotate90Degrees(RotateDirection.left),
                                        //     child: Icon(Icons.rotate_left),
                                        //   ),
                                        // ),
                                        // Expanded(
                                        //   child: GestureDetector(
                                        //     onTap: () => _controller.rotate90Degrees(RotateDirection.right),
                                        //     child: Icon(Icons.rotate_right),
                                        //   ),
                                        // ),
                                        // Padding(padding: EdgeInsets.all(10),child: ,),

                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () async {
                                             await _exportVideo();
                                              // model.selectVideo(_controller.file);
                                              // model.selectedVideo1 = _controller.file;
                                              // print(_controller.preferredCropAspectRatio);
                                              Navigator.pop(context, _controller.file);
                                            },
                                            child: Icon(
                                              Icons.download,
                                              color: Colors.white,
                                              size: 38,
                                            ),
                                          ),
                                        ),

                                        Expanded(
                                          child: GestureDetector(
                                            onTap: _openCropScreen,
                                            child: Icon(
                                              Icons.crop,
                                              color: Colors.white,
                                              size: 38,
                                            ),
                                          ),
                                        ),
                                        // Expanded(
                                        //   child: GestureDetector(
                                        //     onTap: _exportCover,
                                        //     child: Icon(Icons.save_alt, color: Colors.white),
                                        //   ),
                                        // ),
                                        // Expanded(
                                        //   child: GestureDetector(
                                        //     onTap: _exportVideo,
                                        //     child: Icon(Icons.save),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ])))
                        ])
                      ]))
                    : Center(child: CircularProgressIndicator()),
              ),
        viewModelBuilder: () => CreateServiceViewModel());
  }

  // Widget _topNavBar() {
  //   return SafeArea(
  //     child: SizedBox(
  //       height: height,
  //       child:
  //     ),
  //   );
  // }

  String formatter(Duration duration) => [
        duration.inMinutes.remainder(60).toString().padLeft(2, '0'),
        duration.inSeconds.remainder(60).toString().padLeft(2, '0')
      ].join(":");

  List<Widget> _trimSlider() {
    return [
      AnimatedBuilder(
        animation: _controller.video,
        builder: (_, __) {
          final duration = _controller.video.value.duration.inSeconds;
          final pos = _controller.trimPosition * duration;
          final start = _controller.minTrim * duration;
          final end = _controller.maxTrim * duration;

          return Row(children: [
            TextDesigned(formatter(Duration(seconds: pos.toInt()))),
            Expanded(child: SizedBox()),
            OpacityTransition(
              visible: _controller.isTrimming,
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                TextDesigned(formatter(Duration(seconds: start.toInt()))),
                SizedBox(width: 10),
                TextDesigned(formatter(Duration(seconds: end.toInt()))),
              ]),
            )
          ]);
        },
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        child: TrimSlider(
            child: TrimTimeline(
                controller: _controller, margin: EdgeInsets.only(top: 10)),
            controller: _controller,
            height: height,
            horizontalMargin: height / 4),
      )
    ];
  }

  Widget _coverSelection() {
    return Container(
        child: CoverSelection(
      controller: _controller,
      height: height,
      nbSelection: 8,
    ));
  }

  Widget _customSnackBar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SwipeTransition(
        visible: _exported,
        child: Container(
          height: height,
          width: double.infinity,
          color: Colors.black.withOpacity(0.8),
          child: Center(
            child: TextDesigned(
              _exportText,
              bold: true,
            ),
          ),
        ),
      ),
    );
  }
}

//-----------------//
//CROP VIDEO SCREEN//
//-----------------//
class CropScreen extends StatefulWidget {
  CropScreen({Key? key, required this.controller}) : super(key: key);

  final VideoEditorController controller;

  @override
  _CropScreenState createState() => _CropScreenState();
}

class _CropScreenState extends State<CropScreen> {
  @override
  void initState() {
    widget.controller.preferredCropAspectRatio = 1 / 1;
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(children: [
            Expanded(
              child: AnimatedInteractiveViewer(
                maxScale: 2.4,
                child: CropGridViewer(controller: widget.controller),
              ),
            ),
            SizedBox(height: 15),
            Row(children: [
              Expanded(
                child: SplashTap(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Center(
                    child: TextDesigned(
                      "CANCEL",
                      bold: true,
                    ),
                  ),
                ),
              ),
              buildSplashTap("1:1", 1 / 1),
              buildSplashTap("4:5", 4 / 5, padding: EdgeInsets.only(right: 10)),
              Expanded(
                child: SplashTap(
                  onTap: () {
                    //2 WAYS TO UPDATE CROP
                    //WAY 1:
                    widget.controller.updateCrop();
                    /*WAY 2:
                    controller.minCrop = controller.cacheMinCrop;
                    controller.maxCrop = controller.cacheMaxCrop;
                    */
                    Navigator.pop(context);
                  },
                  child: Center(
                    child: TextDesigned(
                      "Crop",
                      bold: true,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ]),
          ]),
        ),
      ),
    );
  }

  Widget buildSplashTap(
    String title,
    double? aspectRatio, {
    EdgeInsetsGeometry? padding,
  }) {
    return SplashTap(
      onTap: () => widget.controller.preferredCropAspectRatio = aspectRatio,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.aspect_ratio, color: Colors.white),
            TextDesigned(title, bold: true, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
