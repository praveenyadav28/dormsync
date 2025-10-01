import 'dart:convert';

List<ProspectList> prospectListFromJson(List<dynamic> jsonList) {
  return List<ProspectList>.from(
    jsonList.map((x) => ProspectList.fromJson(x as Map<String, dynamic>)),
  );
}

String prospectListToJson(List<ProspectList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProspectList {
  int? id;
  String? licenceNo;
  int? branchId;
  String? studentName;
  String? gender;
  String? contactNo;
  String? address;
  String? fatherName;
  String? fContactNo;
  String? staff;
  String? nextAppointmentDate;
  String? prospectDate;
  String? time;
  String? remark;
  String? state;
  String? city;
  String? prospectStatus;
  DateTime? createdAt;
  DateTime? updatedAt;

  ProspectList({
    this.id,
    this.licenceNo,
    this.branchId,
    this.studentName,
    this.gender,
    this.contactNo,
    this.fatherName,
    this.fContactNo,
    this.address,
    this.staff,
    this.nextAppointmentDate,
    this.prospectDate,
    this.time,
    this.remark,
    this.state,
    this.city,
    this.prospectStatus,
    this.createdAt,
    this.updatedAt,
  });

  factory ProspectList.fromJson(Map<String, dynamic> json) => ProspectList(
    id: json["id"],
    licenceNo: json["licence_no"],
    branchId: json["branch_id"],
    studentName: json["student_name"],
    gender: json["gender"],
    contactNo: json["contact_no"],
    address: json["address"],
    staff: json["staff"],
    nextAppointmentDate: json["next_appointment_date"],
    prospectDate: json["prospect_date"],
    time: json["time"],
    remark: json["remark"],
    city: json["city"],
    state: json["state"],
    fatherName: json["father_name"],
    fContactNo: json["f_contact_no"],
    prospectStatus: json["prospect_status"],
    createdAt:
        json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt:
        json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "licence_no": licenceNo,
    "branch_id": branchId,
    "student_name": studentName,
    "gender": gender,
    "contact_no": contactNo,
    "address": address,
    "staff": staff,
    "next_appointment_date": nextAppointmentDate,
    "prospect_date": prospectDate,
    "time": time,
    "remark": remark,
    "city": city,
    "state": state,
    "father_name": fatherName,
    "f_contact_no": fContactNo,
    "prospect_status": prospectStatus,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class ProspectHistory {
  int? id;
  int? prospectId;
  int? updatedBy;
  ProspectList? oldData;

  ProspectHistory({this.id, this.prospectId, this.updatedBy, this.oldData});

  factory ProspectHistory.fromJson(Map<String, dynamic> json) {
    return ProspectHistory(
      id: json['id'],
      prospectId: json['prospect_id'],
      updatedBy: json['updated_by'],
      oldData:
          json['old_data'] != null
              ? ProspectList.fromJson(json['old_data'])
              : null,
    );
  }
}
