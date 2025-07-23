import 'dart:convert';

List<FeesReportModel> feesReportModelFromJson(List<dynamic> jsonList) {
  return List<FeesReportModel>.from(
    jsonList.map((x) => FeesReportModel.fromJson(x as Map<String, dynamic>)),
  );
}

String feesReportModelToJson(List<FeesReportModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FeesReportModel {
  String? hostelerId;
  String? hostelerName;
  String? fatherName;
  String? admissionDate;
  int? buildingId;
  int? floorId;
  String? roomType;
  String? roomNo;
  int? emiTotal;
  int? emiRecived;
  int? totalRemaining;
  int? studentReceivedAmount;

  FeesReportModel({
    this.hostelerId,
    this.hostelerName,
    this.fatherName,
    this.admissionDate,
    this.buildingId,
    this.floorId,
    this.roomType,
    this.roomNo,
    this.emiTotal,
    this.emiRecived,
    this.totalRemaining,
    this.studentReceivedAmount,
  });

  factory FeesReportModel.fromJson(Map<String, dynamic> json) =>
      FeesReportModel(
        hostelerId: json["hosteler_id"],
        hostelerName: json["hosteler_name"],
        fatherName: json["father_name"],
        admissionDate: json["admission_date"],
        buildingId: json["building_id"],
        floorId: json["floor_id"],
        roomType: json["room_type"],
        roomNo: json["room_no"],
        emiTotal: json["EMI_total"],
        emiRecived: json["EMI_recived"],
        totalRemaining: json["total_remaining"],
        studentReceivedAmount: json["student_received_amount"],
      );

  Map<String, dynamic> toJson() => {
    "hosteler_id": hostelerId,
    "hosteler_name": hostelerName,
    "father_name": fatherName,
    "admission_date": admissionDate,
    "building_id": buildingId,
    "floor_id": floorId,
    "room_type": roomType,
    "room_no": roomNo,
    "EMI_total": emiTotal,
    "EMI_recived": emiRecived,
    "total_remaining": totalRemaining,
    "student_received_amount": studentReceivedAmount,
  };
}
