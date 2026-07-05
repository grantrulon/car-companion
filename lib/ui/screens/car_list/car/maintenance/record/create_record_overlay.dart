import 'package:car_companion/controller/cars_controller.dart';
import 'package:car_companion/service/file_upload/add_photo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class CreateRecordOverlay extends ConsumerStatefulWidget {
  const CreateRecordOverlay({super.key, required this.initialValue });

  final String initialValue;

  @override
  CreateRecordOverlayState createState() =>
      CreateRecordOverlayState(initialValue);
}

class CreateRecordOverlayState
    extends ConsumerState<CreateRecordOverlay> {
  CreateRecordOverlayState(this._selectedType);

  bool _submitDisabled = false;
  DateTime? _selectedDate;

  final descriptionController = TextEditingController();
  final moreDetailsController = TextEditingController();
  final dateController = TextEditingController();
  String _selectedType;
  List<bool> _selectedTypes = [false, false];

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
                      descriptionController.text = "";
                      moreDetailsController.text = "";
                      dateController.text = "";
                      _selectedDate = null;
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
                  "New Maintenance Record",
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                )),
              ),
            ),
            
            Padding(
              padding: EdgeInsets.only(
                  top: 12.0, bottom: 12.0, right: 25, left: 25.0),
              child: TextField(
                controller: descriptionController,
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'description',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: 12.0, bottom: 12.0, right: 25, left: 25.0),
              child: TextField(
                controller: moreDetailsController,
                obscureText: false,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Notes/Details',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: 12.0, bottom: 12.0, right: 25, left: 25.0),
              child: TextField(
                readOnly: true,
                controller: dateController,
                obscureText: false,
                decoration: InputDecoration(
                  icon: IconButton(
                    onPressed: () async {
                      final selected = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2025),
                          locale: Locale("en"));
                      if (selected != null) {
                        setState(() {
                          _selectedDate = selected;
                        });
                        dateController.text = DateFormat()
                            .add_yMd()
                            .format(_selectedDate!);
                      }
                    },
                    icon: Icon(Icons.date_range),
                  ),
                  border: OutlineInputBorder(),
                  labelText: 'Date',
                ),
              ),
            ),
            Padding(
                  padding: EdgeInsets.only(
                      top: 12.0, bottom: 12.0, right: 50, left: 100.0),
                  child: ToggleButtons(
                    direction: Axis.horizontal,
                    onPressed: (int index) {
                            setState(() {
                              _selectedType = index.toString();
                              for (int i = 0; i < _selectedTypes.length; i++) {
                                _selectedTypes[i] = i == index;
                              }
                            });
                          },
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    constraints: const BoxConstraints(
                      minHeight: 40.0,
                      minWidth: 80.0,
                    ),
                    isSelected: _selectedTypes,
                    children: [Text("past"), Text("planned")],
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
                    child: Text("Add Record"),
                    onPressed: _submitDisabled
                        ? null
                        : () {
                            // TODO: creation validation (might push to controller)

                            // disable the submit button
                            setState(() {
                              _submitDisabled = true;
                            });
                            print("Calling saveNewMaintenanceRecord() with ${_selectedType}");
                            ref.read(carsControllerProvider.notifier).saveNewMaintenanceRecord(descriptionController.text, moreDetailsController.text, _selectedDate!, _selectedTypes[0] ? "past" : "planned");


                            descriptionController.text = "";
                            moreDetailsController.text = "";
                            dateController.text = "";
                            _selectedDate = null;
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

class MaintenancePopup<T> extends PopupRoute<T> {
  @override
  Color? get barrierColor => Colors.black.withAlpha(0x90);

  @override
  bool get barrierDismissible => false;

  @override
  String? get barrierLabel => "Create Maintenance Record";

  String initialValue;

  MaintenancePopup({required this.initialValue});

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return Container(
        padding: EdgeInsets.only(top: 50, bottom: 50.0, left: 30, right: 30),
        child: CreateRecordOverlay(initialValue: initialValue));
  }

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}
