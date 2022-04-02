import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:mipromo/exceptions/image_selector_api_exception.dart';

class ImageSelectorApi {
  final picker = ImagePicker();

  Future<File> selectImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      return File(pickedFile.path);
    } else {
      throw ImageSelectorApiException(
        title: 'Image selection failed',
        message: 'Failed to select image, please try again.',
      );
    }
  }
}
