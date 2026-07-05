import 'package:car_companion/data/model/car/car_overview_model.dart';
import 'package:car_companion/service/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'cars_list_data.g.dart';

@riverpod
class AsyncCarsListData extends _$AsyncCarsListData {
  final db = FirebaseFirestore.instance;

  @override
  FutureOr<List<CarOverview>> build() async {
    return fetchUserCars();
  }

  Future<List<CarOverview>> fetchUserCars() async {
    // Secure the current user's Id
    String? userId = ref.read(authServiceProvider.notifier).getUserId();
    if (userId == null) return [];

    var query = db.collection("Car").where(Filter.or(
        Filter("ownerIds", arrayContains: userId),
        Filter("driverIds", arrayContains: userId)));
    List<CarOverview> carData = [];
    try {
      carData = await query.get().then((snapshot) {
        List<CarOverview> data = [];
        for (var document in snapshot.docs) {
          Map<String, dynamic> json = document.data();
          if (json['ownerIds'].contains(userId)) {
            data.add(CarOverview.fromJsonNew(document.id, "Owner", json));
          } else if (json['driverIds'].contains(userId)) {
            data.add(CarOverview.fromJsonNew(document.id, "Driver", json));
          }
        }
        return data;
      });
    } on FirebaseException catch (e, s) {
      print(e);
      print(s);
    }
    
    catch (e, s) {
      print(e);
      print(s);
      return [];
    }

    state = AsyncData(carData);
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
    var userId = ref.read(authServiceProvider.notifier).getUserId();
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
    db.collection("Car").add(newData).then((documentSnapshot) async {
      state = AsyncData(await fetchUserCars());
    }).onError((error, stackTrace) async {
      print("Error occured: ${error}");
      state = AsyncData(await fetchUserCars());
    });
  }
}

