class Maintenance {
  Maintenance(
      this.carId, this.plannedMaintenanceRecords, this.pastMaintenanceRecords);
  String carId;
  List<MaintenanceRecord> plannedMaintenanceRecords = [];
  List<MaintenanceRecord> pastMaintenanceRecords = [];

  // Maintenance.fromJson(Map<String, dynamic> json)
  //     : this.carId = json['carId'] as String,
  //       this.plannedMaintenanceRecords =
  //           (json['plannedMaintenanceRecords'] as List<dynamic>).length == 0
  //               ? []
  //               : [
  //                   ...(json['plannedMaintenanceRecords'] as List<dynamic>)
  //                       .map((value) => MaintenanceRecord.fromJson(value))
  //                 ],
  //       this.pastMaintenanceRecords =
  //           (json['pastMaintenanceRecords'] as List<dynamic>).length == 0
  //               ? []
  //               : [
  //                   ...(json['pastMaintenanceRecords'] as List<dynamic>)
  //                       .map((value) => MaintenanceRecord.fromJson(value))
  //                 ];

  // Map<String, dynamic> toJson() {
  //   return {
  //     "carId": this.carId,
  //     "plannedMaintenanceRecords": [
  //       ...this.plannedMaintenanceRecords.map((record) => record.toJson())
  //     ],
  //     "pastMaintenanceRecords": [
  //       ...this.pastMaintenanceRecords.map((record) => record.toJson())
  //     ],
  //   };
  // }
}

class MaintenanceRecord {
  MaintenanceRecord(this.recordId, this.date, this.description,
      this.moreDetails, this.type, this.carId);

  String recordId;
  DateTime date;
  String description;
  String moreDetails;
  String type;
  String carId;

  MaintenanceRecord.fromJson(String recordId, Map<String, dynamic> json)
      : this.recordId = recordId,
        this.carId = json['carId'] as String,
        this.date = DateTime.parse(json['date'] as String),
        this.description = json['description'] as String,
        this.moreDetails = json['moreDetails'] as String,
        this.type = json['type'] as String;

  Map<String, dynamic> toJson() {
    return {
      "description": this.description,
      "carId": this.carId,
      "moreDetails": this.moreDetails,
      "date": this.date.toIso8601String(),
      "type": this.type,
    };
  }
}
