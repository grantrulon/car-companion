

import 'package:car_companion/data/model/car/car_model.dart';
import 'package:car_companion/data/model/registration/registration_model.dart';
import 'package:car_companion/repository/car_repository.dart';

class MockCarRepository extends CarRepository {
  @override
  Future<Car> fetchCar(String carId, String userId) async {
    return Car("test_carId", "Owner", "2000", "test_make", "test_model", "test_downloadUrl", "test_car", 1000, "brown", "test_vin", "registration_id", "maintenance_id", "insurance_id");
  }

  @override
  Future<Registration> fetchRegistration(String carId, String registrationId) async {
    return Registration("test_registrationId", "test_state", DateTime.now(), "test_carId", "test_plate", "test_imageUrl", "test_plateUrl");
  }
}