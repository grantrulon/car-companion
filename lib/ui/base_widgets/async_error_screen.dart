import 'package:car_companion/ui/screens/landing_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/* 
Widget that should pop up when an async error occurs with the app state
- Should send user back to the main screen to try to reload.
*/
class AsyncErrorScreen extends ConsumerWidget { 
  const AsyncErrorScreen({super.key, this.errorMessage});
  final String? errorMessage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
        child: Card(
            child: ListTile(
      title: Text("An Error Occured"),
      subtitle: errorMessage != null ? Text(errorMessage!) : Text(""),
      trailing: ElevatedButton(child: Text("Reload"), onPressed: () {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LandingScreen()), (route) => false);
      },),
    )));
  }
}
