import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/ui/shared/helpers/constants.dart';
import 'package:mipromo/ui/shared/helpers/swiper_controller_hook.dart';
import 'package:mipromo/ui/shared/helpers/validators.dart';
import 'package:mipromo/ui/shared/widgets/busy_loader.dart';
import 'package:mipromo/ui/shared/widgets/inputfield.dart';
import 'package:mipromo/ui/shop/create_shop_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_hooks/stacked_hooks.dart';
import 'package:velocity_x/velocity_x.dart';

class CreateShopView extends StatelessWidget {
  const CreateShopView({
    Key? key,
    required this.user,
  }) : super(key: key);

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CreateShopViewModel>.reactive(
      onModelReady: (model) => model.init(user),
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
                      model.createShop();
                    },
                  ),
                ],
              ),
              body: const SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.all(16),
                child: _CreateShopForm(),
              ),
            ),
            BusyLoader(busy: model.isBusy),
          ],
        );
      },
      viewModelBuilder: () => CreateShopViewModel(),
    );
  }
}

class _CreateShopForm extends HookViewModelWidget<CreateShopViewModel> {
  const _CreateShopForm({Key? key}) : super(key: key);

  @override
  Widget buildViewModelWidget(BuildContext context, CreateShopViewModel model) {
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
        "Where is your shop located?".text.bold.make(),
        _SearchLocations(),
        if (model.searchedLocations.isNotEmpty) ...[
          ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: model.searchedLocations.length,
            itemBuilder: (context, index) => RadioListTile<String>(
              value: model.searchedLocations[index],
              groupValue: model.hasBorough
                  ? model.selectedBorough
                  : model.selectedLocation,
              onChanged: (v) {
                if (Constants.hertfordshireBoroughs.contains(v)) {
                  model.hasBorough = true;
                  model.selectedBorough = v;
                  model.selectedLocation = 'Hertfordshire';
                  model.notifyListeners();
                } else if (Constants.londonBoroughs.contains(v)) {
                  model.hasBorough = true;
                  model.selectedBorough = v;
                  model.selectedLocation = 'London';
                  model.notifyListeners();
                } else {
                  model.hasBorough = false;
                  model.selectedLocation = v;
                  model.notifyListeners();
                }
              },
              title: Text(model.searchedLocations[index]),
            ),
          ),
        ],
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
        CarouselSlider(
          options: CarouselOptions(
            height: context.screenHeight / 4.5,
            onPageChanged: (index, reason) {
              swiperController.move(index);
              model.onColorChanged(
                model.colors[index],
                index,
              );

              nameFocusNode.unfocus();
              descriptionFocusNode.unfocus();
              addressFocusNode.unfocus();
            },
            viewportFraction: 0.3,
            enableInfiniteScroll: false,
          ),
          items: List.generate(
            model.colors.length,
            (index) => GestureDetector(
              onTap: () {
                swiperController.move(index);
                model.onColorChanged(
                  model.colors[index],
                  index,
                );

                nameFocusNode.unfocus();
                descriptionFocusNode.unfocus();
                addressFocusNode.unfocus();
              },
              child: Column(
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
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SearchLocations extends HookViewModelWidget<CreateShopViewModel> {
  @override
  Widget buildViewModelWidget(
    BuildContext context,
    CreateShopViewModel model,
  ) {
    final TextEditingController controller = useTextEditingController();

    return Card(
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Search location',
          border: InputBorder.none,
          isCollapsed: true,
          suffix: const Icon(
            Icons.close,
            size: 14,
          ).onInkTap(
            () {
              controller.clear();
              model.onLocationsSearchTextChanged('');
            },
          ),
        ),
        onChanged: model.onLocationsSearchTextChanged,
      ).p8(),
    ).pLTRB(12, 12, 12, 0);
  }
}
