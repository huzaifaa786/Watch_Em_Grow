import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/ui/profile/seller/editProfile/seller_edit_profile_viewmodel.dart';
import 'package:mipromo/ui/shared/helpers/constants.dart';
import 'package:mipromo/ui/shared/helpers/validators.dart';
import 'package:mipromo/ui/shared/widgets/basic_loader.dart';
import 'package:mipromo/ui/shared/widgets/busy_loader.dart';
import 'package:mipromo/ui/shared/widgets/inputfield.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class SellerEditProfileView extends StatelessWidget {
  const SellerEditProfileView({
    Key? key,
    required this.user,
  }) : super(key: key);

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SellerEditProfileViewModel>.reactive(
      onModelReady: (model) => model.init(user),
      builder: (context, model, child) => model.isBusy
          ? const BasicLoader()
          : Stack(
              children: [
                Scaffold(
                  appBar: AppBar(
                    title: Constants.editProfileLabel.text.make(),
                    actions: [
                      IconButton(
                        //color: Theme.of(context).primaryColor,
                        icon: const Icon(Icons.done),
                        onPressed: () {
                          model.updateProfile();
                        },
                      ),
                    ],
                  ),
                  body: SafeArea(
                    child: user.id.isEmpty
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : SingleChildScrollView(
                            padding: const EdgeInsets.all(25),
                            child: _EditProfileForm(),
                          ),
                  ),
                ),
                BusyLoader(busy: model.isBusy),
              ],
            ),
      viewModelBuilder: () => SellerEditProfileViewModel(),
    );
  }
}

class _EditProfileForm extends ViewModelWidget<SellerEditProfileViewModel> {
  @override
  Widget build(
    BuildContext context,
    SellerEditProfileViewModel model,
  ) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          radius: context.screenWidth / 8,
          child: ClipOval(
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: profileImage(model),
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            model.selectImage();
          },
          child: Constants.changeProfileImageLabel.text
              .color(Theme.of(context).primaryColor)
              .make()
              .p12(),
        ),
        InputField(
          labelText: Constants.usernameLabel,
          inputFormatters: [
            LowerCaseTextFormatter(),
            FilteringTextInputFormatter.allow(RegExp('[a-z0-9]|[.|_]'))
          ],
          initialValue: model.user.username,
          autovalidateMode: model.xx ? null : AutovalidateMode.disabled,
          validate: model.validate,
          maxLength: 70,
          counter: "",
          onChanged: (username) {
            username = username;
          },
          validator: (value) => Validators.userNameValidator(
            username: value,
            alreadyExists: model.usernames.contains(
              value!.toLowerCase(),
            ),
          ),
        ),
        InputField(
          labelText: Constants.fullNameLabel,
          initialValue: model.fullName,
          validate: model.validate,
          maxLength: 70,
          counter: "",
          onChanged: (name) {
            model.name = name;
            model.fullName = name;
          },
          validator: (name) => Validators.emptyStringValidator(name, 'Name'),
        ),
        InputField(
          labelText: Constants.phoneNumberLabel,
          initialValue: model.user.phoneNumber,
          textInputType: TextInputType.phone,
          validate: model.validate,
          onChanged: (phoneNumber) {
            model.phoneNumber = phoneNumber;
          },
          validator: (phoneNumber) =>
              Validators.emptyStringValidator(phoneNumber, 'Phone Number'),
        ),
        InkWell(
          onTap: (){
              showModalBottomSheet(
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (context) {
                    return PasswordSheet(
                      user: model.user,
                    );
                  });
          },
          child: InputField(
            labelText: Constants.passwordLabel,
            initialValue: 'dummypassword',
            validate: model.validate,
            isPassword: true,
            enable: false,
          ),
        ),
        InputField(
          labelText: Constants.addressLabel,
          initialValue: model.address,
          validate: model.validate,
          onChanged: (address) {
            model.address = address;
          },
        ),
        InputField(
          labelText: Constants.postCodeLabel,
          initialValue: model.postCode,
          validate: model.validate,
          onChanged: (postCode) {
            model.postCode = postCode;
          },
        ),
        20.heightBox,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                "Date of birth".text.bold.make(),
                Row(
                  children: <Widget>[
                    (model.selectedDate == null
                            ? 'Select Date'
                            : DateFormat.yMMMd()
                                .format(model.selectedDate!)
                                .toString())
                        .text
                        .make(),
                    IconButton(
                        icon: const Icon(
                          Icons.calendar_today_outlined,
                        ),
                        onPressed: () {
                          final pickedDate = showDatePicker(
                            initialDate: model.selectedDate!,
                            context: context,
                            firstDate: DateTime(1950, 8),
                            lastDate: DateTime(2101),
                          );
                          model.selectDate(pickedDate);
                        })
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                "Gender".text.bold.make(),
                DropdownButton<String>(
                  hint: Constants.selectGenderLabel.text
                      .color(Colors.grey)
                      .makeCentered(),
                  value: model.genderValue!.isEmpty ? null : model.genderValue,
                  underline: const SizedBox.shrink(),
                  items: <DropdownMenuItem<String>>[
                    DropdownMenuItem(
                      value: Constants.maleLabel,
                      child: Constants.maleLabel.text.makeCentered(),
                    ),
                    DropdownMenuItem(
                      value: Constants.femaleLabel,
                      child: Constants.femaleLabel.text.makeCentered(),
                    ),
                    DropdownMenuItem(
                      value: Constants.otherLabel,
                      child: Constants.otherLabel.text.makeCentered(),
                    ),
                  ],
                  onChanged: (String? value) {
                    model.onGenderSelection(value!);
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget profileImage(SellerEditProfileViewModel model) {
    if (model.selectedImage == null) {
      if (model.user.imageUrl.isEmpty) {
        return SvgPicture.asset(
          "assets/images/avatar.svg",
          fit: BoxFit.cover,
        );
      } else {
        return Image.network(
          model.user.imageUrl,
          fit: BoxFit.cover,
        );
      }
    } else {
      return Image.file(
        model.selectedImage!,
        fit: BoxFit.cover,
      );
    }
  }
}

class PasswordSheet extends StatelessWidget {
  const PasswordSheet({Key? key, required this.user}) : super(key: key);

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    double height = media.height;
    double width = media.width;

    return ViewModelBuilder<SellerEditProfileViewModel>.reactive(
      onModelReady: (model) => model.init(user),
      builder: (context, model, child) => model.isBusy
          ? const BasicLoader()
          : Stack(
        children: [
          Wrap(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15), topRight: Radius.circular(15)),
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
                                child: Icon(Icons.clear, size: 19)
                            ),
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
                                  child: 'Change Your Password'.text.bold.size(20).make(),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: height * 0.03,
                            ),
                            Container(
                              height: height * 0.06,
                              width: width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: TextFormField(
                                style: TextStyle(
                                  fontSize: height * 0.019,
                                  color: Colors.black,
                                ),
                                obscureText: true,
                                onChanged: (value){},
                                controller: model.oldPasswordController,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xffEEEEEE))),
                                  disabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xffEEEEEE))),
                                  hintText: 'Enter old password',
                                  hintStyle:
                                  TextStyle(fontSize: height * 0.019, color: Colors.black54),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height * 0.015,
                            ),
                            Container(
                              height: height * 0.06,
                              width: width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: TextFormField(
                                style: TextStyle(
                                  fontSize: height * 0.019,
                                  color: Colors.black,
                                ),
                                obscureText: true,
                                onChanged: (value){},
                                controller: model.newPasswordController,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey)),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xffEEEEEE))),
                                  disabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: Color(0xffEEEEEE))),
                                  hintText: 'Enter new password',
                                  hintStyle:
                                  TextStyle(fontSize: height * 0.019, color: Colors.black54),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height * 0.015,
                            ),
                            Container(
                              height: height * 0.055,
                              width: width * 0.95,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: MaterialButton(
                                color: Color(4286745852),
                                onPressed: (){
                                  if(model.oldPasswordController.text.isNotEmpty && model.newPasswordController.text.isNotEmpty){
                                    FocusScope.of(context).unfocus();
                                    model.changePassword();
                                  }else{
                                    Fluttertoast.showToast(
                                        msg: 'All fields are required',
                                        toastLength: Toast.LENGTH_SHORT,
                                        backgroundColor: Colors.black87,
                                        textColor: Colors.white,
                                        fontSize: 16.0
                                    );
                                  }
                                },
                                child: model.isLoading ? CircularProgressIndicator(color: Colors.white) :
                                const Text(
                                  'Change Password',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 16
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height * 0.015,
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context).viewInsets.bottom))
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
      viewModelBuilder: () => SellerEditProfileViewModel(),
    );
  }
}

