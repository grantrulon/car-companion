import 'package:car_companion/data/model/registration/registration_model.dart';
import 'package:car_companion/service/car_service.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'registration_controller.g.dart';

@riverpod
class RegistrationController extends _$RegistrationController {

  

  @override
  FutureOr<Registration> build(String carId) async {
    return fetchCurrentRegistration(carId);
  }

  Future<Registration> fetchCurrentRegistration(String carId) async {
    // call on the current car service to return the current car data
    // return the registration portion
    return await ref.read(carServiceProvider).fetchRegistration(carId);
  }



}

@riverpod
class MockRegistrationController extends _$RegistrationController with Mock implements RegistrationController {
  @override
  FutureOr<Registration> build(String carId) {
    return fetchCurrentRegistration("test_carId");
  }

  @override
  Future<Registration> fetchCurrentRegistration(String carId) async {
    return Registration("test_registrationId", "test_state", DateTime.now(), carId, "test_plate", "test_imageUrl", "test_plateUrl");
  }
  
}
