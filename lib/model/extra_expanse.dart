// To parse this JSON data, do
//
//     final extraExpanseModel = extraExpanseModelFromJson(jsonString);

import 'dart:convert';

List<ExtraExpanseModel> extraExpanseModelFromJson(List<dynamic> jsonList) {
  return List<ExtraExpanseModel>.from(
    jsonList.map((x) => ExtraExpanseModel.fromJson(x as Map<String, dynamic>)),
  );
}

String extraExpanseModelToJson(List<ExtraExpanseModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ExtraExpanseModel {
  int? id;
  String? licenceNo;
  int? branchId;
  int? sessionId;
  String? price;
  String? perPersonPrice;
  String? date;
  String? remark;
  String? other1;
  String? other2;
  String? other3;
  String? other4;
  String? other5;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<StructureExpanse>? structure;

  ExtraExpanseModel({
    this.id,
    this.licenceNo,
    this.branchId,
    this.sessionId,
    this.price,
    this.perPersonPrice,
    this.date,
    this.remark,
    this.other1,
    this.other2,
    this.other3,
    this.other4,
    this.other5,
    this.createdAt,
    this.updatedAt,
    this.structure,
  });

  factory ExtraExpanseModel.fromJson(
    Map<String, dynamic> json,
  ) => ExtraExpanseModel(
    id: json["id"],
    licenceNo: json["licence_no"],
    branchId: json["branch_id"],
    sessionId: json["session_id"],
    price: json["price"],
    perPersonPrice: json["per_person_price"],
    date: json["date"],
    remark: json["remark"],
    other1: json["other1"],
    other2: json["other2"],
    other3: json["other3"],
    other4: json["other4"],
    other5: json["other5"],
    createdAt:
        json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt:
        json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    structure:
        json["structure"] == null
            ? []
            : List<StructureExpanse>.from(
              json["structure"]!.map((x) => StructureExpanse.fromJson(x)),
            ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "licence_no": licenceNo,
    "branch_id": branchId,
    "session_id": sessionId,
    "price": price,
    "per_person_price": perPersonPrice,
    "date": date,
    "remark": remark,
    "other1": other1,
    "other2": other2,
    "other3": other3,
    "other4": other4,
    "other5": other5,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "structure":
        structure == null
            ? []
            : List<dynamic>.from(structure!.map((x) => x.toJson())),
  };
}

class StructureExpanse {
  String? name;
  String? price;
  String? course;
  String? studentId;
  String? fatherName;

  StructureExpanse({
    this.name,
    this.price,
    this.course,
    this.studentId,
    this.fatherName,
  });

  factory StructureExpanse.fromJson(Map<String, dynamic> json) =>
      StructureExpanse(
        name: json["name"],
        price: json["price"],
        course: json["course"],
        studentId: json["student_id"],
        fatherName: json["father_name"],
      );

  Map<String, dynamic> toJson() => {
    "name": name,
    "price": price,
    "course": course,
    "student_id": studentId,
    "father_name": fatherName,
  };
}
