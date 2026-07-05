


class MileageNotificationModel {
  MileageNotificationModel(this.mileageNotificationId, this.userId, this.notificationsOn, this.frequency);
  String mileageNotificationId;
  String userId;
  bool notificationsOn;
  String frequency;

  MileageNotificationModel.fromJson(String mileageNotificationId, Map<String, dynamic> json)
    : this.mileageNotificationId = mileageNotificationId,
      userId = json['userId'] as String,
      notificationsOn = json['notificationsOn'] as bool,
      frequency = json['frequency'] as String;
}