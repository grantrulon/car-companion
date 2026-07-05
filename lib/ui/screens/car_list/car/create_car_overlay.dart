import 'dart:convert';
import 'package:car_companion/controller/cars_controller.dart';
import 'package:car_companion/service/file_upload/add_photo.dart';
import 'package:car_companion/service/file_upload/new_file_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class CreateCarOverlay extends ConsumerStatefulWidget {
  CreateCarOverlay({super.key});

  @override
  CreateCarOverlayState createState() => CreateCarOverlayState();
}

class CreateCarOverlayState extends ConsumerState<CreateCarOverlay> {
  CreateCarOverlayState();

  bool _submitDisabled = false;
  bool _lookupDisabled = false;

  final nicknameController = TextEditingController();
  final vinController = TextEditingController();
  final yearController = TextEditingController();
  final makeController = TextEditingController();
  final modelController = TextEditingController();
  final colorController = TextEditingController();
  final mileageController = TextEditingController();

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
                    nicknameController.text = "";
                    vinController.text = "";
                    yearController.text = "";
                    makeController.text = "";
                    modelController.text = "";
                    colorController.text = "";
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
                "New Car",
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
                                  image: AssetImage("assets/car_stock.png")),
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
            padding:
                EdgeInsets.only(top: 12.0, bottom: 12.0, right: 25, left: 25.0),
            child: TextField(
              controller: nicknameController,
              obscureText: false,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nickname',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(top: 12.0, bottom: 12.0, right: 25, left: 25.0),
            child: Row(children: [
              Padding(
                  padding: EdgeInsets.only(right: 12.0),
                  child: Container(
                    width: 200,
                    child: TextField(
                      controller: vinController,
                      obscureText: false,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'VIN',
                          labelStyle: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  )),
              ElevatedButton(
                  style: TextButton.styleFrom(
                      textStyle: TextStyle(fontWeight: FontWeight.bold)),
                  onPressed: _lookupDisabled
                      ? null
                      : () {
                          setState(() {
                            _lookupDisabled = true;
                          });
                          http.get(
                              Uri.parse(
                                  "http://api.carmd.com/v3.0/decode?vin=${vinController.text}"),
                              headers: {
                                "content-type": "application/json",
                                "authorization":
                                    "Basic YjgzZDRhZGYtNWRmYS00ZDY0LWEzZGEtNWMyOWIzYTc0YWQy",
                                "partner-token":
                                    "ec84d6dbfd3f4365b81f5e64cbb59c46"
                              }).then((value) {
                            Map<String, dynamic> body = jsonDecode(value.body);
                            print(body);
                            if (body["message"]["message"] != "ok") {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Error: VIN Not Found"),
                                  duration: Duration(seconds: 10),
                                ),
                              );
                            } else {
                              yearController.text =
                                  body["data"]["year"].toString();
                              makeController.text = body["data"]["make"];
                              modelController.text = body["data"]["model"];
                            }
                          }, onError: (e) => print(e));
                          setState(() {
                            _lookupDisabled = false;
                          });
                        },
                  child: Text("Lookup"))
            ]),
          ),
          Padding(
            padding:
                EdgeInsets.only(top: 12.0, bottom: 12.0, right: 25, left: 25.0),
            child: TextField(
              controller: yearController,
              obscureText: false,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Year',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(top: 12.0, bottom: 12.0, right: 25, left: 25.0),
            child: TextField(
              controller: makeController,
              obscureText: false,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Make',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(top: 12.0, bottom: 12.0, right: 25, left: 25.0),
            child: TextField(
              controller: modelController,
              obscureText: false,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Model',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(top: 12.0, bottom: 12.0, right: 25, left: 25.0),
            child: TextField(
              controller: colorController,
              obscureText: false,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Color',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(top: 12.0, bottom: 12.0, right: 25, left: 25.0),
            child: TextField(
              controller: mileageController,
              obscureText: false,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Mileage',
                  labelStyle: TextStyle(fontWeight: FontWeight.bold)),
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
                  style: TextButton.styleFrom(
                      textStyle: TextStyle(fontWeight: FontWeight.bold)),
                  child: Text("Add Car"),
                  onPressed: _submitDisabled
                      ? null
                      : () {
                          // TODO: validation

                          // disable the button
                          setState(() {
                            _submitDisabled = true;
                          });
                          print("calling saveNewCar()");

                          ref.read(carsControllerProvider.notifier).saveNewCar(
                              nicknameController.text,
                              vinController.text,
                              yearController.text,
                              makeController.text,
                              modelController.text,
                              colorController.text,
                              int.parse(mileageController.text));

                          nicknameController.text = "";
                          vinController.text = "";
                          yearController.text = "";
                          makeController.text = "";
                          modelController.text = "";
                          colorController.text = "";
                          Navigator.of(context).pop();
                        },
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class CarPopup<T> extends PopupRoute<T> {
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
        child: CreateCarOverlay());
  }

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}
