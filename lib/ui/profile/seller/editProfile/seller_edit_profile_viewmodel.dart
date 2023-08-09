import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:intl/intl.dart';
import 'package:mipromo/api/auth_api.dart';
import 'package:mipromo/api/database_api.dart';
import 'package:mipromo/api/image_selector_api.dart';
import 'package:mipromo/api/storage_api.dart';
import 'package:mipromo/app/app.locator.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/ui/shared/helpers/data_models.dart';
import 'package:mipromo/ui/shared/helpers/enums.dart';
import 'package:mipromo/ui/shared/helpers/validators.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SellerEditProfileViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _dialogService = locator<DialogService>();
  final _databaseApi = locator<DatabaseApi>();
  final _storageApi = locator<StorageApi>();
  final _authApi = locator<AuthApi>();
  final _imageSelectorApi = locator<ImageSelectorApi>();

  String name = "";
  String phoneNumber = "";
  String fullName = "";
  String address = "";
  String postCode = "";

  TextEditingController oldPasswordController = new TextEditingController();
  TextEditingController newPasswordController = new TextEditingController();
  bool isLoading = false;

  DateTime? selectedDate;
  String? genderValue;

  bool validate = false;
  bool xx = true;

  String username = "";
  List<AppUser> users = [];
  List<String> usernames = [];

  Future updateProfile() async {
    final bool isValid = Validators.emptyStringValidator(name, 'Name') ==
            null &&
        Validators.emptyStringValidator(phoneNumber, 'Phone Number') == null;

    if (isValid) {
      await _updateProfile();
    } else {
      validate = true;
      notifyListeners();
    }
  }

  void setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  void _init() {
    name = user.fullName;
    fullName = user.fullName;
    username = user.username;
    address = user.address;
    postCode = user.postCode;
    phoneNumber = user.phoneNumber;
    selectedDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(user.dateOfBirth);
    genderValue = user.gender;
  }

  Future<void> selectDate(Future<DateTime?> pickedDate) async {
    final date = await pickedDate;

    if (date != selectedDate) {
      selectedDate = date;
      notifyListeners();
    }
  }

  void onGenderSelection(String v) {
    genderValue = v;
    notifyListeners();
  }

  late AppUser user;

  void init(AppUser currentUser) {
    setBusy(true);

    user = currentUser;
    notifyListeners();

    _databaseApi.listenUsers().listen(
      (usersData) {
        users = usersData;
        notifyListeners();

        if (users.isNotEmpty) {
          usernames = users
              .map((user) => user.username)
              .where((u) => u != username)
              .toList();
          notifyListeners();
        }
      },
    );

    _init();
    setBusy(false);
  }

  Future<void> _updateProfile() {
    xx = false;
    setBusy(true);

    return Future.wait([
      _updateProfileImage(),
      _updateUsername(),
      //_updateName(),
      _updatePhoneNumber(),
      _updateDateOfBirth(),
      _updateGender(),
      _updateAddress()
    ]).whenComplete(
      () {
        setBusy(false);
        _navigationService.back();
      },
    );
  }

  File? _selectedImage;
  File? get selectedImage => _selectedImage;

  Future selectImage() async {
    final tempImage = await _imageSelectorApi.selectImage();

    final croppedImage = await ImageCropper.cropImage(
      sourcePath: tempImage.path,
      aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      androidUiSettings: const AndroidUiSettings(
        hideBottomControls: true,
      ),
      iosUiSettings: IOSUiSettings(
        title: 'Crop Image',
      ),
      cropStyle: CropStyle.circle,
    );

    _selectedImage = croppedImage;
    notifyListeners();
  }

  Future _updateProfileImage() async {
    final url = user.imageUrl;
    final imageName = user.imageId;

    if (selectedImage != null) {
      if (url.isEmpty) {
        final CloudStorageResult storageResult =
            await _storageApi.uploadProfileImage(
          userId: user.id,
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
              userId: user.id,
              imageToUpload: _selectedImage!,
            );
            await _databaseApi.updateProfileImageData(
              userId: user.id,
              profileImageFileName: storageResult.imageFileName,
              profileImageUrl: storageResult.imageUrl,
            );
          } else {
            await _dialogService.showCustomDialog(
              variant: AlertType.error,
              title: "Failure!",
              description: "Error occured while updating Profile Picture",
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

  Future _updateName() async {
    if (name == user.fullName) {
    } else {
      await _databaseApi.updateProfileName(
        userId: user.id,
        name: name,
      );
    }
  }

  Future _updateAddress() async {
    if (address != user.address ||
        postCode != user.postCode ||
        fullName != user.fullName) {
      setBusy(true);
      await _databaseApi
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

  Future _updateUsername() async {
    if (username == user.username) {
    } else {
      await _databaseApi.updateUsername(
        userId: user.id,
        username: username,
      );
    }
  }

  Future _updatePhoneNumber() async {
    if (phoneNumber == user.phoneNumber) {
    } else {
      await _databaseApi.updateProfilePhoneNumber(
        userId: user.id,
        number: phoneNumber,
      );
    }
  }

  Future _updateDateOfBirth() async {
    if (selectedDate ==
        DateFormat("yyyy-MM-dd hh:mm:ss").parse(user.dateOfBirth)) {
    } else {
      await _databaseApi.updateProfileDateOfBirth(
        userId: user.id,
        dateOfBirth: selectedDate.toString(),
      );
    }
  }

  Future _updateGender() async {
    if (genderValue == user.gender) {
    } else {
      await _databaseApi.updateProfileGender(
        userId: user.id,
        gender: genderValue!,
      );
    }
  }

  Future<void> changePassword() async {
    setLoading(true);
    final response = await _authApi.verifyOldPassword(
        oldPasswordController.text, newPasswordController.text);
    if (response == 0 /*|| response == null*/) {
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
}
