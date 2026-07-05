import 'package:car_companion/controller/current_car.dart';
import 'package:car_companion/controller/current_record.dart';
import 'package:car_companion/data/model/maintenance/maintenance_model.dart';
import 'package:car_companion/service/file_upload/add_photo.dart';
import 'package:car_companion/ui/base_widgets/role_wrapper.dart';
import 'package:car_companion/ui/screens/car_list/car/maintenance/record/create_record_overlay.dart';
import 'package:car_companion/ui/screens/car_list/car/maintenance/record/record_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MaintenanceScreen extends ConsumerStatefulWidget {
  const MaintenanceScreen({super.key});

  MaintenanceScreenState createState() => MaintenanceScreenState();
}

class MaintenanceScreenState extends ConsumerState<MaintenanceScreen> {
  final nicknameController = TextEditingController();
  final yearController = TextEditingController();
  final makeController = TextEditingController();
  final modelController = TextEditingController();
  final vinController = TextEditingController();
  final colorController = TextEditingController();

  bool _readOnly = true;

  @override
  Widget build(BuildContext context) {
    var currentCar = ref.watch(currentCarProvider);
    var newImage = ref.watch(addPhotoProvider);
    ref.watch(currentRecordProvider);

    String oldDownloadUrl = "";

    if (currentCar case AsyncData(:final value)) {
      nicknameController.text = value.nickname;
      vinController.text = value.vin;
      colorController.text = value.color;
      yearController.text = value.year;
      makeController.text = value.make;
      modelController.text = value.model;
      oldDownloadUrl = value.downloadUrl;

      print(value.maintenance!.plannedMaintenanceRecords);
    }

    return switch (currentCar) {
      AsyncData(:final value) => WillPopScope(
          onWillPop: () async {
            ref.read(addPhotoProvider.notifier).setImage(null);
            return true;
          },
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              extendBody: true,
              backgroundColor: Color.fromARGB(0, 235, 233, 233),
              appBar: AppBar(
                title: Text("Maintenance"),
                actions: [
                  RoleWrapper(role: value.role, child: IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                            MaintenancePopup<void>(initialValue: "planned"));
                      },
                      icon: Icon(Icons.add)))
                  
                ],
              ),
              body: Container(
                decoration: BoxDecoration(
                  color: Colors.grey,
                ),
                child: ListView(children: [
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: ExpansionTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      initiallyExpanded: true,
                      title: Text(
                        "Planned",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      children: <Widget>[
                        for (var record
                            in value.maintenance!.plannedMaintenanceRecords)
                          _buildExpandableContent(record),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: ExpansionTile(
                      controlAffinity: ListTileControlAffinity.leading,
                      initiallyExpanded: true,
                      title: Text(
                        "Past",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      children: <Widget>[
                        for (var record
                            in value.maintenance!.pastMaintenanceRecords)
                          _buildExpandableContent(record),
                      ],
                    ),
                  ),
                ]),
              )),
        ),
      AsyncError(:final error) => Text('Error: $error'),
      _ => const Center(child: CircularProgressIndicator())
    };
  }

  _buildExpandableContent(MaintenanceRecord record) {
    print(record.description);
    return GestureDetector(
      child: ListTile(
        title: Text(
          record.description,
          style: TextStyle(fontSize: 18.0),
        ),
        trailing: Text(
          "${record.date.month}/${record.date.day}/${record.date.year}",
          style: TextStyle(fontSize: 18.0),
        ),
      ),
      onTap: () async {
        await ref
            .read(currentRecordProvider.notifier)
            .fetchNewCurrentRecord(record.recordId);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => RecordDetailsScreen()));
      },
    );
  }
}
