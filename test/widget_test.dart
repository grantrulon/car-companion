// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config_platform_interface/firebase_remote_config_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'mocks/mock_firebase_utils.dart';
import 'mocks/remote_config_mock.dart';
import 'screens/registration_screen_tests.dart';
import 'state/state_tests.dart';

void main() {
  final TestWidgetsFlutterBinding binding = TestWidgetsFlutterBinding.ensureInitialized();

  setupFirebaseMocks();
  FirebaseRemoteConfigPlatform.instance = mockRemoteConfigPlatform;

  setUpAll(() async {
    await Firebase.initializeApp();
    setUpRemoteConfigMocks();
  });

  group("Car Service Unit Tests", () { 
    carServiceTests(binding);
  });

  group("Registration Screen Widget Tests", () { 
    registrationScreenTests(binding);
  });
}
