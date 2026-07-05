import 'package:car_companion/controller/current_car.dart';
import 'package:car_companion/data/model/maintenance/maintenance_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_record.g.dart';

@riverpod
class CurrentRecord extends _$CurrentRecord {
  final db = FirebaseFirestore.instance;

  @override
  FutureOr<MaintenanceRecord> build() async {
    return MaintenanceRecord("recordId", DateTime.now(), "description",
        "moreDetails", "past", "carId");
  }

  Future<void> fetchNewCurrentRecord(String recordId) async {
    state = AsyncLoading();

    state = await AsyncValue.guard(() async {
      return await db.collection("Maintenance").doc(recordId).get().then((document) {
        return MaintenanceRecord.fromJson(
            document.id, document.data() as Map<String, dynamic>);
      });
    });
  }

  Future<void> updateCurrentRecord({String? description, String? moreDetails, DateTime? date, String? type}) async { 
    var currentRecordId;
    var currentCarId;
    if (state case AsyncData(:final value)) {
      currentRecordId = value.recordId;
      currentCarId = value.carId;
    } else {
      print("Error: Current record is not AsyncData");
      return;
    }

    state = AsyncLoading();

    Map<String, dynamic> updateData = Map<String, dynamic>();
    if (description != null) updateData["description"] = description;
    if (moreDetails != null) updateData["moreDetails"] = moreDetails;
    if (date != null) updateData["date"] = date.toIso8601String();
    if (type != null) updateData["type"] = type;

    await db.collection("Maintenance").doc(currentRecordId).set(updateData, SetOptions(merge: true)).then((value) {
      fetchNewCurrentRecord(currentRecordId);
      ref.read(currentCarProvider.notifier).fetchNewCurrentCar(currentCarId);
  });
  }
}
