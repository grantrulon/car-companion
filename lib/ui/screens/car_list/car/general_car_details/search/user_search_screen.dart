import 'package:car_companion/controller/current_car.dart';
import 'package:car_companion/service/file_upload/add_photo.dart';
import 'package:car_companion/service/search/user_search_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserSearchScreen extends ConsumerStatefulWidget {
  const UserSearchScreen({super.key, required this.role});
  final role;

  UserSearchScreenState createState() => UserSearchScreenState(role);
}

class UserSearchScreenState
    extends ConsumerState<UserSearchScreen> {
  UserSearchScreenState(this.role);
  final searchController = TextEditingController();
  final role;

  @override
  Widget build(BuildContext context) {
    var users = ref.watch(userSearchServiceProvider);
    var currentCar = ref.watch(currentCarProvider);

    var ownerIds = [];
    var driverIds = [];
    var currentCarId = "";
    if (currentCar case AsyncData(:final value)) {
      ownerIds = value.ownerIds;
      driverIds = value.driverIds;
      currentCarId = value.carId;
    }

    

    return switch (users) {
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
              title: Text("Add ${role}"),
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
                    controller: searchController,
                    obscureText: false,
                    decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Search Users',
                          ),
                    onChanged: (newValue) {
                      ref.read(userSearchServiceProvider.notifier).searchUsers(newValue);
                      searchController.text = newValue;
                    },
                  ),
                ),
                for (var user in value)
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: ListTile(
                      leading: CircleAvatar(
                              child: Image(
                                image: NetworkImage(
                                    "https://cdn0.iconfinder.com/data/icons/communication-456/24/account_profile_user_contact_person_avatar_placeholder-512.png"),
                              ),
                            ),
                      title: Text("${user.name} (${user.username})"),
                      trailing: IconButton(icon: Icon(Icons.add_outlined), onPressed: () {
                        if (role == "Owner") {
                          ownerIds.add(user.userId);

                                ref
                                    .read(currentCarProvider.notifier)
                                    .updateCurrentCar(currentCarId,
                                        ownerIds: ownerIds);
                                Navigator.of(context).pop();
                        } else if (role == "Driver") {
                          driverIds.add(user.userId);
                                ref
                                    .read(currentCarProvider.notifier)
                                    .updateCurrentCar(currentCarId,
                                        driverIds: driverIds);
                                        Navigator.of(context).pop();

                        }
                      },),
                    ),
                  ),
              ]),
            ),
          ),
        ),
      AsyncError(:final error) => Text('Error: $error'),
      _ =>  Scaffold(
            resizeToAvoidBottomInset: false,
            extendBody: true,
            backgroundColor: Color.fromARGB(0, 255, 255, 255),
            appBar: AppBar(
              title: Text("Add ${role}"),
            ),
            body: ListView(children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      top: 12.0, bottom: 12.0, right: 50, left: 50.0),
                  child: TextField(
                    controller: searchController,
                    obscureText: false,
                    decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Search Users',
                          ),
                    onChanged: (newValue) {
                      ref.read(userSearchServiceProvider.notifier).searchUsers(newValue);
                      searchController.text = newValue;
                    },
                  ),
                ),
            
            Center(child: CircularProgressIndicator()),
            ])
          )
    };
  }
}
