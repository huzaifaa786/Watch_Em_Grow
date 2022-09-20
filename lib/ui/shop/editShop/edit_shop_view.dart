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
                title: Constants.createShopLabel.text.fontFamily(model.selectedFontStyle).make(),
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
        10.heightBox,
        "Mark your availabilty".text.bold.make(),
        10.heightBox,

        WeekdaySelector(
          firstDayOfWeek: 1,
          onChanged: (int day) {
            final index = day % 7;
            model.selection(index);
          },
          values: model.values,
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
                    ).p4().card.white.elevation(12).withRounded(value: 100).make().centered(),
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
