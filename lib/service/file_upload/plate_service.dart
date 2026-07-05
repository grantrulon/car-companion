import 'package:firebase_storage/firebase_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'plate_service.g.dart';

@riverpod
class PlateService extends _$PlateService {
  final storage = FirebaseStorage.instance;

  @override
  FutureOr<List<String>> build() async {
    return fetchPlates();
  }

  Future<List<String>> fetchPlates() async {
    List<String> downloadUrls = [];
    var platesRef = storage.ref().child("plates");
    var listResult = await platesRef.listAll();
    for (var item in listResult.items) {
      print(item);
      var imageRef = storage.ref().child(item.fullPath);
      downloadUrls.add(await imageRef.getDownloadURL());
    }
    return downloadUrls;
  }

}
