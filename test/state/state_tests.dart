// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:math';

import 'package:car_companion/controller/current_car.dart';
import 'package:car_companion/data/model/car/car_model.dart';
import 'package:car_companion/repository/car_repository.dart';
import 'package:car_companion/service/car_service.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mocks/mock_auth_repository.dart';
import '../mocks/mock_car_respository.dart';

class MockCurrentCar extends CurrentCar with Mock {
  @override
  AsyncValue<Car> get state => state;

  @override
  set state(AsyncValue<Car> newState) {
    super.state = newState;
  }
}

void stateTests(TestWidgetsFlutterBinding binding) {
  group('Current Car Tests', () async {
    final firestore = FakeFirebaseFirestore();
    await firestore.collection("Cars").doc("test_id_1").set({
      'role': 'Owner',
      'make': 'Honda',
      'model': 'Accord',
      'year': '2000',
      'downloadUrl':
          ''
    });

    test("When fetch owners is called for the current user,", () {
      // Mocks set up properly
      // Fake data setup properly
      // Make sure the userId used is the correct one
      // call the function
      // expectations on the state
    });
  });
}

void carServiceTests(TestWidgetsFlutterBinding binding) {
  group('Current Car Tests', () {
    var mockCarRepository = MockCarRepository();
    var mockAuthRepository = MockAuthRepository(); 
    var carService = CarService(mockCarRepository, mockAuthRepository);

    test("When fetchCar() is called, it returns the proper car data", () async {
      var testCar = await carService.fetchCar("test_carId");
      
      expect(testCar.year, "2000");
      expect(testCar.make, "test_make");
    });

    test("When fetchRegistration() is called, it returns the proper registration data", () async {
      var testRegistration = await carService.fetchRegistration("test_carId");

      expect(testRegistration.plate, "test_plate");
      expect(testRegistration.imageUrl, "test_imageUrl");
    });
  });
}

void carRepositoryTests(TestWidgetsFlutterBinding binding) {
  group('Car Repository Tests', () {
    test("", () {
      expect(1, 1);
    });
  });
}
