import 'package:car_companion/controller/current_car.dart';
import 'package:car_companion/controller/providers.dart';
import 'package:car_companion/service/file_upload/plate_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChoosePlateScreen extends ConsumerStatefulWidget {
  const ChoosePlateScreen({super.key});

  ChoosePlateScreenState createState() => ChoosePlateScreenState();
}

class ChoosePlateScreenState extends ConsumerState<ChoosePlateScreen> {
  List<bool> _selectedPlates = [];

  @override
  Widget build(BuildContext context) {
    var currentCar = ref.watch(currentCarProvider);
    var plates = ref.watch(plateServiceProvider);

    var plateUrl = "";
    var currentCarId = "";
    var currentRegistrationId = "";
    if (currentCar case AsyncData(:final value)) {
      plateUrl = value.registration!.plateUrl;
      currentCarId = value.carId;
      currentRegistrationId = value.registrationId;
    }

    if (plates case AsyncData(:final value)) {
      _selectedPlates = value.map((url) => url == plateUrl).toList();
    }

    

    return switch (plates) {
      AsyncData(:final value) => WillPopScope(
          onWillPop: () async {
            return true;
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            extendBody: true,
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text("Choose Plate"),
            ),
            body: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
              child: ListView(children: <Widget>[
                ToggleButtons(
                  direction: Axis.vertical,
                  onPressed: (int index) async {
                    await ref.read(currentCarProvider.notifier).updateCurrentRegistration(currentRegistrationId, currentCarId, plateUrl: value[index]);
                  },
                  borderRadius: const BorderRadius.all(Radius.circular(4)),
                  constraints: const BoxConstraints(
                    minHeight: 80.0,
                    minWidth: 80.0,
                  ),
                  isSelected: _selectedPlates,
                  children: [
                    for (var url in value)
                      Padding(
                        padding: EdgeInsets.all(12),
                        child: Container(
                            width: 300,
                            height: 150,
                            decoration: BoxDecoration(
                                image:
                                    DecorationImage(image: NetworkImage(url)))),
                      ),
                  ],
                ),
              ]),
            ),
          )),
      AsyncError(:final error) => Text('Error: $error'),
      _ => const Center(child: CircularProgressIndicator())
    };
  }
}

class MoreDataPopup<T> extends PopupRoute<T> {
  @override
  Color? get barrierColor => Colors.black.withAlpha(0x90);

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => "Create Registration";

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return Container(
        padding: EdgeInsets.only(top: 300, bottom: 300.0, left: 50, right: 50),
        child: MoreDataText());
  }

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}

class MoreDataText extends ConsumerWidget {
  const MoreDataText({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var valueText = ref.watch(moreDataPopupProvider);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        extendBody: true,
        backgroundColor: Colors.transparent,
        body: Center(
            child: Container(
                width: 250,
                height: 250,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                    child: SingleChildScrollView(
                        child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: Text(
                        valueText,
                        style: TextStyle(),
                      ),
                    ),
                  ],
                ))))));
  }
}
