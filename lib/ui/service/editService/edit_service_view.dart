import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:helpers/helpers/misc.dart';
import 'package:helpers/helpers/widgets/text.dart';
import 'package:helpers/helpers/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/models/shop.dart';
import 'package:mipromo/models/shop_service.dart';
import 'package:mipromo/ui/service/create_service_viewmodel.dart';
import 'package:mipromo/ui/service/editService/edit_service_viewmodel.dart';
import 'package:mipromo/ui/service/inputaddress_view.dart';
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
import 'package:video_player/video_player.dart';

class EditServiceView extends StatefulWidget {
  const EditServiceView({
    Key? key,
    required this.user,
    required this.shop,
    required this.service,
  }) : super(key: key);

  final AppUser user;
  final Shop shop;
  final ShopService service;

  @override
  _EditServiceViewState createState() => _EditServiceViewState();
}

class _EditServiceViewState extends State<EditServiceView> {
  final ImagePicker _picker = ImagePicker();
  File parseToFile(file) {
    return File(file.path.toString());
  }

  String? _selectedTime;

  @override
  Widget build(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    return ViewModelBuilder<EditServiceViewModel>.reactive(
      // onModelReady: (model) =>
      //     model.init(widget.user, widget.shop, widget.service),
      builder: (context, model, child) => model.isBusy
          ? const BasicLoader()
          : Scaffold(
              appBar: AppBar(
                title: Constants.editServiceLabel.text.make(),
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
                                  builder: (context) => InputAddressView(
                                        service: widget.service,
                                      )

                                  //     VideoEditor(
                                  //   file: File(file.path),
                                  //   user: widget.user,
                                  //   shop: widget.shop,
                                  //   service: widget.service,
                                  // ),
                                  )).then((val) {
                            model.selectedVideo1 = parseToFile(val.finalFile);
                            model.videoName =
                                parseToFile(val.finalFile).path.split('/').last;
                            model.serviceAspectRatio =
                                double.parse(val.ratio.toString());

                            setState(() {});
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
                      initialValue: model.serviceName,
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
                      initialValue: model.description,
                      maxLines: null,
                      maxLength: 1000,
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
                      // if (widget.shop.category == 'Footwear & Resellers' ||
                      //     widget.shop.category == 'Clothing Brands')
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Constants.selectSizesLabel.text.gray600.make().py4(),
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
                          Constants.selectSizesLabel.text.gray600.make().py4(),
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
                      ),
                    // else
                    const SizedBox.shrink(),
                    InputField(
                      hintText: Constants.priceLabel,
                      initialValue: model.price,
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
                        maxLength: 3,
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
                    if (model.selectedType == Constants.serviceLabel) ...[
                      InputField(
                        initialValue: model.depositAmount,
                        hintText: "Deposit Amount",
                        maxLength: 5,
                        counter: "",
                        textInputType: TextInputType.number,
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(left: 10.0, top: 12),
                          child: '£'.text.lg.make(),
                        ),
                        validate: model.autoValidate,
                        validator: (depositAmount) =>
                            Validators.depositAmountValidator(
                                depositAmount, 'Deposit Amount'),
                        onChanged: (depositAmount) {
                          model.depositAmount = depositAmount;
                        },
                      ),
                    ],
                    InputField(
                      hintText: "Appointment address",
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
                        if (model.selectedType == "Service") {
                          model.confirmBeforeCreate();
                        } else {
                          model.EditService();
                        }
                      },
                    ).objectCenterRight(),
                  ],
                ),
              ),
            ),
      viewModelBuilder: () => EditServiceViewModel(),
    );
  }
}

class VideoDetails {
  final File finalFile;
  final double ratio;

  VideoDetails(this.finalFile, this.ratio);
}

class VideoEditor extends StatefulWidget {
  VideoEditor(
      {Key? key,
      required this.file,
      required this.user,
      required this.shop,
      required this.service})
      : super(key: key);

  final File file;
  final AppUser user;
  final Shop shop;
  final ShopService service;
  @override
  _VideoEditorState createState() => _VideoEditorState();
}

class _VideoEditorState extends State<VideoEditor> {
  bool isCropped = false;
  bool exportprocess = false;
  final _exportingProgress = ValueNotifier<double>(0.0);
  final _isExporting = ValueNotifier<bool>(false);
  final double height = 60;

  bool _exported = false;
  String _exportText = "";
  late VideoEditorController _controller;

  @override
  void initState() {
    _controller = VideoEditorController.file(
      widget.file,
      maxDuration: Duration(seconds: 30),
    )..initialize().then((_) => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    _exportingProgress.dispose();
    _isExporting.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _openCropScreen() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                CropScreen(controller: _controller))).then((val) {
      if (val == true) {
        setState(() {
          isCropped = true;
        });
      }
    });
  }

  Future<int> _exportVideo() async {
    _isExporting.value = true;
    setState(() {
      exportprocess = true;
    });
    bool _firstStat = true;
    // NOTE: To use `-crf 1` and [VideoExportPreset] you need `ffmpeg_kit_flutter_min_gpl` package (with `ffmpeg_kit` only it won't work)
    await _controller.exportVideo(
      // preset: VideoExportPreset.medium,
      // customInstruction: "-crf 17",
      onProgress: (statics) {
        // First statistics is always wrong so if first one skip it
        if (_firstStat) {
          _firstStat = false;
        } else {
          _exportingProgress.value = statics.getTime() /
              _controller.video.value.duration.inMilliseconds;
        }
      },
      onCompleted: (file) {
        _isExporting.value = false;

        if (!mounted) return;

        if (file != null) {
          setState(() => _exported = true);
          Misc.delayed(2000, () => setState(() => _exported = false));
          Navigator.pop(context,
              VideoDetails(file, _controller.preferredCropAspectRatio!));
        }
      },
    );
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EditServiceViewModel>.reactive(
        onModelReady: (model) =>
            model.init(widget.user, widget.shop, widget.service),
        builder: (context, model, child) => model.isBusy
            ? const BasicLoader()
            : Scaffold(
                backgroundColor: Colors.black,
                body: _controller.initialized
                    ? SafeArea(
                        child: !exportprocess
                            ? Stack(
                                children: [
                                  Column(children: [
                                    !isCropped
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                top: 18.0),
                                            child: Text(
                                                "Crop the video to continue",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                )),
                                          )
                                        : Container(),
                                    Expanded(
                                        child: DefaultTabController(
                                            length: 2,
                                            child: Column(children: [
                                              Expanded(
                                                  child: TabBarView(
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                children: [
                                                  Stack(
                                                      alignment:
                                                          Alignment.center,
                                                      children: [
                                                        CropGridViewer(
                                                          controller:
                                                              _controller,
                                                          showGrid: false,
                                                        ),
                                                        AnimatedBuilder(
                                                          animation:
                                                              _controller.video,
                                                          builder: (_, __) =>
                                                              OpacityTransition(
                                                            visible:
                                                                !_controller
                                                                    .isPlaying,
                                                            child:
                                                                GestureDetector(
                                                              onTap: _controller
                                                                  .video.play,
                                                              child: Container(
                                                                width: 40,
                                                                height: 40,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                                child: Icon(
                                                                    Icons
                                                                        .play_arrow,
                                                                    color: Colors
                                                                        .black),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ]),
                                                  CoverViewer(
                                                      controller: _controller)
                                                ],
                                              )),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Expanded(
                                                    child: GestureDetector(
                                                      onTap: () async {
                                                        isCropped
                                                            ? await _exportVideo()
                                                            : Navigator.pop(
                                                                context);
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10.0),
                                                        child: isCropped
                                                            ? Icon(
                                                                Icons.done,
                                                                color: Colors
                                                                    .white,
                                                                size: 38,
                                                              )
                                                            : Icon(
                                                                Icons.close,
                                                                color: Colors
                                                                    .white,
                                                                size: 38,
                                                              ),
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
                                                ],
                                              ),
                                            ]))),
                                  ]),
                                ],
                              )
                            : Center(child: CircularProgressIndicator()),
                      )
                    : Center(child: CircularProgressIndicator()),
              ),
        viewModelBuilder: () => EditServiceViewModel());
  }
}

//-----------------//
//CROP VIDEO SCREEN//
//-----------------//
class CropScreen extends StatelessWidget {
  const CropScreen({Key? key, required this.controller}) : super(key: key);

  final VideoEditorController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(children: [
            const SizedBox(height: 15),
            Expanded(
              child: AnimatedInteractiveViewer(
                maxScale: 2.4,
                child: CropGridViewer(controller: controller),
              ),
            ),
            const SizedBox(height: 15),
            Row(children: [
              Expanded(
                child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Center(
                    child: Text(
                      "CANCEL",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ),
              buildSplashTap("1:1", 1 / 1),
              buildSplashTap("4:5", 4 / 5,
                  padding: const EdgeInsets.symmetric(horizontal: 10)),
              Expanded(
                child: IconButton(
                  onPressed: () {
                    //2 WAYS TO UPDATE CROP
                    //WAY 1:
                    controller.updateCrop();
                    /*WAY 2:
                    controller.minCrop = controller.cacheMinCrop;
                    controller.maxCrop = controller.cacheMaxCrop;
                    */

                    if (controller.preferredCropAspectRatio == 1.0 ||
                        controller.preferredCropAspectRatio == 0.8) {
                      Navigator.pop(context, true);
                    } else {
                      Navigator.pop(context, false);
                    }
                  },
                  icon: const Center(
                    child: Text(
                      "Done",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
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
    return InkWell(
      onTap: () {
        controller.preferredCropAspectRatio = aspectRatio;
      },
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.aspect_ratio, color: Colors.white),
            Text(
              title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomPicker extends CommonPickerModel {
  String digits(int value, int length) {
    return '$value'.padLeft(length, "0");
  }

  CustomPicker({DateTime? currentTime, LocaleType? locale})
      : super(locale: locale) {
    this.currentTime = currentTime ?? DateTime.now();
    this.setLeftIndex(this.currentTime.hour);
    this.setMiddleIndex(this.currentTime.minute);
    this.setRightIndex(this.currentTime.second);
  }

  @override
  leftStringAtIndex(int index) {
    if (index >= 0 && index < 24) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  middleStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(00, 2);
    } else {
      return null;
    }
  }

  @override
  rightStringAtIndex(int index) {
    if (index >= 0 && index < 60) {
      return this.digits(index, 2);
    } else {
      return null;
    }
  }

  @override
  String leftDivider() {
    return ":";
  }

  @override
  String rightDivider() {
    return ":";
  }

  @override
  List<int> layoutProportions() {
    return [1, 1, 0];
  }

  @override
  DateTime finalTime() {
    return currentTime.isUtc
        ? DateTime.utc(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            this.currentLeftIndex(),
            this.currentMiddleIndex(),
            this.currentRightIndex())
        : DateTime(
            currentTime.year,
            currentTime.month,
            currentTime.day,
            this.currentLeftIndex(),
            this.currentMiddleIndex(),
            this.currentRightIndex());
  }
}
