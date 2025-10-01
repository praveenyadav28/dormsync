// To parse this JSON data, do
//
//     final meterReadingModel = meterReadingModelFromJson(jsonString);

import 'dart:convert';

List<MeterReadingModel> meterReadingModelFromJson(List<dynamic> jsonList) {
  return List<MeterReadingModel>.from(
    jsonList.map((x) => MeterReadingModel.fromJson(x as Map<String, dynamic>)),
  );
}

String meterReadingModelToJson(List<MeterReadingModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MeterReadingModel {
  String? id;
  String? licenceNo;
  String? branchId;
  String? sessionId;
  String? building;
  String? floor;
  String? room;
  String? opningReding;
  String? closingReding;
  String? unit;
  String? price;
  List<StudentStructure>? studentStructure;
  String? other1;
  String? other2;
  String? other3;
  String? other4;
  String? other5;
  DateTime? createdAt;
  DateTime? updatedAt;

  MeterReadingModel({
    this.id,
    this.licenceNo,
    this.branchId,
    this.sessionId,
    this.building,
    this.floor,
    this.room,
    this.opningReding,
    this.closingReding,
    this.unit,
    this.price,
    this.studentStructure,
    this.other1,
    this.other2,
    this.other3,
    this.other4,
    this.other5,
    this.createdAt,
    this.updatedAt,
  });

  factory MeterReadingModel.fromJson(
    Map<String, dynamic> json,
  ) => MeterReadingModel(
    id: json["id"] ?? "",
    licenceNo: json["licence_no"] ?? "",
    branchId: json["branch_id"] ?? "",
    sessionId: json["session_id"] ?? "",
    building: json["building"] ?? "",
    floor: json["floor"] ?? "",
    room: json["room"] ?? "",
    opningReding: json["opning_reding"] ?? "",
    closingReding: json["closing_reding"] ?? "",
    unit: json["unit"] ?? "",
    price: json["price"] ?? "",
    studentStructure:
        json["student_structure"] == null
            ? []
            : List<StudentStructure>.from(
              json["student_structure"]!.map(
                (x) => StudentStructure.fromJson(x),
              ),
            ),
    other1: json["other1"] ?? "",
    other2: json["other2"] ?? "",
    other3: json["other3"] ?? "",
    other4: json["other4"] ?? "",
    other5: json["other5"] ?? "",
    createdAt:
        json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt:
        json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "licence_no": licenceNo,
    "branch_id": branchId,
    "session_id": sessionId,
    "building": building,
    "floor": floor,
    "room": room,
    "opning_reding": opningReding,
    "closing_reding": closingReding,
    "unit": unit,
    "price": price,
    "student_structure":
        studentStructure == null
            ? []
            : List<dynamic>.from(studentStructure!.map((x) => x.toJson())),
    "other1": other1,
    "other2": other2,
    "other3": other3,
    "other4": other4,
    "other5": other5,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class StudentStructure {
  int? fees;
  String? name;
  int? studentId;

  StudentStructure({this.fees, this.name, this.studentId});

  factory StudentStructure.fromJson(Map<String, dynamic> json) =>
      StudentStructure(
        fees: json["fees"] ?? "",
        name: json["name"] ?? "",
        studentId: json["student_id"] ?? "",
      );

  Map<String, dynamic> toJson() => {
    "fees": fees,
    "name": name,
    "student_id": studentId,
  };
}
