import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/ui/profile/buyer/editProfile/buyer_edit_profile_viewmodel.dart';
import 'package:mipromo/ui/shared/helpers/constants.dart';
import 'package:mipromo/ui/shared/helpers/styles.dart';
import 'package:mipromo/ui/shared/helpers/validators.dart';
import 'package:mipromo/ui/shared/widgets/basic_loader.dart';
import 'package:mipromo/ui/shared/widgets/busy_loader.dart';
import 'package:mipromo/ui/shared/widgets/inputfield.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';

class BuyerEditProfileView extends StatelessWidget {
  const BuyerEditProfileView({
    Key? key,
    required this.user,
  }) : super(key: key);

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BuyerEditProfileViewModel>.reactive(
      onModelReady: (model) => model.init(user),
      builder: (context, model, _) => Stack(
        children: [
          Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: Constants.editProfileLabel.text.make(),
              actions: [
                IconButton(
                  color: Colors.white,
                  icon: const Icon(Icons.done),
                  onPressed: () {
                    model.updateProfile(user,false);
                  },
                ),
              ],
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: context.screenWidth / 8,
                      child: ClipOval(
                        child: SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: model.selectedImage == null
                              ? user.imageUrl.isEmpty
                                  ? SvgPicture.asset(
                                      "assets/images/avatar.svg",
                                    )
                                  : Image.network(
                                      user.imageUrl,
                                      fit: BoxFit.cover,
                                    )
                              : Image.file(
                                  model.selectedImage!,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        model.selectImage();
                      },
                      child: Constants.changeProfileImageLabel.text
                          .color(Styles.kcPrimaryColor)
                          .make()
                          .p12(),
                    ),
                    InputField(
                      labelText: Constants.usernameLabel,
                      inputFormatters: [
                        LowerCaseTextFormatter(),
                        FilteringTextInputFormatter.allow(
                          RegExp(
                            '[a-z0-9]|[.|_]',
                          ),
                        )
                      ],
                      initialValue: user.username,
                      autovalidateMode:
                          model.xx ? null : AutovalidateMode.disabled,
                      validate: model.validate,
                      maxLength: 70,
                      counter: "",
                      onChanged: (username) {
                        model.username = username;
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
                      initialValue: user.fullName,
                      validate: model.validate,
                      onChanged: (fullName) {
                        model.fullName = fullName;
                      },
                    ),
                    InputField(
                      labelText: Constants.addressLabel,
                      initialValue: user.address,
                      validate: model.validate,
                      onChanged: (address) {
                        model.address = address;
                      },
                    ),
                    InputField(
                      labelText: Constants.postCodeLabel,
                      initialValue: user.postCode,
                      validate: model.validate,
                      onChanged: (postCode) {
                        model.postCode = postCode;
                      },
                    ),
                    InkWell(
                      onTap: (){
                        showModalBottomSheet(
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (context) {
                              return PasswordSheet(
                                user: user,
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
                  ],
                ).p12(),
              ),
            ),
          ),
          BusyLoader(busy: model.isBusy),
        ],
      ),
      viewModelBuilder: () => BuyerEditProfileViewModel(),
    );
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

    return ViewModelBuilder<BuyerEditProfileViewModel>.reactive(
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
                              color: Color(4291861070),
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
      viewModelBuilder: () => BuyerEditProfileViewModel(),
    );
  }
}
