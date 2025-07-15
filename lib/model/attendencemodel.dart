List<AttendenceModel> attendenceListFromJson(List<dynamic> jsonList) {
  return List<AttendenceModel>.from(
    jsonList.map((x) => AttendenceModel.fromJson(x as Map<String, dynamic>)),
  );
}

class AttendenceModel {
  int? id;
  String? licenceNo;
  int? branchId;
  String? hostelerDetails;
  String? hostelerId;
  String? admissionDate;
  String? hostelerName;
  String? courseName;
  String? fatherName;
  String? messBiomax;
  String? hostelBiomax;
  String? activeStatus;
  dynamic other1;
  dynamic other2;
  dynamic other3;
  dynamic other4;
  dynamic other5;

  AttendenceModel({
    this.id,
    this.licenceNo,
    this.branchId,
    this.hostelerDetails,
    this.hostelerId,
    this.admissionDate,
    this.hostelerName,
    this.courseName,
    this.fatherName,
    this.messBiomax,
    this.hostelBiomax,
    this.activeStatus,
    this.other1,
    this.other2,
    this.other3,
    this.other4,
    this.other5,
  });

  factory AttendenceModel.fromJson(Map<String, dynamic> json) =>
      AttendenceModel(
        id: json["id"],
        licenceNo: json["licence_no"],
        branchId: json["branch_id"],
        hostelerDetails: json["hosteler_details"],
        hostelerId: json["hosteler_id"],
        admissionDate: json["admission_date"],
        hostelerName: json["hosteler_name"],
        courseName: json["course_name"],
        fatherName: json["father_name"],
        messBiomax: json["mess_biomax"].toString(),
        hostelBiomax: json["hostel_biomax"].toString(),
        activeStatus: json["active_status"].toString(),
        other1: json["other1"],
        other2: json["other2"],
        other3: json["other3"],
        other4: json["other4"],
        other5: json["other5"],
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
    "mess_biomax": messBiomax,
    "hostel_biomax": hostelBiomax,
    "active_status": activeStatus,
    "other1": other1,
    "other2": other2,
    "other3": other3,
    "other4": other4,
    "other5": other5,
  };
}

class DeviceLog {
  final String biomaxId;
  final String punchDirection;
  final String serialNumber;
  final DateTime logDate;
  final DateTime punchTime;

  DeviceLog({
    required this.biomaxId,
    required this.punchDirection,
    required this.serialNumber,
    required this.logDate,
    required this.punchTime,
  });

  factory DeviceLog.fromJson(Map<String, dynamic> json) {
    return DeviceLog(
      biomaxId: json['EmployeeCode'],
      punchDirection: json['PunchDirection'],
      serialNumber: json['SerialNumber'],
      logDate: DateTime.parse("${json['LogDate']}"),
      punchTime: DateTime.parse("${json['LogDate']}"),
    );
  }
}
