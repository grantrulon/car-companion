import 'package:car_companion/controller/cars_controller.dart';
import 'package:car_companion/ui/screens/home_container.dart';
import 'package:car_companion/ui/screens/login_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

/*
Widget that returns a different widget based on the auth state of the user
*/
class LandingScreen extends ConsumerWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<User?>(
      stream: ref.read(carsControllerProvider.notifier).onAuthStateChange(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            return LoginContainer();
          }
          return HomeContainer();
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
