import 'package:car_companion/controller/providers.dart';
import 'package:car_companion/ui/screens/account/create_account_screen.dart';
import 'package:car_companion/ui/screens/account/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginContainer extends ConsumerWidget {
  const LoginContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int loginIndex = ref.watch(loginIndexProvider);
    if (loginIndex == 0) {
      return SignInScreen();
    } else if (loginIndex == 1) {
      return CreateAccountScreen();
    } else {
      return CircularProgressIndicator();
    }
  }
}