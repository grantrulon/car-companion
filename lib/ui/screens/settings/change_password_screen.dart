import 'package:car_companion/controller/cars_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ChangePasswordScreenState createState() => ChangePasswordScreenState();
}

class ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<void> state = ref.watch(carsControllerProvider);
    ref.listen<AsyncValue<void>>(
      carsControllerProvider,
      (_, state) => state.whenOrNull(
        data: (data) {
          oldPasswordController.text = "";
          newPasswordController.text = "";
          Navigator.pop(context);
        },
        error: (error, stackTrace) {
          // show snackbar if an error occurred
          newPasswordController.text = "";
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(error.toString()), duration: Duration(seconds: 10),),
          );
        },
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Change Password"),
      ),
      body: state.isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    top: 100.0, left: 24.0, right: 24.0, bottom: 12.0),
                child: TextField(
                  controller: oldPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Old Password',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: 12.0, left: 24.0, right: 24.0, bottom: 12.0),
                child: TextField(
                  controller: newPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'New Password',
                  ),
                ),
              ),
              SizedBox(
                height: 65,
                width: 360,
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: ElevatedButton(
                      child: Text("Save"),
                      onPressed: () {
                          ref
                            .read(carsControllerProvider.notifier)
                            .changePassword(oldPasswordController.text,
                                newPasswordController.text);
                      },
                    ),
                  ),
                ),
              ),
            ])),
    );
  }
}
