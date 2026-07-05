class CarOverview {
  String carId;
  String role;
  String make;
  String model;
  String year;
  String downloadUrl;

  CarOverview(this.carId, this.role, this.make, this.model, this.year, this.downloadUrl);

  CarOverview.fromJson(this.carId, Map<String, dynamic> json)
    : role = json['role'] as String,
      make = json['make'] as String,
      model = json['model'] as String,
      year = json['year'] as String,
      downloadUrl = json['downloadUrl'] as String;

  CarOverview.fromJsonNew(this.carId, this.role, Map<String, dynamic> json)
    : make = json['make'] as String,
      model = json['model'] as String,
      year = json['year'] as String,
      downloadUrl = json['downloadUrl'] as String;
}
