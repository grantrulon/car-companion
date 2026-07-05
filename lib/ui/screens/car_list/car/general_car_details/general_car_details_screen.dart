import 'package:car_companion/controller/current_car.dart';
import 'package:car_companion/service/file_upload/add_photo.dart';
import 'package:car_companion/service/file_upload/new_file_service.dart';
import 'package:car_companion/ui/screens/car_list/car/general_car_details/search/user_search_screen.dart';
import 'package:car_companion/ui/base_widgets/role_wrapper.dart';
import 'package:car_companion/ui/base_widgets/file_fullscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GeneralCarDetailsScreen extends ConsumerStatefulWidget {
  const GeneralCarDetailsScreen({super.key});

  GeneralCarDetailsScreenState createState() => GeneralCarDetailsScreenState();
}

class GeneralCarDetailsScreenState
    extends ConsumerState<GeneralCarDetailsScreen> {
  final nicknameController = TextEditingController();
  final yearController = TextEditingController();
  final makeController = TextEditingController();
  final modelController = TextEditingController();
  final vinController = TextEditingController();
  final colorController = TextEditingController();

  bool _readOnly = true;

  @override
  Widget build(BuildContext context) {
    var currentCar = ref.watch(currentCarProvider);
    var newImage = ref.watch(addPhotoProvider);

    // String oldDownloadUrl = "";

    if (currentCar case AsyncData(:final value)) {
      nicknameController.text = value.nickname;
      vinController.text = value.vin;
      colorController.text = value.color;
      yearController.text = value.year;
      makeController.text = value.make;
      modelController.text = value.model;
      // oldDownloadUrl = value.downloadUrl;
    }

    return switch (currentCar) {
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
              title: Text("Car Details"),
              actions: [
                RoleWrapper(
                    role: value.role,
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
                                  .read(currentCarProvider.notifier)
                                  .updateCurrentCar(value.carId,
                                      nickname: nicknameController.text,
                                      vin: vinController.text,
                                      color: colorController.text,
                                      year: yearController.text,
                                      make: makeController.text,
                                      model: modelController.text,
                                      newImage: newImage);
                              ref
                                  .read(addPhotoProvider.notifier)
                                  .setImage(null);
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
                            right: 75,
                            left: 75,
                          ),
                          child: GestureDetector(
                            onTap: () {
                              if (newImage == null && value.downloadUrl != "") {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => FileFullscreen(
                                            url: value.downloadUrl)));
                              }
                            },
                            child: Container(
                              width: 200,
                              height: 200,
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
                                  : value.downloadUrl != ""
                                      ? BoxDecoration(
                                          image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image:
                                                NetworkImage(value.downloadUrl),
                                          ),
                                          border: Border.all(
                                            width: 2,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        )
                                      : BoxDecoration(
                                          image: DecorationImage(
                                              fit: BoxFit.contain,
                                              image: AssetImage(
                                                  "assets/car_stock.png")),
                                          border: Border.all(
                                            width: 2,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                            ),
                          ),
                        ),
                        Positioned(
                            left: 50,
                            right: 225,
                            top: 5,
                            bottom: 150,
                            child: Container(
                                width: 20,
                                height: 30,
                                child: Visibility(
                                  visible: !_readOnly,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.black,
                                      ),
                                      onPressed: () {
                                        ref
                                            .read(
                                                newFileServiceProvider.notifier)
                                            .pickAndCropImage(ref, "AddPhoto");
                                      },
                                    ),
                                  ),
                                )))
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 12.0, bottom: 12.0, right: 50, left: 50.0),
                  child: TextField(
                    readOnly: _readOnly,
                    controller: nicknameController,
                    obscureText: false,
                    decoration: _readOnly
                        ? InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Nickname',
                          )
                        : InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Nickname',
                          ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 12.0, bottom: 12.0, right: 50, left: 50.0),
                  child: Row(children: [
                    Padding(
                        padding: EdgeInsets.only(right: 12.0),
                        child: Container(
                          width: 150,
                          child: TextField(
                            readOnly: _readOnly,
                            controller: vinController,
                            obscureText: false,
                            decoration: _readOnly
                                ? InputDecoration(
                                    border: InputBorder.none,
                                    labelText: 'VIN',
                                  )
                                : InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'VIN',
                                  ),
                          ),
                        )),
                    Padding(
                        padding: EdgeInsets.only(left: 12.0),
                        child: Container(
                          width: 150,
                          child: TextField(
                            readOnly: _readOnly,
                            controller: colorController,
                            obscureText: false,
                            decoration: _readOnly
                                ? InputDecoration(
                                    border: InputBorder.none,
                                    labelText: 'Color',
                                  )
                                : InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Color',
                                  ),
                          ),
                        )),
                  ]),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 12.0, bottom: 12.0, right: 50, left: 50.0),
                  child: TextField(
                    readOnly: _readOnly,
                    controller: yearController,
                    obscureText: false,
                    decoration: _readOnly
                        ? InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Year',
                          )
                        : InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Year',
                          ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 12.0, bottom: 12.0, right: 50, left: 50.0),
                  child: TextField(
                    readOnly: _readOnly,
                    controller: makeController,
                    obscureText: false,
                    decoration: _readOnly
                        ? InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Make',
                          )
                        : InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Make',
                          ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: 12.0, bottom: 12.0, right: 50, left: 50.0),
                  child: TextField(
                    readOnly: _readOnly,
                    controller: modelController,
                    obscureText: false,
                    decoration: _readOnly
                        ? InputDecoration(
                            border: InputBorder.none,
                            labelText: 'Model',
                          )
                        : InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Model',
                          ),
                  ),
                ),
                Divider(
                  endIndent: 30,
                  indent: 30,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 12, left: 12.0),
                  child: Row(children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: 12, bottom: 12, left: 25, right: 100),
                      child: Text(
                        "Owners",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Visibility(
                      visible: !_readOnly,
                      child: Padding(
                          padding: EdgeInsets.only(
                              top: 12, bottom: 12, left: 100, right: 25),
                          child: IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      UserSearchScreen(role: "Owner")));
                            },
                          )),
                    ),
                  ]),
                ),
                for (var owner in value.owners)
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: ListTile(
                      leading: _readOnly
                          ? CircleAvatar(
                              child: Image(
                                image: NetworkImage(
                                    "https://cdn0.iconfinder.com/data/icons/communication-456/24/account_profile_user_contact_person_avatar_placeholder-512.png"),
                              ),
                            )
                          : IconButton(
                              onPressed: () {
                                var newOwnerIds = value.ownerIds;
                                newOwnerIds.remove(owner.userId);

                                ref
                                    .read(currentCarProvider.notifier)
                                    .updateCurrentCar(value.carId,
                                        ownerIds: newOwnerIds);
                              },
                              icon: Icon(Icons.delete_outline)),
                      title: Text("${owner.name} (${owner.username})"),
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.only(right: 12, left: 12.0),
                  child: Row(children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: 12, bottom: 12, left: 25, right: 100),
                      child: Text(
                        "Drivers",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Visibility(
                      visible: !_readOnly,
                      child: Padding(
                          padding: EdgeInsets.only(
                              top: 12, bottom: 12, left: 100, right: 25),
                          child: IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      UserSearchScreen(role: "Driver")));
                            },
                          )),
                    ),
                  ]),
                ),
                for (var driver in value.drivers)
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: ListTile(
                      leading: _readOnly
                          ? CircleAvatar(
                              child: Image(
                                image: NetworkImage(
                                    "https://cdn0.iconfinder.com/data/icons/communication-456/24/account_profile_user_contact_person_avatar_placeholder-512.png"),
                              ),
                            )
                          : IconButton(
                              onPressed: () {
                                var newDriverIds = value.driverIds;
                                newDriverIds.remove(driver.userId);

                                ref
                                    .read(currentCarProvider.notifier)
                                    .updateCurrentCar(value.carId,
                                        driverIds: newDriverIds);
                              },
                              icon: Icon(Icons.delete_outline)),
                      title: Text("${driver.name} (${driver.username})"),
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
