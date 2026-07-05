import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'add_photo.g.dart';

@riverpod
class AddPhoto extends _$AddPhoto {

  @override
  File? build() {
    return null;
  }

  void setImage(File? newImage) {
    state = newImage;
  }
}