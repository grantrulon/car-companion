import 'package:car_companion/controller/cars_controller.dart';
import 'package:car_companion/ui/screens/settings/change_password_screen.dart';
import 'package:car_companion/ui/screens/settings/mileage_notifications_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:settings_ui/settings_ui.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SettingsList(sections: [
        SettingsSection(title: Text("Account"), tiles: [
          SettingsTile.navigation(
            title: Text("Email"),
            leading: Icon(Icons.email),
          ),
          SettingsTile.navigation(
            title: Text("Change Password"),
            leading: Icon(Icons.password),
            onPressed: (context) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChangePasswordScreen()));
            },
          ),
          SettingsTile(
            title: Text("Logout"),
            leading: Icon(Icons.logout),
            onPressed: (context) {
              ref.read(carsControllerProvider.notifier).logout();
            },
          ),
        ]),
        SettingsSection(title: Text("Notifications"), tiles: [
          SettingsTile.navigation(
            title: Text("Mileage"),
            leading: Icon(Icons.notification_add),
            onPressed: (context) {
              print("Supposed to change screens");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MileageNotificationsScreen()));
            },
          ),
        ])
      ]),
    );
  }
}
