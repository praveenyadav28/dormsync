import 'dart:convert';

List<VisitorList> visitorListFromJson(List<dynamic> jsonList) {
  return List<VisitorList>.from(
    jsonList.map((x) => VisitorList.fromJson(x as Map<String, dynamic>)),
  );
}

String visitorListToJson(List<VisitorList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VisitorList {
    int? id;
    String? licenceNo;
    int? branchId;
    String? hostelerDetails;
    String? hostelerId;
    String? admissionDate;
    String? hostelerName;
    String? courseName;
    String? fatherName;
    String? visitingDate;
    String? visitorName;
    String? relation;
    String? contact;
    String? aadharNo;
    String? purposeOfVisit;
    String? dateOfLeave;
    dynamic other1;
    dynamic other2;
    dynamic other3;
    dynamic other4;
    dynamic other5;
    DateTime? createdAt;
    DateTime? updatedAt;

    VisitorList({
        this.id,
        this.licenceNo,
        this.branchId,
        this.hostelerDetails,
        this.hostelerId,
        this.admissionDate,
        this.hostelerName,
        this.courseName,
        this.fatherName,
        this.visitingDate,
        this.visitorName,
        this.relation,
        this.contact,
        this.aadharNo,
        this.purposeOfVisit,
        this.dateOfLeave,
        this.other1,
        this.other2,
        this.other3,
        this.other4,
        this.other5,
        this.createdAt,
        this.updatedAt,
    });

    factory VisitorList.fromJson(Map<String, dynamic> json) => VisitorList(
        id: json["id"],
        licenceNo: json["licence_no"],
        branchId: json["branch_id"],
        hostelerDetails: json["hosteler_details"],
        hostelerId: json["hosteler_id"],
        admissionDate: json["admission_date"],
        hostelerName: json["hosteler_name"],
        courseName: json["course_name"],
        fatherName: json["father_name"],
        visitingDate: json["visiting_date"],
        visitorName: json["visitor_name"],
        relation: json["relation"],
        contact: json["contact"],
        aadharNo: json["aadhar_no"],
        purposeOfVisit: json["purpose_of_visit"],
        dateOfLeave: json["date_of_leave"],
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
        "visiting_date": visitingDate,
        "visitor_name": visitorName,
        "relation": relation,
        "contact": contact,
        "aadhar_no": aadharNo,
        "purpose_of_visit": purposeOfVisit,
        "date_of_leave": dateOfLeave,
        "other1": other1,
        "other2": other2,
        "other3": other3,
        "other4": other4,
        "other5": other5,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
