import 'package:car_companion/controller/current_car.dart';
import 'package:car_companion/data/model/car/car_overview_model.dart';
import 'package:car_companion/ui/screens/car_list/car/car_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CarListTile extends ConsumerWidget {
  const CarListTile({super.key, required this.carData});
  final CarOverview carData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: InkWell(
        child: SizedBox(
            height: 200,
            child: Center(
                child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(25),
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(carData.downloadUrl)),
                      border: Border.all(
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(25),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                            "${carData.year} ${carData.make} ${carData.model}"),
                        Container(
                          width: 100,
                          child: Divider(
                            color: Colors.black,
                            thickness: 1,
                            indent: 0,
                            endIndent: 0,
                          ),
                        ),
                        Text(carData.role)
                      ]),
                ),
              ],
            ))),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CarScreen()),
          );
          ref
              .read(currentCarProvider.notifier)
              .fetchNewCurrentCar(carData.carId);
        },
      ),
    );
  }
}
