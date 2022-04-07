import 'package:flutter/material.dart';
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

class CreateServiceView extends StatelessWidget {
  const CreateServiceView({
    Key? key,
    required this.user,
    required this.shop,
  }) : super(key: key);

  final AppUser user;
  final Shop shop;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CreateServiceViewModel>.reactive(
      onModelReady: (model) => model.init(user, shop),
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
                        itemCount: model.images.length < 3 ? model.images.length + 1 : model.images.length,
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
                                  'Add Image'.text.color(Styles.kcPrimaryColor).make(),
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
                      onTap: () {
                        model.selectVideo();
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Icon(Icons.add,color: Styles.kcPrimaryColor,),
                          ),
                          Text("Add Video",style: TextStyle(color: Styles.kcPrimaryColor,fontWeight: FontWeight.bold),),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.6,
                            child: Padding(
                              padding: const EdgeInsets.only(left:8.0),
                              child: Text(model.videoName == null ? 'no video selected' : model.videoName.toString(),maxLines: 2,style: TextStyle(color: Colors.grey),),
                            ),
                          )
                        ],
                      ),
                    ),
                    InputField(
                      hintText: Constants.serviceNameLabel,
                      validate: model.autoValidate,
                      validator: (serviceName) => Validators.emptyStringValidator(
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
                      validator: (description) => Validators.emptyStringValidator(
                        description,
                        'Description',
                      ),
                      onChanged: (description) {
                        model.description = description;
                      },
                    ),
                    DropdownButtonFormField<String>(
                      autovalidateMode:
                          model.autoValidate ? AutovalidateMode.always : AutovalidateMode.onUserInteraction,
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
                      if (shop.category == 'Trainers' || shop.category == 'Clothing')
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
                      validator: (price) => Validators.emptyStringValidator(price, 'Price'),
                      onChanged: (price) {
                        model.price = price;
                      },
                    ),
                    if (model.selectedType == Constants.serviceLabel)
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
