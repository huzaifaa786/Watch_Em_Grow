import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:mipromo/api/image_selector_api.dart';
import 'package:mipromo/app/app.locator.dart';
import 'package:mipromo/exceptions/image_selector_api_exception.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/ui/auth/buyer_signup/buyer_signup_viewmodel.dart';
import 'package:mipromo/ui/auth/widgets/auth_button.dart';
import 'package:mipromo/ui/profile/buyer/editProfile/buyer_edit_profile_viewmodel.dart';
import 'package:mipromo/ui/shared/helpers/alerts.dart';
import 'package:mipromo/ui/shared/helpers/data_models.dart';
import 'package:mipromo/ui/shared/helpers/enums.dart';
import 'package:mipromo/ui/shared/widgets/busy_loader.dart';
import 'package:mipromo/ui/shared/widgets/scrollable_body.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:mipromo/api/storage_api.dart';
import 'package:mipromo/api/database_api.dart';

class ProfileUpdate extends StatelessWidget {
  const ProfileUpdate({
    Key? key,
    required this.user,
  }) : super(key: key);

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BuyerEditProfileViewModel>.reactive(
      onModelReady: (model) => model.init(user),
      builder: (context, model, child) => Stack(
        children: [
          Scaffold(
            body: SafeArea(
              child: Container(
                color: Colors.black,
                child: Column(
                  children: [
                    Center(
                      // ignore: avoid_unnecessary_containers
                      child: Container(
                        // ignore: prefer_const_constructors
                        margin: EdgeInsets.only(top: 50, bottom: 10),
                        // ignore: prefer_const_constructors
                        child: Column(
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            // ignore: prefer_const_constructors
                            Image(
                              image: AssetImage('assets/icon/icon_new.png'),
                              height: 45,
                            ),

                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Add profile photo",
                              style: TextStyle(fontSize: 26, color: Colors.white),
                            ),

                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.85,
                              child: Text(
                                "Add a profile photo so that your freinds Know it's you",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12, color: Colors.white),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.2,
                            ),
                            Stack(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: MediaQuery.of(context).size.width / 8,
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
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: SizedBox(
                                    height: 25,
                                    width: 25,
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(50),
                                          side: BorderSide(color: Colors.lightBlue),
                                        ),
                                        primary: Colors.lightBlue,
                                      ),
                                      onPressed: () {},
                                      child: Icon(
                                        Icons.add,
                                        size: 10,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.25,
                            ),
                            Divider(
                              height: 2,
                              color: Colors.white,
                            ),
                            SizedBox(
                              height: 18,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                model.selectImage();
                                },
                                style: ButtonStyle(
                                  fixedSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width * 0.9,
                                      MediaQuery.of(context).size.height * 0.05)),
                                  shape: MaterialStateProperty.all<OutlinedBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  'Add a photo',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                            SizedBox(
                              height: 21,
                            ),
                            GestureDetector(
                              onTap: () {
                                model.updateSkip(user);
                                model.notifyListeners();
                              },
                              child: Text('Skip', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          BusyLoader(busy: model.isBusy),
        ],
      ),
      viewModelBuilder: () => BuyerEditProfileViewModel(),
    );

    // Loading Widget
  }
}
