import 'dart:io';

import 'package:car_companion/data/model/car/car_model.dart';
import 'package:car_companion/data/model/insurance/insurance_model.dart';
import 'package:car_companion/data/model/maintenance/maintenance_model.dart';
import 'package:car_companion/data/model/registration/registration_model.dart';
import 'package:car_companion/data/model/user/user_model.dart';
import 'package:car_companion/service/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';


part 'current_car.g.dart';

@riverpod
class CurrentCar extends _$CurrentCar {
  final db = FirebaseFirestore.instance;

  @override
  FutureOr<Car> build() async {
    return Car("filler", "Owner", "0000", "Make", "Model", "filler/url",
        "nickname", 0, "color", "VIN", "registrationId", "maintenanceId", "");
  }

  Future<void> fetchNewCurrentCar(String carId) async {
    state = AsyncLoading();

    // Get the current user's id
    String? userId = ref.read(authServiceProvider.notifier).getUserId();
    if (userId == null || carId == "") {
      return;
    }

    // Fetch the Car data based on the carId
    var newCurrentCarData = await db.collection("Car").doc(carId).get().then(
        (DocumentSnapshot document) {
      return document.data() as Map<String, dynamic>;
    }, onError: (error) {
      print("Error getting document ${error}");
      return;
    });

    // Fetch the user data based on the owner and driver ids
    

    // Fetch the registration data based on the id returned
    print(newCurrentCarData['registrationId']);
    Registration? newRegistrationData = null;
    if (newCurrentCarData['registrationId'] != null &&
        newCurrentCarData['registrationId'] != "") {
      newRegistrationData = await db
          .collection("Registration")
          .doc(newCurrentCarData['registrationId'])
          .get()
          .then((DocumentSnapshot document) {
        return Registration.fromJson(
            document.id, document.data() as Map<String, dynamic>);
      });
    }

    // Fetch the maintenance data
    Maintenance newMaintenanceData = Maintenance(carId, [], []);
    await db
        .collection("Maintenance")
        .where("carId", isEqualTo: carId)
        .get()
        .then((querySnapshot) {
      List<MaintenanceRecord> pastMaintenanceRecords = [];
      List<MaintenanceRecord> plannedMaintenanceRecords = [];
      for (var document in querySnapshot.docs) {
        var nextRecord = MaintenanceRecord.fromJson(
            document.id, document.data() as Map<String, dynamic>);
        if (nextRecord.type == "past") {
          pastMaintenanceRecords.add(nextRecord);
        } else if (nextRecord.type == "planned") {
          plannedMaintenanceRecords.add(nextRecord);
        } else {
          print("Error: unknown type of Maintenance Record");
          break;
        }
      }
      newMaintenanceData =
          Maintenance(carId, plannedMaintenanceRecords, pastMaintenanceRecords);
    }, onError: (e) {
      print("Error: failed to get maintenance records for current car");
    });

    // Fetch the insurance data
    Insurance? newInsurance;
    if (newCurrentCarData['insuranceId'] != null &&
        newCurrentCarData['insuranceId'] != "") {
      newInsurance = await db
          .collection("Insurance")
          .doc(newCurrentCarData['insuranceId'])
          .get()
          .then((DocumentSnapshot document) {
        return Insurance.fromJson(
            document.id, document.data() as Map<String, dynamic>);
      });
    }
    print(newInsurance?.moreData);

    // Parse the data and add any necessary supporting objects
    state = await AsyncValue.guard(() async {
      Car carData;
      if (newCurrentCarData['ownerIds'].contains(userId)) {
        carData = Car.fromJson(carId, "Owner", newCurrentCarData);
        carData.owners = await fetchOwners(carData.ownerIds);
        carData.drivers = await fetchDrivers(carData.driverIds);
        carData.registration = newRegistrationData;
        carData.maintenance = newMaintenanceData;
        carData.insurance = newInsurance;
        return carData;
      } else if (newCurrentCarData['driverIds'].contains(userId)) {
        carData = Car.fromJson(carId, "Driver", newCurrentCarData);
        carData.owners = await fetchOwners(carData.ownerIds);
        carData.drivers = await fetchDrivers(carData.driverIds);
        carData.registration = newRegistrationData;
        carData.maintenance = newMaintenanceData;
        carData.insurance = newInsurance;
        return carData;
      } else {
        print("Error: user is neither a Owner or Driver");
        return Car(
            "filler",
            "Owner",
            "0000",
            "Make",
            "Model",
            "filler/url",
            "nickname",
            0,
            "color",
            "VIN",
            "registrationId",
            "maintenanceId",
            "");
      }
    });
  }

  Future<List<User>> fetchOwners(List<dynamic> ownerIds) async {
    List<User> users = [];
    for (var ownerId in ownerIds) {
      users.add(await db.collection("User").doc(ownerId).get().then((document) {
        return User.fromJson(document.id, document.data() as Map<String, dynamic>);
      },));
    }
    return users;
  }

  Future<List<User>> fetchDrivers(List<dynamic> driverIds) async {
    List<User> users = [];
    for (var driverId in driverIds) {
      users.add(await db.collection("User").doc(driverId).get().then((document) {
        return User.fromJson(document.id, document.data() as Map<String, dynamic>);
      },));
    }
    return users;
  }

  Future<void> updateMileage(int newMileage) async {
    // Get the data that doesn't need an update
    Map<String, dynamic> saveData;
    final currentCarId;
    if (state case AsyncData(:final value)) {
      saveData = value.toJson();
      currentCarId = value.carId;
    } else {
      // return AsyncError();
      print("Error: when updating mileage, state is not AsyncData");
      return;
    }
    state = AsyncLoading();

    // Find the current user's id
    var userId = ref.read(authServiceProvider.notifier).getUserId();
    if (userId == null) {
      print("Error: the current user is null");
      return;
    }

    // Replace the mileage value with the new value, and make update call
    saveData["mileage"] = newMileage;
    await db.collection("Car").doc(currentCarId).set(saveData);
    await fetchNewCurrentCar(currentCarId);
  }

  Future<void> updateGeneralDetails(
      String newNickname,
      String newVin,
      String newColor,
      String newYear,
      String newMake,
      String newModel,
      File? newImage) async {
    Map<String, dynamic> saveData;
    final currentCarId;
    if (state case AsyncData(:final value)) {
      currentCarId = value.carId;
      saveData = value.toJson();
    } else {
      // return AsyncError();
      print("Error: when updating general details, state is not AsyncData");
      return;
    }
    state = AsyncLoading();
    saveData["nickname"] = newNickname;
    saveData["vin"] = newVin;
    saveData["color"] = newColor;
    saveData["year"] = newYear;
    saveData["make"] = newMake;
    saveData["model"] = newModel;

    if (newImage != null) {
      // Upload the image
      print("Uploading a new image ${newImage}");
      var filename = Uuid().v4().toString();
      var photoRef = FirebaseStorage.instance.ref().child(filename);
      await photoRef.putFile(newImage);
      var newDownloadUrl = await photoRef.getDownloadURL();
      print("newDownloadUrl: ${newDownloadUrl}");
      saveData['downloadUrl'] = newDownloadUrl;
    }

    var userId = ref.read(authServiceProvider.notifier).getUserId();
    await db
        .collection("UserData")
        .doc(userId)
        .collection("Cars")
        .doc(currentCarId)
        .set(saveData);
    await fetchNewCurrentCar(currentCarId);
  }

  Future<void> updateCurrentCar(String carId,
      {String? color,
      File? newImage,
      List<dynamic>? driverIds,
      List<dynamic>? ownerIds,
      String? make,
      int? mileage,
      String? model,
      String? year,
      String? vin,
      String? registrationId,
      String? insuranceId,
      String? nickname}) async {
    state = AsyncLoading();

    // Create the json to update (merge) with the old data
    Map<String, dynamic> updateData = Map<String, dynamic>();
    if (color != null) updateData["color"] = color;
    if (driverIds != null) updateData["driverIds"] = driverIds;
    if (ownerIds != null) updateData["ownerIds"] = ownerIds;
    if (make != null) updateData["make"] = make;
    if (model != null) updateData["model"] = model;
    if (year != null) updateData["year"] = year;
    if (vin != null) updateData["vin"] = vin;
    if (registrationId != null) updateData["registrationId"] = registrationId;
    if (nickname != null) updateData["nickname"] = nickname;
    if (mileage != null) updateData["mileage"] = mileage;
    if (insuranceId != null) updateData["insuranceId"] = insuranceId;

    // If there is a new image, get a new URL
    if (newImage != null) {
      var filename = Uuid().v4().toString();
      var photoRef = FirebaseStorage.instance.ref().child(filename);
      await photoRef.putFile(newImage);
      var newImageUrl = await photoRef.getDownloadURL();
      updateData['downloadUrl'] = newImageUrl;
    }

    // Persist the data
    db
        .collection("Car")
        .doc(carId)
        .set(updateData, SetOptions(merge: true))
        .then((value) => fetchNewCurrentCar(carId));
  }

  Future<void> updateCurrentRegistration(String registrationId, String carId,
      {DateTime? expirationDate,
      File? newImage,
      Map<String, dynamic>? moreData,
      String? plate,
      String? regState,
      String? plateUrl}) async {
    state = AsyncLoading();

    // Create the json to update (merge) with the old data
    Map<String, dynamic> updateData = Map<String, dynamic>();
    updateData["carId"] = carId;
    if (expirationDate != null)
      updateData["expirationDate"] = expirationDate.toIso8601String();
    if (moreData != null) updateData["moreData"] = moreData;
    if (plate != null) updateData["plate"] = plate;
    if (regState != null) updateData["state"] = regState;
    if (plateUrl != null) updateData["plateUrl"] = plateUrl;

    print(updateData);

    // If there is a new image, get a new URL
    if (newImage != null) {
      var filename = Uuid().v4().toString();
      var photoRef = FirebaseStorage.instance.ref().child(filename);
      await photoRef.putFile(newImage);
      var newImageUrl = await photoRef.getDownloadURL();
      updateData['imageUrl'] = newImageUrl;
    }

    // Persist the data
    // db
    //     .collection("Registration")
    //     .doc(registrationId)
    //     .set(updateData, SetOptions(merge: true))
    //     .then((value) => fetchNewCurrentCar(carId));
    db
        .collection("Registration")
        .doc(registrationId)
        .update(updateData)
        .then((value) => fetchNewCurrentCar(carId));
  }

  Future<void> updateCurrentInsurance(String insuranceId, String carId,
      {DateTime? expirationDate,
      File? newImage,
      Map<String, dynamic>? moreData,
      String? provider,
      String? policyNumber}) async {
    state = AsyncLoading();

    // Create the json to update (merge) with the old data
    Map<String, dynamic> updateData = Map<String, dynamic>();
    updateData["carId"] = carId;
    if (expirationDate != null)
      updateData["expirationDate"] = expirationDate.toIso8601String();
    if (moreData != null) updateData["moreData"] = moreData;
    if (provider != null) updateData["provider"] = provider;
    if (policyNumber != null) updateData["policyNumber"] = policyNumber;

    // If there is a new image, get a new URL
    if (newImage != null) {
      var filename = Uuid().v4().toString();
      var photoRef = FirebaseStorage.instance.ref().child(filename);
      await photoRef.putFile(newImage);
      var newImageUrl = await photoRef.getDownloadURL();
      updateData['imageUrl'] = newImageUrl;
    }

    // persist the data
    db
        .collection("Insurance")
        .doc(insuranceId)
        .update(updateData)
        .then((value) => fetchNewCurrentCar(carId));
  }

  Future<void> createInsurance(DateTime expirationDate, String imageUrl,
      String provider, String policyNumber) async {
    // Find the current car's id
    String carId;
    if (state case AsyncData(:final value)) {
      carId = value.carId;
    } else {
      print("Error, the current car is not AsyncData()");
      return;
    }

    // Create the registration json to save
    Map<String, dynamic> newData = {
      "carId": carId,
      "imageUrl": imageUrl,
      "expirationDate": expirationDate.toIso8601String(),
      "provider": provider,
      "policyNumber": policyNumber,
      "moreData": {}
    };

    state = AsyncLoading();

    // Persist the data to Firebase & refetch data
    db.collection("Insurance").add(newData).then((documentSnapshot) async {
      await updateCurrentCar(carId, insuranceId: documentSnapshot.id);
      await fetchNewCurrentCar(carId);
    });
  }

  Future<void> createRegistration(DateTime expirationDate, String imageUrl,
      String plate, String regState) async {
    // Find the current car's id
    String carId;
    if (state case AsyncData(:final value)) {
      carId = value.carId;
    } else {
      print("Error, the current car is not AsyncData()");
      return;
    }

    // Create the registration json to save
    Map<String, dynamic> newData = {
      "carId": carId,
      "expirationDate": expirationDate.toIso8601String(),
      "imageUrl": imageUrl,
      "plate": plate,
      "state": regState,
      "moreData": {},
      "plateUrl": "",
    };

    state = AsyncLoading();

    // Persist the data to Firebase & refetch data
    db.collection("Registration").add(newData).then((documentSnapshot) async {
      await updateCurrentCar(carId, registrationId: documentSnapshot.id);
      await fetchNewCurrentCar(carId);
    });
  }

  Future<void> deleteRegistration(String registrationId, String carId) async {
    state = AsyncLoading();
    db.collection("Registration").doc(registrationId).delete().then(
        (value) => fetchNewCurrentCar(carId),
        onError: (e) => print("Error Deleting registration"));
  }

  Future<void> deleteInsurance(String insuranceId, String carId) async {
    state = AsyncLoading();
    db.collection("Insurance").doc(insuranceId).delete().then(
        (value) => fetchNewCurrentCar(carId),
        onError: (e) => print("Error Deleting insurance"));
  }

  Future<void> createMaintenanceRecord(String description, String moreDetails,
      DateTime date, String type) async {
    // Get data to update from the current state
    // print(type);
    // Map<String, dynamic> currentData = {};
    // var currentMaintenanceId = "";
    // if (state case AsyncData(:final value)) {
    //   currentData = value.maintenance!.toJson();
    //   currentMaintenanceId = value.maintenanceId;
    // } else {
    //   print("Error: app current car not AsyncData");
    //   return;
    // }

    // Get the car id
    String carId;
    if (state case AsyncData(:final value)) {
      carId = value.carId;
    } else {
      print("Error, the current car is not AsyncData()");
      return;
    }

    state = AsyncLoading();

    // Collect new data into a saveable object
    Map<String, dynamic> saveData = {
      'description': description,
      'moreDetails': moreDetails,
      'date': date.toIso8601String(),
      'type': type,
      'carId': carId
    };

    db
        .collection("Maintenance")
        .add(saveData)
        .then((value) => fetchNewCurrentCar(carId));

    // add it to the previous data already there
    // if (type == "past") {
    //   currentData['pastMaintenanceRecords'].add(saveData);
    // } else if (type == "planned") {
    //   currentData['plannedMaintenanceRecords'].add(saveData);
    // } else {
    //   print("Error type is neither past nor planned");
    //   return;
    // }

    // use .update to change the value in the database
    // db
    //     .collection("Maintenance")
    //     .doc(currentMaintenanceId)
    //     .update(currentData)
    //     .then((value) => fetchNewCurrentCar(currentData["carId"]));
  }
}
