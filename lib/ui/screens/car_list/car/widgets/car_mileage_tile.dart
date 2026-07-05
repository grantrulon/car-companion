import 'package:car_companion/controller/current_car.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
/*
Notes:
TODO: add a formatter to the mileage tile for comma separated value when readOnly
TODO: validation on the mileage text field to only input numeric values

*/

class CarMileageTile extends ConsumerStatefulWidget {
  const CarMileageTile({super.key});

  CarMileageTileState createState() => CarMileageTileState();
}

class CarMileageTileState extends ConsumerState<CarMileageTile> {
  final mileageController = TextEditingController();
  bool mileageReadOnly = true;
  String? _mileageErrorText;

  void _updateMileage() async {
    if (validateMileage(mileageController.text) != null) {
      setState(() {
        _mileageErrorText = validateMileage(mileageController.text);
      });
      return;
    }

    await ref
        .read(currentCarProvider.notifier)
        .updateMileage(int.parse(mileageController.text));
  }

  String? validateMileage(String mileage) {
    if (int.tryParse(mileage) == null) {
      return "";
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    var currentCar = ref.watch(currentCarProvider);

    if (currentCar case AsyncData(:final value)) {
      mileageController.text = value.mileage.toString();
    }

    return switch (currentCar) {
      AsyncData(:final value) => Container(
          height: 100,
          child: Card(
              child: Center(
                  child: Row(children: [
            Padding(
              padding:
                  EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
              child: Column(children: [
                Spacer(),
                Text(
                  "Mileage",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Container(
                  width: 30,
                  height: 25,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage("assets/mileage_icon.png"),
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
            Container(
              width: 75,
              child: TextField(
                keyboardType: TextInputType.number,
                controller: mileageController,
                readOnly: mileageReadOnly,
                decoration: mileageReadOnly
                    ? InputDecoration(
                        border: InputBorder.none,
                        errorText: _mileageErrorText,
                      )
                    : InputDecoration(
                        border: UnderlineInputBorder(),
                        errorText: _mileageErrorText,
                      ),
              ),
            ),
            mileageReadOnly
                ? IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      if (mileageReadOnly == true) {
                        var mileage = value.mileage;
                        print(mileage);
                        mileageController.text = value.mileage.toString();
                      }

                      setState(() {
                        mileageReadOnly = !mileageReadOnly;
                      });
                    },
                  )
                : IconButton(
                    onPressed: () => _updateMileage(),
                    icon: Icon(Icons.save),
                  ),
            Spacer()
          ])))),
      _ => Card(
          child: ListTile(
              title: Center(
            child: Text("Nothing here"),
          )),
        ),
    };
  }
}
