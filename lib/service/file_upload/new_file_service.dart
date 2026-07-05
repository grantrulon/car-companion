import 'dart:io';
import 'package:car_companion/service/file_upload/add_file.dart';
import 'package:car_companion/service/file_upload/add_photo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'new_file_service.g.dart';

@riverpod
class NewFileService extends _$NewFileService {
  @override
  FutureOr<void> build() async {
    // void
  }

  Future<void> pickAndCropImage(WidgetRef ref, String saveMode) async {
    File? image;

    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      image = File(pickedImage.path);
    } else {
      print("Failed to Pick Image");
      return;
    }

    CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Crop',
              cropGridColor: Colors.black,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: true),
          IOSUiSettings(
              title: 'Crop',
              resetAspectRatioEnabled: false,
              aspectRatioLockEnabled: true)
        ]);

    if (croppedImage != null) {
      image = File(croppedImage.path);
    } else {
      print("Failed to Crop Image");
      return;
    }

    if (saveMode == "AddPhoto") {
      ref.read(addPhotoProvider.notifier).setImage(image);
    } else if (saveMode == "AddFile") {
      ref.read(addFileProvider.notifier).setImage(image);
    }
  }
}
