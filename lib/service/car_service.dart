import 'package:car_companion/data/model/car/car_model.dart';
import 'package:car_companion/data/model/registration/registration_model.dart';
import 'package:car_companion/repository/auth_repository.dart';
import 'package:car_companion/repository/car_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'car_service.g.dart';

// Exposing instance of CarService for rest of app
@riverpod
CarService carService(CarServiceRef ref) {
  return CarService(ref.watch(carRepositoryProvider), ref.watch(authRepositoryProvider));
}

/* 
Service class to handle all things car related
*/
class CarService {
  CarService(this.carRepository, this.authRepository);
  final CarRepository carRepository;
  final AuthRepository authRepository;

  Future<Car> fetchCar(String carId) async {
    // Find the current user's ID
    String? userId = authRepository.fetchCurrentUserId();
    if (userId == null) {
      // TODO: exception
      return Car("filler", "Owner", "0000", "Make", "Model", "filler/url",
        "nickname", 0, "color", "VIN", "registrationId", "maintenanceId", "");
    }
    return carRepository.fetchCar(carId, userId);
  }

  Future<Registration> fetchRegistration(carId) async {
    String userId = "";
    var car = await carRepository.fetchCar(carId, userId);
    return carRepository.fetchRegistration(carId, car.registrationId);
  }
  
}