import 'package:car_companion/data/model/car/car_overview_model.dart';
import 'package:car_companion/repository/auth_repository.dart';
import 'package:car_companion/repository/car_repository.dart';
import 'package:car_companion/service/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'car_list_controller.g.dart';

@riverpod
class CarListController extends _$CarListController {

  @override
  FutureOr<List<CarOverview>> build() async {
    return fetchUserCars();
  }

  Future<List<CarOverview>> fetchUserCars() async {
    String? userId = ref.read(authRepositoryProvider).currentUser?.uid;
    // TODO: raise an exception??
    if (userId == null) return [];

    List<CarOverview> carData = await ref.read(carRepositoryProvider).fetchCarOverviews(userId);
    return carData;
  }

  Future<void> rearrangeItems(int oldIndex, int newIndex) async {
    // Pick out moved item, and place it where user dropped it in rearrangable listview
    final newCars = [...?state.value];
    final movedCar = newCars.removeAt(oldIndex);
    final insertionIndex = newIndex > oldIndex ? newIndex - 1 : newIndex;
    newCars.insert(insertionIndex, movedCar);
    state = AsyncData(newCars);
  }

  Future<void> createCar(String downloadUrl, String nickname, String vin,
      String year, String make, String model, String color, int mileage) async {
    state = AsyncLoading();
    // get the current userId
    var userId = ref.read(authRepositoryProvider).currentUser?.uid;
    if (userId == null) {
      print("Error getting the user, Exiting createCar()");
      return;
    }

    // Create the object
    final newData = {
      "downloadUrl": downloadUrl,
      "nickname": nickname,
      "year": year,
      "make": make,
      "model": model,
      "color": color,
      "ownerIds": [userId],
      "driverIds": [],
      "mileage": mileage,
      "vin": vin,
      "registrationId": "",
      "insuranceId": "",
      // TODO: this needs to be not null and not empty string
      "maintenanceId": "",
    };

    // Perist the data to Firestore
    // db.collection("Car").add(newData).then((documentSnapshot) async {
    //   state = AsyncData(await fetchUserCars());
    // }).onError((error, stackTrace) async {
    //   print("Error occured: ${error}");
    //   state = AsyncData(await fetchUserCars());
    // });

    ref.read(carRepositoryProvider).createCar(userId, newData);
  }
}
