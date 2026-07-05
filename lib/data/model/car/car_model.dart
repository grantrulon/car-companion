import 'package:car_companion/data/model/insurance/insurance_model.dart';
import 'package:car_companion/data/model/maintenance/maintenance_model.dart';
import 'package:car_companion/data/model/registration/registration_model.dart';
import '../user/user_model.dart';

class Car {
  final String carId;
  final String role;
  final String year;
  final String make;
  final String model;
  final String downloadUrl;
  final String nickname;
  final int mileage;
  final String color;
  final String vin;
  String registrationId;
  String maintenanceId;
  String insuranceId;

  List<dynamic> ownerIds = [];
  List<dynamic> driverIds = [];
  List<User> owners = [];
  List<User> drivers = [];
  Maintenance? maintenance;
  Registration? registration;
  Insurance? insurance;

  Car(
      this.carId,
      this.role,
      this.year,
      this.make,
      this.model,
      this.downloadUrl,
      this.nickname,
      this.mileage,
      this.color,
      this.vin,
      this.registrationId,
      this.maintenanceId,
      this.insuranceId);

  Car.fromJson(String carIdIn, String role, Map<String, dynamic> json)
      : carId = carIdIn,
        role = role,
        year = json['year'] as String,
        make = json['make'] as String,
        model = json['model'] as String,
        downloadUrl = json['downloadUrl'] as String,
        nickname = json['nickname'] as String,
        mileage = json['mileage'] as int,
        color = json['color'] as String,
        vin = json['vin'] as String,
        registrationId = json['registrationId'] as String,
        maintenanceId = json['maintenanceId'] as String,
        insuranceId = json['insuranceId'] as String,
        ownerIds = json['ownerIds'] as List<dynamic>,
        driverIds = json['driverIds'] as List<dynamic>;

  Map<String, dynamic> toJson() {
    return {
      "year": year,
      "make": make,
      "model": model,
      "downloadUrl": downloadUrl,
      "nickname": nickname,
      "mileage": mileage,
      "color": color,
      "vin": vin,
      "registrationId": registrationId,
      "maintenanceId": maintenanceId,
      "insuranceId": insuranceId,
      "ownerIds": ownerIds,
      "driverIds": driverIds,
    };
  }
}
