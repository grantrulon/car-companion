import 'package:car_companion/service/notification/mileage_notification_service.dart';
import 'package:car_companion/ui/base_widgets/async_error_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MileageNotificationsScreen extends ConsumerStatefulWidget {
  const MileageNotificationsScreen({super.key});

  @override
  MileageNotificationsScreenState createState() =>
      MileageNotificationsScreenState();
}

class MileageNotificationsScreenState
    extends ConsumerState<MileageNotificationsScreen> {
  bool notificationsOn = true;
  final MaterialStateProperty<Icon?> thumbIcon =
      MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  );
  List<bool> _selectedFrequencies = [true, false, false];
  List<String> frequencies = ["Daily", "Weekly", "Monthly"];

  @override
  Widget build(BuildContext context) {
    var notificationState = ref.watch(mileageNotificationServiceProvider);

    if (notificationState case AsyncData(:final value)) {
      notificationsOn = value.notificationsOn;
      _selectedFrequencies =
          frequencies.map((e) => e == value.frequency).toList();
    }

    return switch (notificationState) {
      AsyncData() => Scaffold(
          resizeToAvoidBottomInset: false,
          extendBody: true,
          backgroundColor: Color.fromARGB(0, 255, 255, 255),
          appBar: AppBar(
            title: Text("Mileage Notifications"),
          ),
          body: Container(
            decoration: BoxDecoration(
              color: Colors.grey,
            ),
            child: ListView(children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(
                      top: 6.0, bottom: 6.0, right: 50, left: 50.0),
                  child: Text(
                    "Enable mileage update reminder notifications",
                  )),
              Padding(
                padding: EdgeInsets.only(
                    top: 6.0, bottom: 6.0, right: 50, left: 50.0),
                child: Switch(
                  thumbIcon: thumbIcon,
                  value: notificationsOn,
                  onChanged: (bool newValue) {
                    setState(() {
                      notificationsOn = newValue;
                    });
                    ref
                        .read(mileageNotificationServiceProvider.notifier)
                        .updateMileageNotificationSettings(
                            newValue, newValue ? "Daily" : "None");
                  },
                ),
              ),
              if (notificationsOn)
                Padding(
                    padding: EdgeInsets.only(
                        top: 12.0, bottom: 12.0, right: 50, left: 50.0),
                    child: Text(
                      "Frequency",
                    )),
              if (notificationsOn)
                Padding(
                  padding: EdgeInsets.only(
                      top: 12.0, bottom: 12.0, right: 50, left: 50.0),
                  child: ToggleButtons(
                    direction: Axis.horizontal,
                    onPressed: (int index) {
                      setState(() {
                        for (int i = 0; i < _selectedFrequencies.length; i++) {
                          _selectedFrequencies[i] = i == index;
                        }
                      });
                      ref
                          .read(mileageNotificationServiceProvider.notifier)
                          .updateMileageNotificationSettings(
                              notificationsOn, frequencies[index]);
                    },
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    fillColor: Colors.green[300],
                    constraints: const BoxConstraints(
                      minHeight: 40.0,
                      minWidth: 80.0,
                    ),
                    isSelected: _selectedFrequencies,
                    children: const [
                      Text("Daily"),
                      Text("Weekly"),
                      Text("Monthly")
                    ],
                  ),
                ),
            ]),
          ),
        ),
      AsyncError(:final error) => AsyncErrorScreen(
          errorMessage: error.toString(),
        ),
      _ => AsyncErrorScreen()
    };
  }
}
