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
    int? id;
    String? licenceNo;
    String? branchId;
    String? sessionId;
    String? building;
    String? floor;
    List<Structure>? structure;
    dynamic other1;
    dynamic other2;
    dynamic other3;
    dynamic other4;
    dynamic other5;
    DateTime? createdAt;
    DateTime? updatedAt;

    MeterReadingModel({
        this.id,
        this.licenceNo,
        this.branchId,
        this.sessionId,
        this.building,
        this.floor,
        this.structure,
        this.other1,
        this.other2,
        this.other3,
        this.other4,
        this.other5,
        this.createdAt,
        this.updatedAt,
    });

    factory MeterReadingModel.fromJson(Map<String, dynamic> json) => MeterReadingModel(
        id: json["id"],
        licenceNo: json["licence_no"],
        branchId: json["branch_id"],
        sessionId: json["session_id"],
        building: json["building"],
        floor: json["floor"],
        structure: json["structure"] == null ? [] : List<Structure>.from(json["structure"]!.map((x) => Structure.fromJson(x))),
        other1: json["other1"],
        other2: json["other2"],
        other3: json["other3"],
        other4: json["other4"],
        other5: json["other5"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "licence_no": licenceNo,
        "branch_id": branchId,
        "session_id": sessionId,
        "building": building,
        "floor": floor,
        "structure": structure == null ? [] : List<dynamic>.from(structure!.map((x) => x.toJson())),
        "other1": other1,
        "other2": other2,
        "other3": other3,
        "other4": other4,
        "other5": other5,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}

class Structure {
    String? unit;
    String? price;
    String? roomId;
    String? roomNo;
    String? descountUnit;
    String? opningReding;
    String? closingReding;
    String? studentStructure;

    Structure({
        this.unit,
        this.price,
        this.roomId,
        this.roomNo,
        this.descountUnit,
        this.opningReding,
        this.closingReding,
        this.studentStructure,
    });

    factory Structure.fromJson(Map<String, dynamic> json) => Structure(
        unit: json["unit"],
        price: json["price"],
        roomId: json["room_id"],
        roomNo: json["room_no"],
        descountUnit: json["descount_unit"],
        opningReding: json["opning_reding"],
        closingReding: json["closing_reding"],
        studentStructure: json["student_structure"],
    );

    Map<String, dynamic> toJson() => {
        "unit": unit,
        "price": price,
        "room_id": roomId,
        "room_no": roomNo,
        "descount_unit": descountUnit,
        "opning_reding": opningReding,
        "closing_reding": closingReding,
        "student_structure": studentStructure,
    };
}
