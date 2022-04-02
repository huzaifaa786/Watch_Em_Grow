import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:flutter/services.dart';
import 'package:mipromo/exceptions/storage_api_exception.dart';
import 'package:mipromo/ui/shared/helpers/data_models.dart';

class StorageApi {
  Future<CloudStorageResult> uploadProfileImage({
    required String userId,
    required File imageToUpload,
  }) async {
    final imageFileName = "PI._$userId";

    final storage.Reference storageReference = storage.FirebaseStorage.instance
        .ref()
        .child("profileImages/$userId/$imageFileName");

    try {
      final storage.UploadTask uploadTask =
          storageReference.putFile(imageToUpload);

      final storage.TaskSnapshot storageTaskSnapshot =
          await Future.value(uploadTask);

      final downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();

      if (uploadTask.storage.bucket.isNotEmpty) {
        final url = downloadUrl.toString();
        return CloudStorageResult(
          imageUrl: url,
          imageFileName: imageFileName,
        );
      } else {
        throw StorageApiException(
          title: 'Server Error',
          message: 'An error occured while uploading the image.',
        );
      }
    } on PlatformException catch (e) {
      throw StorageApiException(
        title: 'Failed to upload image',
        message: e.message,
      );
    }
  }

  Future<CloudStorageResult> uploadServiceImage({
    required String serviceId,
    required File imageToUpload,
  }) async {
    final imageFileName = "SI._$serviceId";

    final storage.Reference storageReference = storage.FirebaseStorage.instance
        .ref()
        .child("serviceImages/$serviceId/$imageFileName");

    try {
      // final storage.UploadTask uploadTask =
      //     storageReference.putFile(imageToUpload);

      // final storage.TaskSnapshot storageTaskSnapshot =
      //     await Future.value(uploadTask);

      // final downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();

      // if (uploadTask.storage.bucket.isNotEmpty) {
      //   final url = downloadUrl.toString();
      //   return CloudStorageResult(
      //     imageUrl: url,
      //     imageFileName: imageFileName,
      //   );
      // } else {
      //   throw StorageApiException(
      //     title: 'Server Error',
      //     message: 'An error occured while uploading the image.',
      //   );
      // }

      final result = await _uploadImage(
        storageReference,
        imageToUpload,
        imageFileName,
      );

      return result;
    } on PlatformException catch (e) {
      throw StorageApiException(
        title: 'Failed to upload image',
        message: e.message,
      );
    }
  }

  Future<CloudStorageResult> uploadServiceImages({
    required String serviceId,
    required String imageNumber,
    required File imageToUpload,
  }) async {
    final imageFileName = "SI._$serviceId";

    final storage.Reference storageReference = storage.FirebaseStorage.instance
        .ref()
        .child("serviceImages/$serviceId/$imageNumber/$imageFileName");

    try {
      // final storage.UploadTask uploadTask =
      //     storageReference.putFile(imageToUpload);

      // final storage.TaskSnapshot storageTaskSnapshot =
      //     await Future.value(uploadTask);

      // final downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();

      // if (uploadTask.storage.bucket.isNotEmpty) {
      //   final url = downloadUrl.toString();
      //   return CloudStorageResult(
      //     imageUrl: url,
      //     imageFileName: imageFileName,
      //   );
      // } else {
      //   throw StorageApiException(
      //     title: 'Server Error',
      //     message: 'An error occured while uploading the image.',
      //   );
      // }

      final result = await _uploadImage(
        storageReference,
        imageToUpload,
        imageFileName,
      );

      return result;
    } on PlatformException catch (e) {
      throw StorageApiException(
        title: 'Failed to upload image',
        message: e.message,
      );
    }
  }

  Future<bool> deleteProfileImage(
    String serviceId,
    String imageFileName,
  ) async {
    final storage.Reference storageReference = storage.FirebaseStorage.instance
        .ref()
        .child("profileImages/$serviceId/$imageFileName");

    try {
      bool result = false;

      await storageReference.delete().then(
            (_) => result = true,
          );

      return result;
    } on PlatformException catch (e) {
      throw StorageApiException(
        title: 'Failed to upload image',
        message: e.message,
      );
    }
  }

  Future<bool> deleteServiceImage(
    String userId,
    String imageFileName,
  ) async {
    final storage.Reference storageReference = storage.FirebaseStorage.instance
        .ref()
        .child("serviceImages/$userId/$imageFileName");

    try {
      bool result = false;

      await storageReference.delete().then(
            (_) => result = true,
          );

      return result;
    } on PlatformException catch (e) {
      throw StorageApiException(
        title: 'Failed to upload image',
        message: e.message,
      );
    }
  }

  Future<CloudStorageResult> _uploadImage(
    storage.Reference storageReference,
    File imageToUpload,
    String imageFileName,
  ) async {
    final storage.UploadTask uploadTask =
        storageReference.putFile(imageToUpload);

    final storage.TaskSnapshot storageTaskSnapshot =
        await Future.value(uploadTask);

    final downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();

    if (uploadTask.storage.bucket.isNotEmpty) {
      final url = downloadUrl.toString();
      return CloudStorageResult(
        imageUrl: url,
        imageFileName: imageFileName,
      );
    } else {
      throw StorageApiException(
        title: 'Server Error',
        message: 'An error occured while uploading the image.',
      );
    }
  }
}
