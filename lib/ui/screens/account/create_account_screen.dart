import 'package:car_companion/controller/cars_controller.dart';
import 'package:car_companion/controller/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateAccountScreen extends ConsumerStatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  CreateAccountScreenState createState() => CreateAccountScreenState();
}

class CreateAccountScreenState extends ConsumerState<CreateAccountScreen> {
  // TODO: reference this article for input validation: https://codewithandrea.com/articles/flutter-text-field-form-validation/
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Welcome to Car Companion!"),
        ),
        body: SingleChildScrollView(
          child: Column(children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 75.0),
              child: Center(
                child: Container(
                    width: 300,
                    height: 300,
                    child: Image.asset("assets/CarCompanionLogo.png")),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.0),
              child: TextField(
                controller: usernameController,
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.0),
              child: TextField(
                controller: emailController,
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.0),
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            SizedBox(
              height: 65,
              width: 360,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: ElevatedButton(
                    child: Text("Create Account"),
                    onPressed: () => {
                      ref.read(carsControllerProvider.notifier).createAccount(
                          emailController.text, passwordController.text)
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 65,
              width: 360,
              child: Container(
                child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: TextButton(
                        onPressed: () =>
                            {ref.read(loginIndexProvider.notifier).state = 0},
                        child: Text("Already Have an Account? Sign In"))),
              ),
            ),
          ]),
        ));
  }
}
