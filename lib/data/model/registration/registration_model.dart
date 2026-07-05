


class Registration {
  Registration(this.registrationId, this.state, this.expirationDate, this.carId, this.plate, this.imageUrl, this.plateUrl);
  String registrationId;
  String state;
  DateTime expirationDate;
  String carId;
  String plate;
  String imageUrl;
  String plateUrl;
  Map<String, dynamic> moreData = Map<String, dynamic>();

  Registration.fromJson(String registrationId, Map<String, dynamic> json) 
    : this.registrationId = registrationId,
      state = json['state'] as String,
      plate = json['plate'] as String,
      expirationDate = DateTime.parse(json['expirationDate'] as String),
      carId = json['carId'] as String,
      imageUrl = json['imageUrl'] as String,
      plateUrl = json['plateUrl'] as String,
      moreData = json['moreData'] as Map<String, dynamic>;

}