import 'package:car_companion/controller/current_car.dart';
import 'package:car_companion/data/model/maintenance/maintenance_model.dart';
import 'package:car_companion/ui/screens/car_list/car/maintenance/maintenance_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/*
Notes:


*/

class MaintenanceTile extends ConsumerWidget {
  const MaintenanceTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var currentCar = ref.watch(currentCarProvider);

    MaintenanceRecord? recentRecord = null;
    if (currentCar case AsyncData(:final value)) {
      var sortedRecords = value.maintenance!.pastMaintenanceRecords;
      sortedRecords.sort((a, b) => a.date.compareTo(b.date));
      if (!sortedRecords.isEmpty) {
        recentRecord = sortedRecords.first;
      }
    }

    return switch (currentCar) {
      AsyncData(:final value) => Container(
          height: 100,
          child: Card(
              child: InkWell(
            child: Center(
                child: Row(children: [
              Padding(
                padding:
                    EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
                child: Column(children: [
                  Spacer(),
                  Text("Maintenance", style: TextStyle(fontWeight: FontWeight.bold),),
                  Spacer(),
                 Container(
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: AssetImage("assets/maintenance_icon.png"),
                                  
                                ),
                              ),
                            ),
                            Spacer()
                ]),
              ),
              VerticalDivider(
                indent: 12,
                endIndent: 12,
                thickness: 2.0,
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: 12, right: 6, top: 6, bottom: 6),
                child: Text(recentRecord != null ? "${recentRecord.date.month}/${recentRecord.date.day}/${recentRecord.date.year}": ""),
              ),
              Padding(
                padding:
                    EdgeInsets.only(left: 6, right: 6, top: 6, bottom: 6),
                child: Text(recentRecord != null ? recentRecord.description : "No Recent Record Data"),
              ),
            ])),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MaintenanceScreen()));
            },
          ))),
      _ => Card(
          child: ListTile(
              title: Center(
            child: Text("Error"),
          )),
        ),
    };
  }
}
