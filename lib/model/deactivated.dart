import 'dart:convert';

List<DeactivatedList> deactivatedListFromJson(List<dynamic> jsonList) {
  return List<DeactivatedList>.from(
    jsonList.map((x) => DeactivatedList.fromJson(x as Map<String, dynamic>)),
  );
}

String deactivatedListToJson(List<DeactivatedList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DeactivatedList {
  int? id;
  String? licenceNo;
  int? branchId;
  int? sessionId;
  String? hostelerDetails;
  String? hostelerId;
  String? admissionDate;
  String? hostelerName;
  String? contactNo;
  String? fatherName;
  String? leaveDate;
  String? activeStatus;
  String? reason;
  dynamic other1;
  dynamic other2;
  dynamic other3;
  dynamic other4;
  dynamic other5;
  DateTime? createdAt;
  DateTime? updatedAt;
  Licence? licence;
  Branch? branch;

  DeactivatedList({
    this.id,
    this.licenceNo,
    this.branchId,
    this.sessionId,
    this.hostelerDetails,
    this.hostelerId,
    this.admissionDate,
    this.hostelerName,
    this.contactNo,
    this.fatherName,
    this.leaveDate,
    this.activeStatus,
    this.reason,
    this.other1,
    this.other2,
    this.other3,
    this.other4,
    this.other5,
    this.createdAt,
    this.updatedAt,
    this.licence,
    this.branch,
  });

  factory DeactivatedList.fromJson(
    Map<String, dynamic> json,
  ) => DeactivatedList(
    id: json["id"],
    licenceNo: json["licence_no"],
    branchId: json["branch_id"],
    sessionId: json["session_id"],
    hostelerDetails: json["hosteler_details"],
    hostelerId: json["hosteler_id"],
    admissionDate: json["admission_date"],
    hostelerName: json["hosteler_name"],
    contactNo: json["contact_no"],
    fatherName: json["father_name"],
    leaveDate: json["leave_date"],
    activeStatus: json["active_status"],
    reason: json["reason"],
    other1: json["other1"],
    other2: json["other2"],
    other3: json["other3"],
    other4: json["other4"],
    other5: json["other5"],
    createdAt:
        json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt:
        json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    licence: json["licence"] == null ? null : Licence.fromJson(json["licence"]),
    branch: json["branch"] == null ? null : Branch.fromJson(json["branch"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "licence_no": licenceNo,
    "branch_id": branchId,
    "session_id": sessionId,
    "hosteler_details": hostelerDetails,
    "hosteler_id": hostelerId,
    "admission_date": admissionDate,
    "hosteler_name": hostelerName,
    "contact_no": contactNo,
    "father_name": fatherName,
    "leave_date": leaveDate,
    "active_status": activeStatus,
    "reason": reason,
    "other1": other1,
    "other2": other2,
    "other3": other3,
    "other4": other4,
    "other5": other5,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "licence": licence?.toJson(),
    "branch": branch?.toJson(),
  };
}

class Branch {
  int? id;
  String? branchName;
  String? bCity;

  Branch({this.id, this.branchName, this.bCity});

  factory Branch.fromJson(Map<String, dynamic> json) => Branch(
    id: json["id"],
    branchName: json["branch_name"],
    bCity: json["b_city"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "branch_name": branchName,
    "b_city": bCity,
  };
}

class Licence {
  int? id;
  String? licenceNo;

  Licence({this.id, this.licenceNo});

  factory Licence.fromJson(Map<String, dynamic> json) =>
      Licence(id: json["id"], licenceNo: json["licence_no"]);

  Map<String, dynamic> toJson() => {"id": id, "licence_no": licenceNo};
}
