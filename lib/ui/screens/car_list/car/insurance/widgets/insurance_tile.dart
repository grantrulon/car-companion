import 'package:car_companion/controller/current_car.dart';
import 'package:car_companion/ui/screens/car_list/car/insurance/insurance_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/*
Notes:


*/

class InsuranceTile extends ConsumerWidget {
  const InsuranceTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var currentCar = ref.watch(currentCarProvider);

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
                  Text("Insurance", style: TextStyle(fontWeight: FontWeight.bold),),
                  Spacer(),
                 Container(
                                width: 30,
                                height: 25,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: AssetImage("assets/insurance_icon.png"),
                                  
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
              Spacer(),
              Padding(
                padding:
                    EdgeInsets.only(left: 6, right: 6, top: 6, bottom: 6),
                child: Text(value.insurance!.provider, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              ),
              Spacer(),
            ])),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => InsuranceDetailsScreen()));
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
