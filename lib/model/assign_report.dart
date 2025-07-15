import 'dart:convert';

List<StudentReportList> studentReportListFromJson(List<dynamic> jsonList) {
  return List<StudentReportList>.from(
    jsonList.map((x) => StudentReportList.fromJson(x as Map<String, dynamic>)),
  );
}

String studentReportListToJson(List<StudentReportList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StudentReportList {
  String? studentId;
  String? studentName;
  String? fatherName;
  String? primaryContactNo;
  String? admissionDate;
  String? roomNo;
  String? roomType;
  int? buildingId;
  int? floorId;
  int? roomId;
  int? id;

  StudentReportList({
    this.studentId,
    this.studentName,
    this.fatherName,
    this.primaryContactNo,
    this.admissionDate,
    this.roomNo,
    this.roomType,
    this.buildingId,
    this.floorId,
    this.roomId,
    this.id,
  });

  factory StudentReportList.fromJson(Map<String, dynamic> json) =>
      StudentReportList(
        studentId: json["student_id"].toString(),
        studentName: json["student_name"],
        fatherName: json["father_name"],
        primaryContactNo: json["primary_contact_no"],
        admissionDate: json["admission_date"],
        roomNo: json["room_no"],
        roomType: json["room_type"],
        buildingId: json["building_id"],
        floorId: json["floor_id"],
        roomId: json["room_id"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
    "student_id": studentId,
    "student_name": studentName,
    "father_name": fatherName,
    "primary_contact_no": primaryContactNo,
    "admission_date": admissionDate,
    "room_no": roomNo,
    "room_type": roomType,
    "building_id": buildingId,
    "floor_id": floorId,
    "room_id": roomId,
    "id": id,
  };
}
