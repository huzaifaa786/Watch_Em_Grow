import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
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
import 'package:mipromo/ui/shared/helpers/constants.dart';
import 'package:mipromo/ui/shared/helpers/data_models.dart';
import 'package:mipromo/ui/shared/helpers/validators.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:uuid/uuid.dart';
import 'package:video_editor/video_editor.dart';

class EditServiceViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _databaseApi = locator<DatabaseApi>();
  final _storageApi = locator<StorageApi>();
  final _imageSelectorApi = locator<ImageSelectorApi>();

  final _serviceId = const Uuid().v4();

  late AppUser user;
  late Shop shop;
  late ShopService servicee;

  void init(AppUser cUser, Shop cShop, ShopService service) {
    setBusy(true);

    user = cUser;
    shop = cShop;
    servicee = service;
    serviceName = service.name;
    description = service.description!;
    price = service.price.toString();
    serviceAspectRatio = service.aspectRatio;
    selectedType = service.type;
    if (service.type == Constants.serviceLabel) {
      depositAmount = service.depositAmount.toString();
      durationController.text = service.duration.toString();
      noteController.text = service.bookingNote!;
    } else {
      sizes = service.sizes!;
    }
    if (service.imageUrl1 != null)
      urlToFile(service.imageUrl1!).then((value) {
        _selectedImage1 = value;
        _finalImage1 = value;
        images.add(_finalImage1!);
        notifyListeners();
      });
    if (service.imageUrl2 != null)
      urlToFile(service.imageUrl2!).then((value) {
        _selectedImage2 = value;
        _finalImage2 = value;
        images.add(_finalImage2!);
        notifyListeners();
      });
    if (service.imageUrl3 != null)
      urlToFile(service.imageUrl3!).then((value) {
        _selectedImage3 = value;
        _finalImage3 = value;
        images.add(_finalImage3!);
        notifyListeners();
      });

    setBusy(false);
    notifyListeners();
  }

  double? serviceAspectRatio;
  String serviceName = "";
  final _dialogService = locator<DialogService>();

  String description = "";
  String price = "";
  String depositAmount = "0";
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

  Future<File> urlToFile(String imageUrl) async {
// generate random number.
    var rng = new Random();
// get temporary directory of device.
    Directory tempDir = await getTemporaryDirectory();
// get temporary path from temporary directory.
    String tempPath = tempDir.path;
// create a new file in temporary path with random file name.
    File file = new File('$tempPath' + (rng.nextInt(100)).toString() + '.png');
// call http.get method and pass imageUrl into it to get response.
    http.Response response = await http.get(Uri.parse(imageUrl));
// write bodyBytes received in response to file.
    await file.writeAsBytes(response.bodyBytes);
// now return the file which is created with random name in
// temporary directory and image bytes from response is written to // that file.
    return file;
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

  Future<Size> _calculateImageDimension(File nimage) {
    Completer<Size> completer = Completer();
    Image image = Image.file(nimage);
    image.image.resolve(ImageConfiguration()).addListener(
      ImageStreamListener(
        (ImageInfo image, bool synchronousCall) {
          var myImage = image.image;
          Size size = Size(myImage.width.toDouble(), myImage.height.toDouble());
          completer.complete(size);
        },
      ),
    );
    return completer.future;
  }

  confirmBeforeCreate() async {
    final dialogResponse = await _dialogService.showConfirmationDialog(
      title: 'Deposits',
      description:
          'Please note that it is your responsibility to ensure that the full balance is paid by your customer at the appointment. Only the Deposit will be taken through MiyPromo',
      confirmationTitle: 'Proceed',
      cancelTitle: 'Close',
    );
    if (dialogResponse?.confirmed ?? false) {
      EditService();
    }
  }

  Future EditService() async {
    setBusy(true);
    if (_validateServiceForm()) {
      await _databaseApi.editService(
        ShopService(
            id: servicee.id,
            shopId: shop.id,
            time: DateTime.now().microsecondsSinceEpoch,
            ownerId: shop.ownerId,
            name: serviceName,
            category: shop.category,
            description: description.trimRight(),
            price: double.parse(price),
            depositAmount: double.parse(depositAmount),
            aspectRatio: serviceAspectRatio,
            type: selectedType!,
            duration: selectedType != "Product"
                ? int.parse(durationController.text)
                : null,
            sizes: selectedType == "Product" ? sizes : null,
            bookingNote: selectedType != "Product"
                ? noteController.text.toString()
                : null),
      );

      if (selectedVideo1 != null) {
        await _saveServiceVideo();
      }
      await _saveServiceImage();

      await _databaseApi.updateShopService(
        shopId: shop.id,
        serviceId: servicee.id,
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
    if (Validators.emptyStringValidator(serviceName, 'Service Name') == null &&
        Validators.emptyStringValidator(description, 'Description') == null &&
        Validators.emptyStringValidator(price, 'Price') == null) {
      if (selectedType == null) {
        Alerts.showErrorSnackbar('Please Select Type');
        return false;
      }
      if (selectedType == 'Service') {
        if (Validators.emptyStringValidator(
                durationController.text, 'Duration') !=
            null) {
          Alerts.showErrorSnackbar('Please Enter Duration');
          return false;
        }
      }

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
    CropAspectRatioPreset.ratio4x5,
  ];

  static const androidUiSettings = AndroidUiSettings(
    hideBottomControls: false,
    lockAspectRatio: true,
  );

  Future selectImage1() async {
    final tempImage = await _imageSelectorApi.selectImage();

    _selectedImage1 = tempImage;
    notifyListeners();
    double imageWidth = 1.0;
    double imageHeight = 1.0;
    await _calculateImageDimension(_selectedImage1!).then((size) {
      imageWidth = size.width;
      imageHeight = size.height;
    });
    var ratio = 4 / 5;

    final file = await ImageCropper.cropImage(
      sourcePath: _selectedImage1!.path,
      aspectRatioPresets: ratios,
      // aspectRatio: const CropAspectRatio(ratioX: 4.0, ratioY: 5.0),
      androidUiSettings: androidUiSettings,
      iosUiSettings: IOSUiSettings(
          title: 'Crop Image',
          rectX: 0.0,
          rectY: 0.0,
          rectWidth: imageWidth,
          rectHeight: imageWidth / ratio,
          rotateButtonsHidden: true,
          aspectRatioLockEnabled: true,
          resetButtonHidden: true),
    );

    await _calculateImageDimension(file!).then((size) {
      serviceAspectRatio = size.width / size.height;
    });

    _finalImage1 = file;
    images.add(_finalImage1!);
    notifyListeners();
  }

  Future selectVideo(File file) async {
    print(file);
    selectedVideo1 = File(file.path);

    videoName = file.path.split('/').last;

    notifyListeners();
  }

  Future _saveServiceVideo() async {
    if (selectedImage1 != null) {
      final CloudStorageResult storageResult =
          await _storageApi.uploadServiceVideo(
        serviceId: servicee.id,
        videoToUpload: selectedVideo1!,
      );

      await _databaseApi.updateServiceVideo(
        shopId: shop.id,
        serviceId: servicee.id,
        imageFileName: storageResult.imageFileName,
        imageUrl: storageResult.imageUrl,
      );
    }
  }

  Future selectImage2() async {
    final tempImage = await _imageSelectorApi.selectImage();

    _selectedImage2 = tempImage;
    notifyListeners();
    double imageWidth = 1.0;
    double imageHeight = 1.0;
    await _calculateImageDimension(_selectedImage1!).then((size) {
      imageWidth = size.width;
      imageHeight = size.height;
    });

    var ratio = 4 / 5;

    final file = await ImageCropper.cropImage(
      sourcePath: _selectedImage2!.path,
      aspectRatioPresets: ratios,
      androidUiSettings: androidUiSettings,
      iosUiSettings: IOSUiSettings(
          title: 'Crop Image',
          rectX: 0.0,
          rectY: 0.0,
          rectWidth: imageWidth,
          rectHeight: imageWidth / ratio,
          rotateButtonsHidden: true,
          aspectRatioLockEnabled: true,
          resetButtonHidden: true),
    );

    _finalImage2 = file;
    images.add(_finalImage2!);
    notifyListeners();
  }

  Future selectImage3() async {
    final tempImage = await _imageSelectorApi.selectImage();

    _selectedImage3 = tempImage;
    notifyListeners();

    double imageWidth = 1.0;
    double imageHeight = 1.0;
    await _calculateImageDimension(_selectedImage1!).then((size) {
      imageWidth = size.width;
      imageHeight = size.height;
    });

    var ratio = 4 / 5;

    final file = await ImageCropper.cropImage(
      sourcePath: _selectedImage3!.path,
      aspectRatioPresets: ratios,
      androidUiSettings: androidUiSettings,
      iosUiSettings: IOSUiSettings(
          title: 'Crop Image',
          rectX: 0.0,
          rectY: 0.0,
          rectWidth: imageWidth,
          rectHeight: imageWidth / ratio,
          rotateButtonsHidden: true,
          aspectRatioLockEnabled: true,
          resetButtonHidden: true),
    );

    _finalImage3 = file;
    images.add(_finalImage3!);
    notifyListeners();
  }

  Future _saveServiceImage() async {
    if (selectedImage1 != null && _finalImage1!.absolute.existsSync()) {
      final CloudStorageResult storageResult =
          await _storageApi.updateServiceImages(
        serviceId: servicee.id,
        imageNumber: '1',
        imageToUpload: _finalImage1!,
        imageUrl: servicee.imageUrl1 != null ? servicee.imageUrl1 : null,
      );

      await _databaseApi.updateServiceImage1Data(
        shopId: shop.id,
        serviceId: servicee.id,
        imageFileName: storageResult.imageFileName,
        imageUrl: storageResult.imageUrl,
      );
    }
    if (selectedImage2 != null && _finalImage2!.absolute.existsSync()) {
      final CloudStorageResult storageResult =
          await _storageApi.updateServiceImages(
        serviceId: servicee.id,
        imageNumber: '2',
        imageToUpload: _finalImage2!,
        imageUrl: servicee.imageUrl2 != null ? servicee.imageUrl2 : null,
      );

      await _databaseApi.updateServiceImage2Data(
        shopId: shop.id,
        serviceId: servicee.id,
        imageFileName: storageResult.imageFileName,
        imageUrl: storageResult.imageUrl,
      );
    }
    if (selectedImage3 != null && _finalImage2!.absolute.existsSync()) {
      final CloudStorageResult storageResult =
          await _storageApi.updateServiceImages(
        serviceId: servicee.id,
        imageNumber: '3',
        imageToUpload: _finalImage3!,
        imageUrl: servicee.imageUrl3 != null ? servicee.imageUrl3 : null,
      );

      await _databaseApi.updateServiceImage3Data(
        shopId: shop.id,
        serviceId: servicee.id,
        imageFileName: storageResult.imageFileName,
        imageUrl: storageResult.imageUrl,
      );
    }
  }
}
