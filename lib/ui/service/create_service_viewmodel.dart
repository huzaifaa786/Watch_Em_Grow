import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mipromo/api/database_api.dart';
import 'package:mipromo/api/image_selector_api.dart';
import 'package:mipromo/api/storage_api.dart';
import 'package:mipromo/app/app.locator.dart';
import 'package:mipromo/models/app_user.dart';
import 'package:mipromo/models/shop.dart';
import 'package:mipromo/models/shop_service.dart';
import 'package:mipromo/ui/shared/helpers/alerts.dart';
import 'package:mipromo/ui/shared/helpers/data_models.dart';
import 'package:mipromo/ui/shared/helpers/validators.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:uuid/uuid.dart';
import 'package:video_editor/video_editor.dart';

class CreateServiceViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _databaseApi = locator<DatabaseApi>();
  final _storageApi = locator<StorageApi>();
  final _imageSelectorApi = locator<ImageSelectorApi>();

  final _serviceId = const Uuid().v4();

  late AppUser user;
  late Shop shop;

  void init(AppUser cUser, Shop cShop) {
    setBusy(true);

    user = cUser;
    shop = cShop;

    notifyListeners();

    setBusy(false);
  }

  String serviceName = "";
  String description = "";
  String price = "";
  String bookingNote = "";
  TextEditingController noteController = new TextEditingController();
  TextEditingController durationController = new TextEditingController();
  TextEditingController startController = new TextEditingController();
  TextEditingController endController = new TextEditingController();
  // late VideoEditorController _controller;
  String? selectedType;

  bool onesizeValue = false;
  bool xsValue = false;
  bool sValue = false;
  bool mValue = false;
  bool lValue = false;
  bool xlValue = false;
  bool xxlValue = false;

  bool oneSize = false;
  bool twoSize = false;
  bool threeSize = false;
  bool fourSize = false;
  bool fiveSize = false;
  bool sixSize = false;
  bool sevenSize = false;
  bool eightSize = false;
  bool nineSize = false;
  bool tenSize = false;
  bool elevenSize = false;
  bool twelveSize = false;
  bool thirteenSize = false;
  bool fourteenSize = false;

  bool autoValidate = false;

  List<String> sizes = [];

  void showErrors() {
    autoValidate = true;
    notifyListeners();
  }

  void getSelectedType(String type) {
    selectedType = type;
    notifyListeners();
  }

  void selectedSizes(String value) {
    if (selectedType == "Product") {
      if (sizes.contains(value)) {
        sizes.remove(value);
      } else {
        sizes.add(value);
      }
    }
    notifyListeners();
  }

  Future createService() async {
    setBusy(true);
    if (_validateServiceForm()) {
      await _databaseApi.createService(
        ShopService(
            id: _serviceId,
            shopId: shop.id,
            time: DateTime.now().microsecondsSinceEpoch,
            ownerId: shop.ownerId,
            name: serviceName,
            description: description.trimRight(),
            price: double.parse(price),
            type: selectedType!,
            duration: selectedType != "Product"
                ? int.parse(durationController.text)
                : null,
            startHour: selectedType != "Product"
                ? int.parse(startController.text)
                : null,
            endHour: selectedType != "Product"
                ? int.parse(endController.text)
                : null,
            sizes: selectedType == "Product" ? sizes : null,
            bookingNote: selectedType != "Product"
                ? noteController.text.toString()
                : null),
      );
      log(selectedVideo1.toString());
      if (selectedVideo1 != null) {
        log('1111111111111111111111111111111');
        await _saveServiceVideo();
      }
      await _saveServiceImage();

      await _databaseApi.updateShopService(
        shopId: shop.id,
        serviceId: _serviceId,
      );

      if (shop.lowestPrice == 0 && shop.highestPrice == 0) {
        await _databaseApi.updateShopHighestPrice(
          shopId: shop.id,
          highestPrice: double.parse(price),
        );
      } else if (double.parse(price) < shop.highestPrice &&
          shop.lowestPrice == 0) {
        await _databaseApi.updateShopLowestPrice(
          shopId: shop.id,
          lowestPrice: double.parse(price),
        );
      } else if (double.parse(price) > shop.highestPrice) {
        await _databaseApi.updateShopHighestPrice(
          shopId: shop.id,
          highestPrice: double.parse(price),
        );
      } else if (double.parse(price) < shop.lowestPrice) {
        await _databaseApi.updateShopLowestPrice(
          shopId: shop.id,
          lowestPrice: double.parse(price),
        );
      }
      setBusy(false);

      _navigationService.back();
    } else {
      showErrors();
      setBusy(false);
    }
  }

  bool _validateServiceForm() {
    if (Validators.emptyStringValidator(serviceName, 'Service Name') == null ||
        Validators.emptyStringValidator(description, 'Description') == null ||
        Validators.emptyStringValidator(
              selectedType,
              'Service Type',
            ) ==
            null ||
        Validators.emptyStringValidator(price, 'Price') == null ||
        Validators.emptyStringValidator(durationController.text, 'Duration') ==
            null ||
        Validators.emptyStringValidator(startController.text, 'Start Hour') ==
            null ||
        Validators.emptyStringValidator(endController.text, 'End Hour') ==
            null) {
      if (_selectedImage1 != null) {
        return true;
      } else {
        Alerts.showErrorSnackbar('Please select an image');
        return false;
      }
    } else {
      showErrors();
      return false;
    }
  }

  void removeImage(File? image, int index) {
    images.remove(image);
    notifyListeners();

    if (index == 0) {
      _selectedImage1!.delete();
      _finalImage1!.delete();
    }
    if (index == 1) {
      _selectedImage2!.delete();
      _finalImage2!.delete();
    }
    if (index == 2) {
      _selectedImage3!.delete();
      _finalImage3!.delete();
    }
  }

  var videoName;
  File? selectedVideo1;
  File? get selectedVideo => selectedVideo1;

  File? _selectedImage1;
  File? get selectedImage1 => _selectedImage1;

  File? _selectedImage2;
  File? get selectedImage2 => _selectedImage2;

  File? _selectedImage3;
  File? get selectedImage3 => _selectedImage3;

  File? _finalImage1;
  File? get finalImage1 => _finalImage1;

  File? _finalImage2;
  File? get finalImage2 => _finalImage2;

  File? _finalImage3;
  File? get finalImage3 => _finalImage3;

  List<File> images = [];
  List<CropAspectRatioPreset> ratios = [
    CropAspectRatioPreset.square,
    // CropAspectRatioPreset.ratio4x5
  ];

  static const androidUiSettings = AndroidUiSettings(
    hideBottomControls: false,
    lockAspectRatio: false,
  );

  Future selectImage1() async {
    final tempImage = await _imageSelectorApi.selectImage();

    _selectedImage1 = tempImage;
    notifyListeners();

    final file = await ImageCropper.cropImage(
      sourcePath: _selectedImage1!.path,
      aspectRatioPresets: ratios,
      // aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      androidUiSettings: androidUiSettings,
      iosUiSettings: IOSUiSettings(
        title: 'Crop Image',
      ),
    );

    _finalImage1 = file;
    images.add(_finalImage1!);
    notifyListeners();
  }

  Future selectVideo(File file) async {
    print(file);
    selectedVideo1 = File(file.path);
    log("selexrefKASJ222222222222@@@@@@@@@@@@@");
    log(selectedVideo1.toString());
    videoName = file.path.split('/').last;
    log(videoName.toString());
    notifyListeners();
  }

  Future _saveServiceVideo() async {
    if (selectedImage1 != null) {
      final CloudStorageResult storageResult =
          await _storageApi.uploadServiceVideo(
        serviceId: _serviceId,
        videoToUpload: selectedVideo1!,
      );

      await _databaseApi.updateServiceVideo(
        shopId: shop.id,
        serviceId: _serviceId,
        imageFileName: storageResult.imageFileName,
        imageUrl: storageResult.imageUrl,
      );
    }
  }

  Future selectImage2() async {
    final tempImage = await _imageSelectorApi.selectImage();

    _selectedImage2 = tempImage;
    notifyListeners();

    final file = await ImageCropper.cropImage(
      sourcePath: _selectedImage2!.path,
      aspectRatioPresets: ratios,
      androidUiSettings: androidUiSettings,
      iosUiSettings: IOSUiSettings(title: 'Crop Image'),
    );

    _finalImage2 = file;
    images.add(_finalImage2!);
    notifyListeners();
  }

  Future selectImage3() async {
    final tempImage = await _imageSelectorApi.selectImage();

    _selectedImage3 = tempImage;
    notifyListeners();

    final file = await ImageCropper.cropImage(
      sourcePath: _selectedImage3!.path,
      aspectRatioPresets: ratios,
      androidUiSettings: androidUiSettings,
      iosUiSettings: IOSUiSettings(
        title: 'Crop Image',
      ),
    );

    _finalImage3 = file;
    images.add(_finalImage3!);
    notifyListeners();
  }

  Future _saveServiceImage() async {
    if (selectedImage1 != null) {
      final CloudStorageResult storageResult =
          await _storageApi.uploadServiceImages(
        serviceId: _serviceId,
        imageNumber: '1',
        imageToUpload: _finalImage1!,
      );

      await _databaseApi.updateServiceImage1Data(
        shopId: shop.id,
        serviceId: _serviceId,
        imageFileName: storageResult.imageFileName,
        imageUrl: storageResult.imageUrl,
      );
    }
    if (selectedImage2 != null) {
      final CloudStorageResult storageResult =
          await _storageApi.uploadServiceImages(
        serviceId: _serviceId,
        imageNumber: '2',
        imageToUpload: _finalImage2!,
      );

      await _databaseApi.updateServiceImage2Data(
        shopId: shop.id,
        serviceId: _serviceId,
        imageFileName: storageResult.imageFileName,
        imageUrl: storageResult.imageUrl,
      );
    }
    if (selectedImage3 != null) {
      final CloudStorageResult storageResult =
          await _storageApi.uploadServiceImages(
        serviceId: _serviceId,
        imageNumber: '3',
        imageToUpload: _finalImage3!,
      );

      await _databaseApi.updateServiceImage3Data(
        shopId: shop.id,
        serviceId: _serviceId,
        imageFileName: storageResult.imageFileName,
        imageUrl: storageResult.imageUrl,
      );
    }
  }
}
