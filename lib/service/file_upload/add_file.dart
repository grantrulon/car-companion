import 'dart:io';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'add_file.g.dart';

@riverpod
class AddFile extends _$AddFile {

  @override
  File? build() {
    return null;
  }

  void setImage(File? newImage) {
    state = newImage;
  }
}