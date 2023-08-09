import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:mipromo/api/auth_api.dart';
import 'package:mipromo/api/database_api.dart';
import 'package:mipromo/app/app.locator.dart';
import 'package:mipromo/app/app.router.dart';
import 'package:mipromo/api/image_selector_api.dart';
import 'package:mipromo/api/storage_api.dart';
import 'package:mipromo/exceptions/image_selector_api_exception.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/ui/shared/helpers/alerts.dart';
import 'package:mipromo/ui/shared/helpers/data_models.dart';
import 'package:mipromo/ui/shared/helpers/enums.dart';
import 'package:mipromo/ui/shared/helpers/validators.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class BuyerEditProfileViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _databaseApi = locator<DatabaseApi>();
  final _imageSelectorApi = locator<ImageSelectorApi>();
  final _storageApi = locator<StorageApi>();
  final _authApi = locator<AuthApi>();

  late AppUser currentUser;
  TextEditingController oldPasswordController = new TextEditingController();
  TextEditingController newPasswordController = new TextEditingController();
  bool isLoading = false;

  bool validate = false;

  bool xx = true;

  File? _selectedImage;
  File? get selectedImage => _selectedImage;

  Future selectImage() async {
    try {
      final tempImage = await _imageSelectorApi.selectImage();

      final croppedImage = await ImageCropper.cropImage(
        sourcePath: tempImage.path,
        aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        androidUiSettings: const AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          hideBottomControls: true,
        ),
        iosUiSettings: const IOSUiSettings(
          title: 'Crop Image',
        ),
        cropStyle: CropStyle.circle,
      );

      _selectedImage = croppedImage;
      updateProfile(currentUser, true);

      notifyListeners();
    } on ImageSelectorApiException catch (e) {
      Alerts.showBasicFailureDialog(
        e.title,
        e.message,
      );
    }
  }

  late String username;
  List<AppUser> users = [];
  List<String> usernames = [];
  String fullName = "";
  String address = "";
  String postCode = "";

  void init(AppUser cUser) {
    currentUser = cUser;
    username = cUser.username;
    fullName = cUser.fullName;
    address = cUser.address;
    postCode = cUser.postCode;
    notifyListeners();

    _databaseApi.listenUsers().listen(
      (usersData) {
        users = usersData;
        notifyListeners();

        if (users.isNotEmpty) {
          usernames = users
              .map((user) => user.username)
              .where((u) => u != cUser.username)
              .toList();
          notifyListeners();
        }
      },
    );
  }

  Future _updateProfileImage(AppUser user) async {
    final url = user.imageUrl;
    final imageName = user.imageId;

    if (_selectedImage != null) {
      if (url.isEmpty) {
        final CloudStorageResult storageResult =
            await _storageApi.uploadProfileImage(
          userId: currentUser.id,
          imageToUpload: _selectedImage!,
        );

        await _databaseApi.updateProfileImageData(
          userId: user.id,
          profileImageFileName: storageResult.imageFileName,
          profileImageUrl: storageResult.imageUrl,
        );
      } else {
        final result = await _storageApi.deleteProfileImage(
          user.id,
          imageName,
        );

        if (result is bool) {
          if (result) {
            final CloudStorageResult storageResult =
                await _storageApi.uploadProfileImage(
              userId: currentUser.id,
              imageToUpload: _selectedImage!,
            );
            await _databaseApi.updateProfileImageData(
              userId: currentUser.id,
              profileImageFileName: storageResult.imageFileName,
              profileImageUrl: storageResult.imageUrl,
            );
          } else {
            await _dialogService.showCustomDialog(
              variant: AlertType.warning,
              title: "Failure!",
              description: "Error occurred while updating Profile Picture",
            );
          }
        } else {
          await _dialogService.showCustomDialog(
            variant: AlertType.warning,
            title: "Failure!",
            description: result.toString(),
          );
        }
      }
    }
  }

  Future _updateAddress(AppUser user) async {
    if (address != user.address ||
        postCode != user.postCode ||
        fullName != user.fullName) {
      setBusy(true);
      _databaseApi
          .updateAddress(
              userId: user.id,
              fullName: fullName,
              address: address,
              postCode: postCode)
          .then((value) {
        setBusy(false);
        _navigationService.back(result: true);
      });
    }
  }

  Future _updateName(AppUser user) async {
    if (username != user.username) {
      await _databaseApi.updateUsername(
        userId: user.id,
        username: username,
      );
    }
  }

  Future updateSkip(AppUser user) async {
    await _databaseApi.updateSkip(userId: user.id, skip: 1);
  }

  Future updateProfile(AppUser user, bool discoverpge) {
    setBusy(true);

    return Future.wait([
      _updateProfileImage(user),
      _updateName(user),
      _updateAddress(user)
    ]).whenComplete(
      () {
        setBusy(false);
        // if (discoverpge) {
        //   _navigationService.replaceWith(Routes.discoverPage);
        //   // _navigationService.back();

        // } else {
        _navigationService.back();
        _navigationService.back();
        // }
      },
    );
  }

  void setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  Future<void> changePassword() async {
    setLoading(true);
    final response = await _authApi.verifyOldPassword(
        oldPasswordController.text, newPasswordController.text);
    if (response == 0) {
      setLoading(false);
      Fluttertoast.showToast(
          msg: 'Old password does not match',
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 16.0);
    } else /*if(response == 3)*/ {
      oldPasswordController.clear();
      newPasswordController.clear();
      setLoading(false);
      Fluttertoast.showToast(
          msg: 'Password changed successfully',
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 16.0);
      _navigationService.back();
    }
  }

  Future _updateProfile(AppUser user) async {
    xx = false;
    notifyListeners();
    final bool isValid = (Validators.userNameValidator(
          username: username,
          alreadyExists: usernames.contains(
            username.toLowerCase(),
          ),
        )) ==
        null;

    if (isValid && selectedImage != null) {
      setBusy(true);
      await _updateProfile(user).whenComplete(
        () {
          setBusy(false);
          _navigationService.back();
        },
      );
    } else if (isValid && selectedImage == null) {
      setBusy(true);
      await _updateName(user).whenComplete(
        () async {
          await _updateAddress(user).whenComplete(() {
            setBusy(false);
            _navigationService.back();
          });
        },
      );
    } else if (selectedImage != null) {
      setBusy(true);
      await _updateProfileImage(user).whenComplete(
        () {
          setBusy(false);
          _navigationService.back();
        },
      );
    } else {
      validate = true;
      xx = true;
      notifyListeners();
    }
  }
}
