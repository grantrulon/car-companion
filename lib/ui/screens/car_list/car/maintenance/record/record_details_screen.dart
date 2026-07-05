import 'package:car_companion/controller/current_car.dart';
import 'package:car_companion/controller/current_record.dart';
import 'package:car_companion/service/file_upload/add_photo.dart';
import 'package:car_companion/ui/base_widgets/role_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class RecordDetailsScreen extends ConsumerStatefulWidget {
  const RecordDetailsScreen({super.key});

  RecordDetailsScreenState createState() => RecordDetailsScreenState();
}

class RecordDetailsScreenState extends ConsumerState<RecordDetailsScreen> {
  final descriptionController = TextEditingController();
  final moreDetailsController = TextEditingController();
  final dateController = TextEditingController();
  DateTime? _selectedDate;
  List<bool> _selectedTypes = [false, false];
  String? _selectedType;

  bool _readOnly = true;

  @override
  Widget build(BuildContext context) {
    var currentRecord = ref.watch(currentRecordProvider);
    var currentCar = ref.watch(currentCarProvider);

    if (currentRecord case AsyncData(:final value)) {
      descriptionController.text = value.description;
      moreDetailsController.text = value.moreDetails;
      if (_selectedType == null) {
        _selectedTypes = [value.type == "past", value.type == "planned"];
      }

      if (_selectedDate == null) {
        dateController.text =
            "${value.date.month}/${value.date.day}/${value.date.year}";
      } else {
        dateController.text =
            "${_selectedDate?.month}/${_selectedDate?.day}/${_selectedDate?.year}";
      }
    }

    var role = "Driver";
    if (currentCar case AsyncData(:final value)) {
      role = value.role;
    }

    return switch (currentRecord) {
      AsyncData(:final value) => WillPopScope(
          onWillPop: () async {
            ref.read(addPhotoProvider.notifier).setImage(null);
            return true;
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            extendBody: true,
            backgroundColor: Color.fromARGB(0, 255, 255, 255),
            appBar: AppBar(
              title: Text("Maintenance Record"),
              actions: [
                RoleWrapper(
                    role: role,
                    child: _readOnly
                        ? TextButton(
                            onPressed: () {
                              setState(() {
                                _readOnly = false;
                              });
                            },
                            child: Text("Edit"))
                        : TextButton(
                            onPressed: () async {
                              setState(() {
                                _readOnly = true;
                              });
                              ref
                                  .read(currentRecordProvider.notifier)
                                  .updateCurrentRecord(
                                      description: descriptionController.text,
                                      moreDetails: moreDetailsController.text,
                                      date: _selectedDate,
                                      type: _selectedTypes[0]
                                          ? "past"
                                          : "planned");
                            },
                            child: Text("Save")))
              ],
            ),
            body: Container(
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
              child: ListView(children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      top: 12.0, bottom: 12.0, right: 50, left: 50.0),
                  child: TextField(
                    readOnly: _readOnly,
                    controller: descriptionController,
                    obscureText: false,
                    decoration: _readOnly
                        ? InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Description',
                          )
                        : InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Description',
                          ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 12.0, bottom: 12.0, right: 50, left: 50.0),
                  child: TextField(
                    readOnly: _readOnly,
                    controller: moreDetailsController,
                    obscureText: false,
                    decoration: _readOnly
                        ? InputDecoration(
                            border: InputBorder.none,
                            labelText: 'More Details',
                          )
                        : InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'More Details',
                          ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 12.0, bottom: 12.0, right: 50, left: 50.0),
                  child: TextField(
                    controller: dateController,
                    readOnly: true,
                    obscureText: false,
                    decoration: _readOnly
                        ? InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Date',
                          )
                        : InputDecoration(
                            icon: IconButton(
                              onPressed: () async {
                                final selected = await showDatePicker(
                                    context: context,
                                    initialDate: _selectedDate == null
                                        ? value.date
                                        : _selectedDate ?? DateTime.now(),
                                    firstDate: DateTime(2019),
                                    lastDate: DateTime(2030),
                                    locale: Locale("en"));
                                if (selected != null) {
                                  setState(() {
                                    _selectedDate = selected;
                                  });
                                  print("Updating the date text");
                                  dateController.text =
                                      DateFormat().add_yM().format(selected);
                                }
                                print("Here is text: ${dateController.text}");
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
                      top: 12.0, bottom: 12.0, right: 50, left: 50.0),
                  child: ToggleButtons(
                    direction: Axis.horizontal,
                    onPressed: _readOnly
                        ? (int index) {}
                        : (int index) {
                            setState(() {
                              _selectedType = index.toString();
                              for (int i = 0; i < _selectedTypes.length; i++) {
                                _selectedTypes[i] = i == index;
                              }
                            });
                          },
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    // selectedBorderColor: Colors.red[700],
                    // selectedColor: Colors.white,
                    fillColor:
                        _readOnly ? Colors.green[100] : Colors.green[300],
                    // color: Colors.red[400],
                    constraints: const BoxConstraints(
                      minHeight: 40.0,
                      minWidth: 80.0,
                    ),
                    isSelected: _selectedTypes,
                    children: [Text("past"), Text("planned")],
                  ),
                ),
              ]),
            ),
          ),
        ),
      AsyncError(:final error) => Text('Error: $error'),
      _ => const Center(child: CircularProgressIndicator())
    };
  }
}
