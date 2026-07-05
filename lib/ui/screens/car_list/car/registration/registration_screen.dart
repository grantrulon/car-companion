import 'package:car_companion/controller/cars_controller.dart';
import 'package:car_companion/controller/current_car.dart';
import 'package:car_companion/controller/providers.dart';
import 'package:car_companion/controller/registration_controller.dart';
import 'package:car_companion/service/file_upload/add_file.dart';
import 'package:car_companion/service/file_upload/add_photo.dart';
import 'package:car_companion/service/file_upload/new_file_service.dart';
import 'package:car_companion/service/file_upload/plate_service.dart';
import 'package:car_companion/ui/screens/car_list/car/registration/choose_plate_screen.dart';
import 'package:car_companion/ui/base_widgets/role_wrapper.dart';
import 'package:car_companion/ui/base_widgets/file_fullscreen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegistrationScreen extends ConsumerStatefulWidget {
  const RegistrationScreen({super.key, required this.carId});
  final carId;

  RegistrationScreenState createState() =>
      RegistrationScreenState(carId);
}

class RegistrationScreenState
    extends ConsumerState<RegistrationScreen> {
  RegistrationScreenState(this.carId);
  bool _readOnly = true;
  final plateController = TextEditingController();
  final stateController = TextEditingController();
  final expirationDateController = TextEditingController();

  final newKeyController = TextEditingController();
  final newValueController = TextEditingController();

  final data = ["one", "two", "three"];
  final carId;

  String dropdownValue = "Text";

  DateTime? newExpirationDate;

  @override
  Widget build(BuildContext context) {
    var currentRegistration = ref.watch(registrationControllerProvider("test_carId"));
    var newImage = ref.watch(addPhotoProvider);
    var newFile = ref.watch(addFileProvider);

    if (currentRegistration case AsyncData(:final value)) {
      // if (value.registration == null) {
      //   // Navigator.pop(context);
      //   return Center(child: CircularProgressIndicator());
      // }
      plateController.text = value.plate;
      stateController.text = value.state;
      if (newExpirationDate == null) {
        expirationDateController.text =
            DateFormat().add_yMd().format(value.expirationDate);
      }
    }

    return switch (currentRegistration) {
      AsyncData(:final value) => WillPopScope(
          onWillPop: () async {
            ref.read(addPhotoProvider.notifier).setImage(null);
            newValueController.text = "";
            newKeyController.text = "";
            return true;
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            extendBody: true,
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text("Registration Details"),
              actions: [
                if (!_readOnly)
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        ref
                            .read(carsControllerProvider.notifier)
                            .deleteRegistration(
                                value.registrationId, value.carId);
                      },
                      icon: Icon(Icons.delete_outline)),
                      RoleWrapper(role: "Owner", child: _readOnly
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
                          // ref
                          //     .read(currentCarProvider.notifier)
                          //     .updateCurrentRegistration(
                          //         value.registrationId,
                          //         value.carId,
                          //         newImage: newImage,
                          //         plate: plateController.text,
                          //         regState: stateController.text,
                          //         expirationDate: newExpirationDate);
                          // ref.read(addPhotoProvider.notifier).setImage(null);
                          // newValueController.text = "";
                          // newKeyController.text = "";
                        },
                        child: Text("Save")))
                
              ],
            ),
            body: Container(
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
              child: ListView(children: <Widget>[
                // Padding(
                //   key: UniqueKey(),
                //   padding: EdgeInsets.all(25),
                //   child: Container(
                //     width: 200,
                //     height: 200,
                //     child: Stack(
                //       fit: StackFit.expand,
                //       children: [
                //         Padding(
                //           padding: EdgeInsets.only(
                //             right: 75,
                //             left: 75,
                //           ),
                //           child: GestureDetector(
                //             onTap: () {
                //               if (newImage == null &&
                //                   value.imageUrl != "") {
                //                 Navigator.push(
                //                     context,
                //                     MaterialPageRoute(
                //                         builder: (_) => FileFullscreen(
                //                             url:
                //                                 value.imageUrl)));
                //               }
                //             },
                //             child: Container(
                //               width: 200,
                //               height: 200,
                //               decoration: newImage != null
                //                   ? BoxDecoration(
                //                       image: DecorationImage(
                //                         fit: BoxFit.fill,
                //                         image: FileImage(newImage),
                //                       ),
                //                       border: Border.all(
                //                         width: 2,
                //                       ),
                //                       borderRadius: BorderRadius.circular(12),
                //                     )
                //                   : value.registration!.imageUrl != ""
                //                       ? BoxDecoration(
                //                           image: DecorationImage(
                //                             fit: BoxFit.fill,
                //                             image: NetworkImage(
                //                                 value.registration!.imageUrl),
                //                           ),
                //                           border: Border.all(
                //                             width: 2,
                //                           ),
                //                           borderRadius:
                //                               BorderRadius.circular(12),
                //                         )
                //                       : BoxDecoration(
                //                           image: DecorationImage(
                //                               fit: BoxFit.contain,
                //                               image: AssetImage(
                //                                   "assets/registration_stock.png")),
                //                           border: Border.all(
                //                             width: 2,
                //                           ),
                //                           borderRadius:
                //                               BorderRadius.circular(12),
                //                         ),
                //             ),
                //           ),
                //         ),
                //         Positioned(
                //             left: 50,
                //             right: 225,
                //             top: 5,
                //             bottom: 150,
                //             child: Container(
                //                 width: 20,
                //                 height: 30,
                //                 child: Visibility(
                //                   visible: !_readOnly,
                //                   child: CircleAvatar(
                //                     backgroundColor: Colors.white,
                //                     child: IconButton(
                //                       icon: Icon(
                //                         Icons.edit,
                //                         color: Colors.black,
                //                       ),
                //                       onPressed: () {
                //                         ref
                //                             .read(
                //                                 newFileServiceProvider.notifier)
                //                             .pickAndCropImage(ref, "AddPhoto");
                //                       },
                //                     ),
                //                   ),
                //                 )))
                //       ],
                //     ),
                //   ),
                // ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 12.0, bottom: 12.0, right: 50, left: 50.0),
                  child: Row(
                    children: [
                      Container(
                        width: 200,
                        child: TextField(
                          controller: plateController,
                          readOnly: _readOnly,
                          obscureText: false,
                          decoration: _readOnly
                              ? InputDecoration(
                                  border: InputBorder.none,
                                  labelText: 'Plate',
                                )
                              : InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Plate',
                                ),
                        ),
                      ),
                      // Padding(
                      //   padding: EdgeInsets.only(left: 50),
                      //   child: Container(
                      //     width: 50,
                      //     height: 30,
                      //     child: _readOnly
                      //         ? Image.network(
                      //             value.registration!.plateUrl,
                      //             fit: BoxFit.fill,
                      //           )
                      //         : IconButton(
                      //           padding: EdgeInsets.zero,
                      //             onPressed: () async {
                      //               await ref.read(plateServiceProvider.notifier).fetchPlates();
                      //               Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChoosePlateScreen()));
                      //             },
                      //             icon: Icon(Icons.edit),
                      //             style: ButtonStyle(
                      //               alignment: Alignment.center,
                      //                 shape: MaterialStateProperty.all<
                      //                         RoundedRectangleBorder>(
                      //                     RoundedRectangleBorder(
                      //                         borderRadius: BorderRadius.circular(4),
                      //                         side: BorderSide(
                      //                             color: Colors.black)))),
                      //           ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 12.0, bottom: 12.0, right: 50, left: 50.0),
                  child: TextField(
                    controller: stateController,
                    readOnly: _readOnly,
                    obscureText: false,
                    decoration: _readOnly
                        ? InputDecoration(
                            border: InputBorder.none,
                            labelText: 'State',
                          )
                        : InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'State',
                          ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 12.0, bottom: 12.0, right: 50, left: 50.0),
                  child: TextField(
                    controller: expirationDateController,
                    readOnly: true,
                    obscureText: false,
                    decoration: _readOnly
                        ? InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Expiration Date',
                          )
                        : InputDecoration(
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
                                    newExpirationDate = selected;
                                  });
                                  print("Updating the date text");
                                  expirationDateController.text =
                                      DateFormat().add_yMd().format(selected);
                                }
                                print(
                                    "Here is text: ${expirationDateController.text}");
                              },
                              icon: Icon(Icons.date_range),
                            ),
                            border: OutlineInputBorder(),
                            labelText: 'Expiration Date',
                          ),
                  ),
                ),
                Divider(
                  endIndent: 30,
                  indent: 30,
                ),
                Padding(
                  padding:
                      EdgeInsets.only(top: 12, bottom: 12, left: 25, right: 25),
                  child: Text(
                    "Additional Data",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                for (var dataEntry in value.moreData.entries)
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: ListTile(
                      leading: _readOnly
                          ? Icon(Icons.arrow_forward)
                          : IconButton(
                              onPressed: () {
                                var newMoreData = value.moreData;
                                newMoreData.remove(dataEntry.key);
                                newMoreData["test"] = "test";

                                ref
                                    .read(currentCarProvider.notifier)
                                    .updateCurrentRegistration(
                                        value.registrationId,
                                        value.carId,
                                        moreData: newMoreData);
                              },
                              icon: Icon(Icons.delete_outline)),
                      title: Text(dataEntry.key),
                      trailing: SizedBox(
                        width: 100,
                        child: GestureDetector(
                          onTap: () {
                            ref.read(moreDataPopupProvider.notifier).state =
                                dataEntry.value['data'];
                            Navigator.of(context).push(MoreDataPopup());
                          },
                          child: dataEntry.value["mode"] == "Text"
                              ? Text(
                                  dataEntry.value["data"],
                                  overflow: TextOverflow.ellipsis,
                                )
                              : TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                FileFullscreen(
                                                    url: dataEntry
                                                        .value["data"])));
                                  },
                                  child: Text("View Image")),
                        ),
                      ),
                    ),
                  ),
                if (!_readOnly)
                  Padding(
                    padding: EdgeInsets.only(
                        top: 12.0, bottom: 12.0, right: 25, left: 25.0),
                    child: Row(children: [
                      Padding(
                          padding: EdgeInsets.only(right: 12.0),
                          child: Container(
                            width: 150,
                            child: TextField(
                              readOnly: _readOnly,
                              controller: newKeyController,
                              obscureText: false,
                              decoration: _readOnly
                                  ? InputDecoration(
                                      border: InputBorder.none,
                                      labelText: 'Label',
                                    )
                                  : InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Label',
                                    ),
                            ),
                          )),
                      if (dropdownValue == "Text")
                        Padding(
                            padding: EdgeInsets.only(left: 12.0),
                            child: Container(
                              width: 200,
                              child: TextField(
                                readOnly: _readOnly,
                                controller: newValueController,
                                obscureText: false,
                                decoration: _readOnly
                                    ? InputDecoration(
                                        border: InputBorder.none,
                                        labelText: 'Value',
                                      )
                                    : InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Value',
                                      ),
                              ),
                            )),
                      if (dropdownValue == "Image")
                        Padding(
                            padding: EdgeInsets.only(left: 12),
                            child: Container(
                                width: 100,
                                child: IconButton(
                                  icon: Icon(Icons.upload),
                                  onPressed: () {
                                    ref
                                        .read(newFileServiceProvider.notifier)
                                        .pickAndCropImage(ref, "AddFile");
                                  },
                                ))),
                      if (dropdownValue == "Image" && newFile != null)
                        Padding(
                            padding: EdgeInsets.only(),
                            child: Container(
                              width: 100,
                              child: Icon(
                                Icons.check_circle,
                                color: Color.fromARGB(255, 46, 108, 47),
                              ),
                            )),
                    ]),
                  ),
                if (!_readOnly)
                  Padding(
                    padding: EdgeInsets.only(
                        top: 12.0, bottom: 12.0, right: 25, left: 25.0),
                    child: Row(children: [
                      Padding(
                          padding: EdgeInsets.only(right: 12.0, left: 100),
                          child: Container(
                            width: 100,
                            child: ElevatedButton(
                              child: Icon(Icons.add),
                              onPressed: () async {
                                if (dropdownValue == "Text") {
// This is assuming that the value is a string
                                  var newMoreData =
                                      value.moreData;
                                  newMoreData[newKeyController.text] = {
                                    "mode": "Text",
                                    "data": newValueController.text
                                  };

                                  ref
                                      .read(currentCarProvider.notifier)
                                      .updateCurrentRegistration(
                                          value.registrationId,
                                          value.carId,
                                          moreData: newMoreData);
                                  newValueController.text = "";
                                  newKeyController.text = "";
                                } else if (dropdownValue == "Image") {
                                  var file = ref.read(addFileProvider);
                                  if (file == null) {
                                    return;
                                  }
                                  var filename = DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString();
                                  var photoRef = FirebaseStorage.instance
                                      .ref()
                                      .child(filename);
                                  await photoRef.putFile(file);
                                  var downloadUrl =
                                      await photoRef.getDownloadURL();
                                  var newMoreData =
                                      value.moreData;
                                  newMoreData[newKeyController.text] = {
                                    "mode": "Image",
                                    "data": downloadUrl
                                  };

                                  ref
                                      .read(currentCarProvider.notifier)
                                      .updateCurrentRegistration(
                                          value.registrationId,
                                          value.carId,
                                          moreData: newMoreData);
                                  newValueController.text = "";
                                  newKeyController.text = "";
                                  ref
                                      .read(addFileProvider.notifier)
                                      .setImage(null);
                                }
                              },
                            ),
                          )),
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: DropdownMenu<String>(
                            initialSelection: "Text",
                            dropdownMenuEntries: [
                              DropdownMenuEntry(
                                label: "Text",
                                value: "Text",
                              ),
                              DropdownMenuEntry(
                                label: "Image",
                                value: "Image",
                              ),
                            ],
                            onSelected: (newValue) {
                              if (newValue != null) {
                                setState(() {
                                  dropdownValue = newValue;
                                });
                              }
                            }),
                      )
                    ]),
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
