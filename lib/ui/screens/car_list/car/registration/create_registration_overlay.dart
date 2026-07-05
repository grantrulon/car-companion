import 'package:car_companion/controller/cars_controller.dart';
import 'package:car_companion/service/file_upload/add_photo.dart';
import 'package:car_companion/service/file_upload/new_file_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class CreateRegistrationOverlay extends ConsumerStatefulWidget {
  CreateRegistrationOverlay({super.key});

  @override
  CreateRegistrationOverlayState createState() =>
      CreateRegistrationOverlayState();
}

class CreateRegistrationOverlayState
    extends ConsumerState<CreateRegistrationOverlay> {
  CreateRegistrationOverlayState();

  bool _submitDisabled = false;
  DateTime? _selectedExpirationDate;

  final plateController = TextEditingController();
  final stateController = TextEditingController();
  final expirationDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var newImage = ref.watch(addPhotoProvider);

    return Scaffold(
        resizeToAvoidBottomInset: false,
        extendBody: true,
        backgroundColor: Colors.transparent,
        body: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(40),
          ),
          child: ListView(children: <Widget>[
            SizedBox(
              height: 50,
              width: 50,
              child: Container(
                child: Padding(
                  padding: EdgeInsets.only(left: 200),
                  child: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      plateController.text = "";
                      stateController.text = "";
                      expirationDateController.text = "";
                      _selectedExpirationDate = null;
                      ref.read(addPhotoProvider.notifier).setImage(null);
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 65,
              width: 360,
              child: Container(
                child: Center(
                    child: Text(
                  "New Registration",
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                )),
              ),
            ),
            Padding(
              key: UniqueKey(),
              padding: EdgeInsets.all(25),
              child: Container(
                width: 200,
                height: 200,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        right: 50,
                        left: 50,
                      ),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: newImage != null
                            ? BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: FileImage(newImage),
                                ),
                                border: Border.all(
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              )
                            : BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.contain,
                                    image: AssetImage(
                                        "assets/registration_stock.png")),
                                border: Border.all(
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                      ),
                    ),
                    Positioned(
                        left: 55,
                        right: 225,
                        top: 5,
                        bottom: 150,
                        child: Container(
                            width: 20,
                            height: 30,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  ref
                                      .read(newFileServiceProvider.notifier)
                                      .pickAndCropImage(ref, "AddPhoto");
                                },
                              ),
                            )))
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: 12.0, bottom: 12.0, right: 25, left: 25.0),
              child: TextField(
                controller: plateController,
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Plate',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: 12.0, bottom: 12.0, right: 25, left: 25.0),
              child: TextField(
                controller: stateController,
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'State',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: 12.0, bottom: 12.0, right: 25, left: 25.0),
              child: TextField(
                readOnly: true,
                controller: expirationDateController,
                obscureText: false,
                decoration: InputDecoration(
                  icon: IconButton(
                    onPressed: () async {
                      final selected = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2019),
                          lastDate: DateTime(2030),
                          locale: Locale("en"));
                      if (selected != null) {
                        setState(() {
                          _selectedExpirationDate = selected;
                        });
                        expirationDateController.text = DateFormat()
                            .add_yMd()
                            .format(_selectedExpirationDate!);
                      }
                    },
                    icon: Icon(Icons.date_range,),
                  ),
                  border: OutlineInputBorder(),
                  labelText: 'Expiration Date',
                ),
              ),
            ),
            SizedBox(
              height: 65,
              width: 200,
              child: Container(
                child: Padding(
                  padding:
                      const EdgeInsets.only(top: 20.0, right: 50.0, left: 50.0),
                  child: ElevatedButton(
                    child: Text("Add Registration"),
                    onPressed: _submitDisabled
                        ? null
                        : () {
                            // TODO: creation validation (might push to controller)

                            // disable the submit button
                            setState(() {
                              _submitDisabled = true;
                            });

                            ref
                                .read(carsControllerProvider.notifier)
                                .saveNewRegistration(_selectedExpirationDate!,
                                    plateController.text, stateController.text);

                            plateController.text = "";
                            stateController.text = "";
                            Navigator.of(context).pop();
                          },
                  ),
                ),
              ),
            ),
          ]),
        ),
      )
    ;
  }
}

class RegistrationPopup<T> extends PopupRoute<T> {
  @override
  Color? get barrierColor => Colors.black.withAlpha(0x90);

  @override
  bool get barrierDismissible => false;

  @override
  String? get barrierLabel => "Create Registration";

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return Container(
        padding: EdgeInsets.only(top: 50, bottom: 50.0, left: 30, right: 30),
        child: CreateRegistrationOverlay());
  }

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}
