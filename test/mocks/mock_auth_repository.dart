


import 'package:car_companion/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MockAuthRepository extends AuthRepository {
  @override
  String fetchCurrentUserId() {
    return "test_userId";
  }
}
