import 'package:car_companion/controller/providers.dart';
import 'package:car_companion/service/notification/mileage_notification_service.dart';
import 'package:car_companion/ui/screens/car_list/car_list_screen.dart';
import 'package:car_companion/ui/screens/car_list/car/create_car_overlay.dart';
import 'package:car_companion/ui/screens/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeContainer extends ConsumerWidget {
  const HomeContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int screenIndex = ref.watch(screenIndexProvider);
    ref.watch(mileageNotificationServiceProvider);

    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Text("Car Companion"),
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(20),
              child: Divider(
                color: Colors.black,
                indent: 20,
                endIndent: 20,
              ),
            )),
        body: <Widget>[CarListScreen(), SettingsScreen()][screenIndex],
        bottomNavigationBar: NavigationBar(
          selectedIndex: screenIndex,
          destinations: const [
            NavigationDestination(
              icon:  Icon(Icons.directions_car),
              selectedIcon:  Icon(Icons.directions_car_filled_outlined),
              label: "My Cars",
            ),
            NavigationDestination(
              icon:  Icon(Icons.settings),
              selectedIcon:  Icon(Icons.settings_outlined),
              label: "Settings",
            ),
          ],
          onDestinationSelected: (int index) {
            ref.read(screenIndexProvider.notifier).state = index;
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Visibility(
      visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
      child: FloatingActionButton(
        onPressed: () async {
          Navigator.of(context).push(CarPopup());
        },
        tooltip: 'Add Car',
        child: new Icon(Icons.add),
      ),
    ));
  }
}
