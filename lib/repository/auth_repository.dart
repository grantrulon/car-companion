import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

// Exposing instance of AuthRepository for rest of app
@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepository();
}

/* 
Repository class that interacts with Firebase Auth API for User data
*/
class AuthRepository {

  User? get currentUser {
    return FirebaseAuth.instance.currentUser;
  }

  String fetchCurrentUserId() {
    return FirebaseAuth.instance.currentUser?.uid ?? "";
  }


}
