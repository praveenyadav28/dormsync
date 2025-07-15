import 'dart:convert';

List<LeaveList> leaveListFromJson(List<dynamic> jsonList) {
  return List<LeaveList>.from(
    jsonList.map((x) => LeaveList.fromJson(x as Map<String, dynamic>)),
  );
}

String leaveListToJson(List<LeaveList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LeaveList {
    int? id;
    String? licenceNo;
    int? branchId;
    String? hostelerDetails;
    String? hostelerId;
    String? admissionDate;
    String? hostelerName;
    String? courseName;
    String? fatherName;
    String? fromDate;
    String? accompainedBy;
    String? relation;
    String? destination;
    String? contact;
    String? aadharNo;
    String? purposeOfLeave;
    String? toDate;
    dynamic other1;
    dynamic other2;
    dynamic other3;
    dynamic other4;
    dynamic other5;
    DateTime? createdAt;
    DateTime? updatedAt;

    LeaveList({
        this.id,
        this.licenceNo,
        this.branchId,
        this.hostelerDetails,
        this.hostelerId,
        this.admissionDate,
        this.hostelerName,
        this.courseName,
        this.fatherName,
        this.fromDate,
        this.accompainedBy,
        this.relation,
        this.destination,
        this.contact,
        this.aadharNo,
        this.purposeOfLeave,
        this.toDate,
        this.other1,
        this.other2,
        this.other3,
        this.other4,
        this.other5,
        this.createdAt,
        this.updatedAt,
    });

    factory LeaveList.fromJson(Map<String, dynamic> json) => LeaveList(
        id: json["id"],
        licenceNo: json["licence_no"],
        branchId: json["branch_id"],
        hostelerDetails: json["hosteler_details"],
        hostelerId: json["hosteler_id"],
        admissionDate: json["admission_date"],
        hostelerName: json["hosteler_name"],
        courseName: json["course_name"],
        fatherName: json["father_name"],
        fromDate: json["from_date"],
        accompainedBy: json["accompained_by"],
        relation: json["relation"],
        destination: json["destination"],
        contact: json["contact"],
        aadharNo: json["aadhar_no"],
        purposeOfLeave: json["purpose_of_leave"],
        toDate: json["to_date"],
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
        "hosteler_details": hostelerDetails,
        "hosteler_id": hostelerId,
        "admission_date": admissionDate,
        "hosteler_name": hostelerName,
        "course_name": courseName,
        "father_name": fatherName,
        "from_date": fromDate,
        "accompained_by": accompainedBy,
        "relation": relation,
        "destination": destination,
        "contact": contact,
        "aadhar_no": aadharNo,
        "purpose_of_leave": purposeOfLeave,
        "to_date": toDate,
        "other1": other1,
        "other2": other2,
        "other3": other3,
        "other4": other4,
        "other5": other5,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
