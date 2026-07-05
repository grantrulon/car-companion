import 'package:car_companion/controller/current_car.dart';
import 'package:car_companion/ui/screens/car_list/car/general_car_details/chat/chat_screen.dart';
import 'package:car_companion/ui/screens/car_list/car/general_car_details/general_car_details_screen.dart';
import 'package:car_companion/ui/screens/car_list/car/insurance/create_insurance_overlay.dart';
import 'package:car_companion/ui/screens/car_list/car/insurance/widgets/insurance_tile.dart';
import 'package:car_companion/ui/base_widgets/role_wrapper.dart';
import 'package:car_companion/ui/screens/car_list/car/maintenance/widgets/maintenance_tile.dart';
import 'package:car_companion/ui/screens/car_list/car/registration/widgets/registration_tile.dart';
import 'package:car_companion/ui/screens/car_list/car/widgets/car_mileage_tile.dart';
import 'package:car_companion/ui/screens/car_list/car/registration/create_registration_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CarScreen extends ConsumerWidget {
  const CarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentCar = ref.watch(currentCarProvider);

    return switch (currentCar) {
      AsyncData(:final value) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            leading: IconButton(
              icon: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Center(child: Icon(Icons.arrow_back))),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            actions: [
              IconButton(onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatScreen(carName: "${value.year} ${value.make} ${value.model}")));
              }, icon: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Center(child: Icon(Icons.message_outlined))),),
              RoleWrapper(role: value.role, child: PopupMenuButton<String>(
                icon: CircleAvatar(
                    backgroundColor: Colors.white, child: Icon(Icons.add)),
                onSelected: (String item) {
                  if (item == "Registration") {
                    Navigator.of(context).push(RegistrationPopup<void>());
                  } else if (item == "Insurance") {
                    Navigator.of(context).push(InsurancePopup<void>());
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  if (value.registration == null)
                    const PopupMenuItem<String>(
                      value: "Registration",
                      child: Text('Registration'),
                    ),
                  if (value.insurance == null)
                    const PopupMenuItem<String>(
                      value: "Insurance",
                      child: Text('Insurance'),
                    ),
                ],
              ))
              
            ],
          ),
          extendBodyBehindAppBar: true,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  child: Stack(children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(value.downloadUrl)),
                      ),
                      height: 350.0,
                    ),
                    Container(
                      height: 350.0,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          gradient: LinearGradient(
                              begin: FractionalOffset.center,
                              end: FractionalOffset.bottomCenter,
                              colors: [
                                Color.fromARGB(255, 80, 80, 80)
                                    .withOpacity(0.0),
                                Color.fromARGB(255, 0, 0, 0),
                              ],
                              stops: [
                                0.0,
                                1.0
                              ])),
                    ),
                  ]),
                ),
                Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GeneralCarDetailsScreen()));
                    },
                    child: ListTile(
                      title: Center(
                          child: Row(children: [
                        Spacer(),
                        Text(
                          value.nickname,
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        Spacer()
                      ])),
                    ),
                  ),
                ),
                Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GeneralCarDetailsScreen()));
                    },
                    child: ListTile(
                      title: Center(
                          child: Row(children: [
                        Spacer(),
                        Text(value.year),
                        Spacer(),
                        Text(" | "),
                        Spacer(),
                        Text(value.make),
                        Spacer(),
                        Text(" | "),
                        Spacer(),
                        Text(value.model),
                        Spacer()
                      ])),
                    ),
                  ),
                ),
                CarMileageTile(),
                Visibility(
                  visible: true,
                  child: MaintenanceTile(),
                ),
                Visibility(
                  visible: value.registration != null,
                  child: RegistrationTile(),
                ),
                Visibility(
                  visible: value.insurance != null,
                  child: InsuranceTile(),
                )
              ],
            ),
          )),
      AsyncError(:final error) => Text('Error: $error'),
      _ => const Center(child: CircularProgressIndicator())
    };
  }
}
