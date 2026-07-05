


class Insurance {
  Insurance(this.insuranceId, this.provider, this.expirationDate, this.carId, this.policyNumber, this.imageUrl);
  String insuranceId;
  String provider;
  DateTime expirationDate;
  String carId;
  String policyNumber;
  String imageUrl;
  // List<String> insuredIds = [];
  Map<String, dynamic> moreData = Map<String, dynamic>();

  Insurance.fromJson(String insuranceId, Map<String, dynamic> json) 
    : this.insuranceId = insuranceId,
      provider = json['provider'] as String,
      policyNumber = json['policyNumber'],
      expirationDate = DateTime.parse(json['expirationDate'] as String),
      carId = json['carId'] as String,
      imageUrl = json['imageUrl'],
      moreData = json['moreData'] as Map<String, dynamic>;

}