import 'package:car_companion/data/globals.dart';
import 'package:car_companion/data/model/car/car_model.dart';
import 'package:car_companion/data/model/car/car_overview_model.dart';
import 'package:car_companion/data/model/registration/registration_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'car_repository.g.dart';

// Exposing instance of CarRepository for rest of app
@riverpod
CarRepository carRepository(CarRepositoryRef ref) {
  return CarRepository();
}

/* 
Repository class that interacts with Firebase Firestore API for Car data
TODO: Error Handling -> handle here or send up to caller?
*/
class CarRepository {

  Future<List<CarOverview>> fetchCarOverviews(String userId) async {
    // Set up query and get the rawdata from Firestore
    var querySnapshot = await FirebaseFirestore.instance
        .collection("Car")
        .where(Filter.or(Filter("ownerIds", arrayContains: userId),
            Filter("driverIds", arrayContains: userId)))
        .get();

    // Parse data into CarOverview model objects
    List<CarOverview> carOverviewData = [];
    for (var document in querySnapshot.docs) {
      Map<String, dynamic> json = document.data();
      if (json['ownerIds'].contains(userId)) {
        carOverviewData.add(CarOverview.fromJsonNew(document.id, roleOwner, json));
      } else if (json['driverIds'].contains(userId)) {
        carOverviewData.add(CarOverview.fromJsonNew(document.id, roleDriver, json));
      }
    }

    return carOverviewData;
  }

  Future<void> createCar(String userId, Map<String, dynamic> newData) async {
    // Persist new Car data to Firestore 
    await FirebaseFirestore.instance.collection("Car").add(newData);
  }

  Future<Car> fetchCar(String carId, String userId) async {
    var document = await FirebaseFirestore.instance.collection("Car").doc(carId).get();
    var json = document.data() as Map<String, dynamic>;

    Car car = Car.fromJson(carId, json['ownerIds'].contains(userId), json);
    return car;
  }

  Future<Registration> fetchRegistration(String carId, String registrationId) async {
    Registration newRegistrationData = await FirebaseFirestore.instance
          .collection("Registration")
          .doc(registrationId)
          .get()
          .then((DocumentSnapshot document) {
        return Registration.fromJson(
            document.id, document.data() as Map<String, dynamic>);
          });
          return newRegistrationData;      
  }
}