import 'package:flutter/material.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mipromo/ui/shop/editShop/edit_shop_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:weekday_selector/weekday_selector.dart';

import '../../../models/shop.dart';
import '../../shared/helpers/constants.dart';
import '../../shared/helpers/swiper_controller_hook.dart';
import '../../shared/helpers/validators.dart';
import '../../shared/widgets/busy_loader.dart';
import '../../shared/widgets/inputfield.dart';

class EditShopView extends StatelessWidget {
  const EditShopView({
    Key? key,
    required this.shop,
  }) : super(key: key);

  final Shop shop;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EditShopViewModel>.reactive(
      onModelReady: (model) => model.init(shop),
      builder: (context, model, child) {
        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                backgroundColor: Color(model.selectedTheme),
                title: Constants.createShopLabel.text
                    .fontFamily(model.selectedFontStyle)
                    .make(),
                centerTitle: true,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.done),
                    onPressed: () {
                      model.createShop(shop);
                    },
                  ),
                ],
              ),
              body: const SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.all(16),
                child: _EditShopForm(),
              ),
            ),
            BusyLoader(busy: model.isBusy),
          ],
        );
      },
      viewModelBuilder: () => EditShopViewModel(),
    );
  }
}

class _EditShopForm extends HookViewModelWidget<EditShopViewModel> {
  const _EditShopForm({Key? key}) : super(key: key);

  @override
  Widget buildViewModelWidget(BuildContext context, EditShopViewModel model) {
    final swiperController = useSwiperController();
    final nameFocusNode = useFocusNode();
    final descriptionFocusNode = useFocusNode();
    final addressFocusNode = useFocusNode();
    final policyFocusNode = useFocusNode();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InputField(
          focusNode: nameFocusNode,
          hintText: "Name of your shop",
          maxLength: 30,
          validate: model.autoValidate,
          validator: (shopName) {
            return Validators.emptyStringValidator(shopName, 'Shop Name');
          },
          onChanged: (name) {
            model.shopName = name;
          },
          onEditingComplete: () {
            nameFocusNode.nextFocus();
          },
          initialValue: model.shopName,
        ),
        InputField(
          focusNode: descriptionFocusNode,
          hintText: "Describe your shop briefly",
          maxLines: 5,
          maxLength: 500,
          validator: (description) {
            return Validators.emptyStringValidator(description, 'Description');
          },
          onChanged: (description) {
            model.description = description;
          },
          initialValue: model.description,
          textInputType: TextInputType.multiline,
        ),
        InputField(
          focusNode: addressFocusNode,
          hintText: "Address of your shop (Optional)",
          maxLines: 3,
          maxLength: 100,
          textInputType: TextInputType.multiline,
          onChanged: (address) {
            model.address = address;
          },
          initialValue: model.address,
        ),
        20.heightBox,
        InputField(
          focusNode: policyFocusNode,
          hintText: "Policy of your shop ",
          maxLines: 12,
          maxLength: 8000,
          textInputType: TextInputType.multiline,
          onChanged: (policy) {
            model.policy = policy;
          },
          initialValue: model.policy,
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     "Additional appointment add-ons".text.bold.make(),
        //     Container(
        //       height: 40,
        //       width: 40,
        //       decoration: BoxDecoration(
        //           color: Color(model.selectedTheme),
        //           borderRadius: BorderRadius.all(Radius.circular(40))),
        //       child: IconButton(
        //         onPressed: () {
        //           model.displayTextField();
        //         },
        //         icon: const Icon(
        //           Icons.add,
        //           color: Colors.white,
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
 
        Visibility(
            visible: model.displayNewTextField,
            child: Column(
              children: [
                InputField(
                  hintText: 'Title',
                  validate: model.autoValidate,
                  validator: (serviceName) => Validators.emptyStringValidator(
                    serviceName,
                    'Service Name',
                  ),
                  onChanged: (name) {
                    model.extraServiceName = name;
                  },
                ),
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
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                        color: Color(model.selectedTheme),
                        borderRadius: BorderRadius.all(Radius.circular(40))),
                    child: IconButton(
                      onPressed: () {
                        model.createExtraServicesShop();
                        model.init(model.mshop);
                      },
                      icon: const Icon(
                        Icons.done,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            )),
        20.heightBox,
               ListView.builder(
            padding: EdgeInsets.all(0),
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: model.extraService!.length,
            itemBuilder: (context, index) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        //color: Colors.red,
                        //border: Border.all(color: Colors.white, width: 0.5)
                        ),
                    //height: context.screenHeight / 7,
                    width: context.screenWidth,
                    child: Card(
                      elevation: 6.0,
                      margin: new EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 8.0),
                      child: Container(
                        decoration: BoxDecoration(),
                        child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 5.0),
                            title: Text(
                              model.extraService![index].name.toString(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                            subtitle: Row(
                              children: <Widget>[
                              
                                Flexible(
                                  child: Container(
                                    child: Text(
                                        'price: £' +
                                            model.extraService![index].price
                                                .toString(),
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(color: Colors.black)),
                                  ),
                                )
                              ],
                            ),
                            trailing: GestureDetector(
                              onTap: () {
                                model.deleteExtraService(
                                    model.extraService![index].id);
                              },
                              child: Icon(Icons.delete,
                                  color: Colors.black, size: 30.0),
                            )),
                      ),
                    ),
                  ),
                  /*model.services[index].name.text
                                                .maxLines(2)
                                                .make()
                                              .pSymmetric(h: 4, v: 2),*/

                  /*"£${model.services[index].price}"
                                                .text
                                                .xs
                                                .make()
                                                .px4(),*/
                ],
              ).mdClick(() {}).make();
            }
            // },
            ),
        20.heightBox,
        "Choose your shop category".text.bold.make(),
        DropdownButton<String>(
          hint: Constants.categoryLabel.text.color(Colors.grey).make(),
          isExpanded: true,
          underline: const SizedBox.shrink(),
          value: model.selectedCategory,
          onTap: () {
            nameFocusNode.unfocus();
            descriptionFocusNode.unfocus();
            addressFocusNode.unfocus();
          },
          onChanged: (category) {
            model.getSelectedCategory(category!);
          },
          items: List.generate(
            Constants.categories.length,
            (index) => DropdownMenuItem(
              value: Constants.categories[index],
              child: Constants.categories[index].text.make(),
            ),
          ),
        ),
        15.heightBox,
        "Where is your shop located?".text.bold.make(),
        DropdownButton<String>(
          hint: Constants.locationLabel.text.color(Colors.grey).make(),
          isExpanded: true,
          value: model.selectedLocation,
          underline: const SizedBox.shrink(),
          onTap: () {
            nameFocusNode.unfocus();
            descriptionFocusNode.unfocus();
            addressFocusNode.unfocus();
          },
          onChanged: (location) {
            model.getSelectedLocation(location!);
          },
          items: List.generate(
            Constants.cities.length,
            (index) => DropdownMenuItem(
              value: Constants.cities[index],
              child: Constants.cities[index].text.make(),
            ),
          ),
        ),
        if (model.selectedLocation == "London")
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              10.heightBox,
              "Select Borough".text.bold.make(),
              DropdownButton<String>(
                hint: Constants.boroughsLabel.text.color(Colors.grey).make(),
                isExpanded: true,
                underline: const SizedBox.shrink(),
                value: model.londonBorough,
                onChanged: (borough) {
                  model.getSelectedLondonBorough(borough!);
                },
                items: List.generate(
                  Constants.londonBoroughs.length,
                  (index) => DropdownMenuItem(
                    value: Constants.londonBoroughs[index],
                    child: Constants.londonBoroughs[index].text.make(),
                  ),
                ),
                onTap: () {
                  nameFocusNode.unfocus();
                  descriptionFocusNode.unfocus();
                  addressFocusNode.unfocus();
                },
              ),
            ],
          )
        else if (model.selectedLocation == "Hertfordshire")
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              10.heightBox,
              "Select Borough".text.bold.make(),
              DropdownButton<String>(
                hint: Constants.boroughsLabel.text.color(Colors.grey).make(),
                isExpanded: true,
                underline: const SizedBox.shrink(),
                value: model.hertfordshireBorough,
                onChanged: (borough) {
                  model.getSelectedHertfordshireBorough(borough!);
                },
                items: List.generate(
                  Constants.hertfordshireBoroughs.length,
                  (index) => DropdownMenuItem(
                    value: Constants.hertfordshireBoroughs[index],
                    child: Constants.hertfordshireBoroughs[index].text.make(),
                  ),
                ),
                onTap: () {
                  nameFocusNode.unfocus();
                  descriptionFocusNode.unfocus();
                  addressFocusNode.unfocus();
                },
              ),
            ],
          )
        else
          const SizedBox.shrink(),
        10.heightBox,
        /*"Choose a font style for your shop".text.bold.make(),
        DropdownButton<String>(
          hint: Constants.fontLabel.text.gray500.make(),
          isExpanded: true,
          underline: const SizedBox.shrink(),
          value: model.selectedFontStyle,
          onChanged: (fontStyle) {
            model.getSelectedFont(fontStyle!);
          },
          items: List.generate(
            Constants.fontstyle.length,
            (index) => DropdownMenuItem(
              value: Constants.fontstyle[index],
              child: Constants.fontstyle[index].text
                  .fontFamily(
                    Constants.fontstyle[index],
                  )
                  .make(),
            ),
          ),
          onTap: () {
            nameFocusNode.unfocus();
            descriptionFocusNode.unfocus();
            addressFocusNode.unfocus();
          },
        ),
        10.heightBox,*/
        "Choose a theme for your shop".text.bold.make(),
        SizedBox(
          height: context.screenHeight / 4.5,
          child: Swiper(
            controller: swiperController,
            physics: const BouncingScrollPhysics(),
            viewportFraction: 0.36,
            scale: 0.2,
            loop: false,
            itemCount: model.colors.length,
            // index: model.swiperIndex,
            onTap: (index) {
              swiperController.move(index);
              model.onColorChanged(
                model.colors[index],
                index,
              );

              nameFocusNode.unfocus();
              descriptionFocusNode.unfocus();
              addressFocusNode.unfocus();
            },
            itemBuilder: (context, index) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Color(model.colors[index]),
                    )
                        .p4()
                        .card
                        .white
                        .elevation(12)
                        .withRounded(value: 100)
                        .make()
                        .centered(),
                    if (model.selectedTheme == model.colors[index])
                      const Icon(
                        Icons.check,
                        color: Colors.white,
                      )
                    else
                      const SizedBox.shrink(),
                  ],
                ),
                if (model.colors[index] == model.colors.first)
                  "Default".text.make().pOnly(top: 12)
                else
                  const SizedBox.shrink()
              ],
            ),
          ),
        ),
      ],
    );
  }
}
