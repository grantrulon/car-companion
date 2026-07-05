// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:car_companion/controller/cars_controller.dart';
import 'package:car_companion/controller/registration_controller.dart';
import 'package:car_companion/data/model/registration/registration_model.dart';
import 'package:car_companion/main.dart';
import 'package:car_companion/ui/screens/car_list/car/registration/registration_screen.dart';
import 'package:car_companion/ui/screens/car_list/car_list_screen.dart';
import 'package:car_companion/ui/screens/car_list/widgets/car_list_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';




void registrationScreenTests(TestWidgetsFlutterBinding binding) {
  MockRegistrationController mockRegistrationController = MockRegistrationController();

  group('Registration Screen Tests', () {
    testWidgets('On screen load, test registration should be displayed in the text fields', (tester) async {

      await tester.pumpWidget(ProviderScope(overrides: [
        registrationControllerProvider("test_carId").overrideWith(() => mockRegistrationController),
      ], child: const RegistrationScreen(carId: "test_carId",)));

      // await tester.pump();
      // await tester.pumpAndSettle();

      expect(find.byType(TextField), findsNWidgets(3));


    });
  });
}
