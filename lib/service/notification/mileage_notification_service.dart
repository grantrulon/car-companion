import 'dart:io';
import 'package:car_companion/data/model/notification/mileage_notifications_model.dart';
import 'package:car_companion/service/auth/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'mileage_notification_service.g.dart';

/* 
Notes: 
- On first build I want the state to contain the persisted notification settings
- On user edit of the settings, I want to change the local state and the persisted state and the messaging settings (if android)
- On user change, I want to fetch new data and change the messaging settings for the device

*/

@riverpod
class MileageNotificationService extends _$MileageNotificationService {
  final messaging = FirebaseMessaging.instance;
  final db = FirebaseFirestore.instance;

  @override
  FutureOr<MileageNotificationModel> build() async {
    return fetchSettings();
  }

  Future<MileageNotificationModel> fetchSettings() async {
    // Find the current user's id
    var userId = ref.read(authServiceProvider.notifier).getUserId();
    if (userId == null) {
      return MileageNotificationModel("", "", false, "None");
    }

    // Fetch the saved notification settings in firestore 
    var data = await db.collection("MileageNotification").where("userId", isEqualTo: userId).get().then((snapshot) {
      if (snapshot.docs.isEmpty || snapshot.docs.length > 1) {
        print("Error: there is no record for current user's mileage nofitication settings");
        return MileageNotificationModel("", "", false, "None");
      } else {
        return MileageNotificationModel.fromJson(snapshot.docs[0].id, snapshot.docs[0].data() as Map<String, dynamic>);
      }
    });

    // Set the devices messaging settings
    // await updateMessagingSettings(data.frequency);

    // return local state
    return data;
  }

  Future<void> updateMessagingSettings(String frequency) async {
    // make sure firebase messaging updates are only occuring on android currently
    if (!Platform.isAndroid) return;

    // unsubscribe from all topics
    await messaging.unsubscribeFromTopic("MileageDaily");
    await messaging.unsubscribeFromTopic("MileageWeekly");
    await messaging.unsubscribeFromTopic("MileageMonthly");

    // subscribe to new frequency
    if (frequency == "None") {
      return;
    } else {
      await messaging.subscribeToTopic(frequency);
    }
  }

  Future<void> updateMileageNotificationSettings(bool newNotificationsOn, String newFrequency) async {
    // extract the userId and mileageNotificationId for accessing the correct document
    var userId;
    var mileageNotificationId;
    if (state case AsyncData(:final value)) {
      userId = value.userId; 
      mileageNotificationId = value.mileageNotificationId;
    } else {
      print("Error: state is not AsyncData");
      return;
    }
    state = AsyncLoading();

    // make call to messaging to update wether the app is subscribed to 
    await updateMessagingSettings(newFrequency);
    
    // persist new data to database
    await db.collection("MileageNotification").doc(mileageNotificationId).update({
      "frequency": newFrequency,
      "notificationsOn": newNotificationsOn,
    });

    state = AsyncData(MileageNotificationModel(mileageNotificationId, userId, newNotificationsOn, newFrequency));
  }

  Future<void> handleUserChange() async {
    // fetch the new user's persisted settings
    var newData = await fetchSettings();

    // Update the device's messaging settings 
    await updateMessagingSettings(newData.frequency);
  }
}