import 'package:car_companion/controller/current_car.dart';
import 'package:car_companion/ui/screens/car_list/car/registration/registration_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/*
Notes:


*/

class RegistrationTile extends ConsumerWidget {
  const RegistrationTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var currentCar = ref.watch(currentCarProvider);

    return switch (currentCar) {
      AsyncData(:final value) => Container(
          height: 150,
          child: Card(
              child: InkWell(
            child: Center(
                child: Row(children: [
              Padding(
                padding:
                    EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
                child: Column(children: [
                  Spacer(),
                  Text(
                    "Registration",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  Container(
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage("assets/registration_icon.png"),
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
                    EdgeInsets.only(left: 25, right: 25, top: 25, bottom: 25),
                child: Stack(children: [
                  Container(
                    width: 200,
                    height: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(value.registration!.plateUrl)),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          value.registration?.plate ?? "",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 36.0,
                              color: const Color.fromARGB(255, 31, 71, 33)),
                        )),
                  ),
                ]),
              ),
            ])),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RegistrationDetailsScreen()));
            },
          ))),
      _ => Card(
          child: ListTile(
              title: Center(
            child: Text("Nothing here"),
          )),
        ),
    };
  }
}
