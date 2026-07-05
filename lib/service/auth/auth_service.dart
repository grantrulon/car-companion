import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_service.g.dart';

class AppUser {
  AppUser(
      {required this.userId, required this.username, this.name, this.photoUrl});

  String userId;
  String username;
  String? name;
  String? photoUrl;
}

@riverpod
class AuthService extends _$AuthService {
  // var auth = FirebaseAuth.instance;
  var user;

  @override
  FirebaseAuth build() {
    return FirebaseAuth.instance;
  }

  Stream<User?> onAuthStateChange() {
    return state.authStateChanges();
  }

  String? getUserId() {
    User? user = state.currentUser;
    return user?.uid;
  }

  Future<void> login(String email, String password) async {
    try {
      await state.signInWithEmailAndPassword(email: email, password: password); 
    } catch (error) {
      print(error);
    }
  }

  Future<void> logout() async {
    try {
      await state.signOut();
    } catch (error) {
      print(error);
    }
  }

  Future<void> createAccount(String email, String password) async {
    try {
      await state.createUserWithEmailAndPassword(email: email, password: password);
    } catch (error) {
      print(error);
    }
  }

  Future<void> deleteAccount(String password) async {
    User? user = state.currentUser;
    if (user != null) {
      AuthCredential credential = EmailAuthProvider.credential(email: user.email ?? "", password: password);
      UserCredential result = await user.reauthenticateWithCredential(credential);
      await result.user?.delete();
    }
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    User? user = state.currentUser;
    if (user != null) {
      AuthCredential credential = EmailAuthProvider.credential(email: user.email ?? "", password: oldPassword);
      UserCredential result = await user.reauthenticateWithCredential(credential);
      await result.user?.updatePassword(newPassword);
    }
  }

}