
List<AssignRoomModel> assignRoomModelFromJson(List<dynamic> jsonList) {
  return List<AssignRoomModel>.from(
    jsonList.map((x) => AssignRoomModel.fromJson(x as Map<String, dynamic>)),
  );
}

class AssignRoomModel {
  int? id;
  String? licenceNo;
  int? branchId;
  int? roomId;
  dynamic hostelerDetails;
  String? hostelerId;
  String? admissionDate;
  String? hostelerName;
  String? courseName;
  String? fatherName;
  int? buildingId;
  int? floorId;
  String? roomType;
  String? roomNo;
  int? activeStatus;
  String? other1;

  AssignRoomModel({
    this.id,
    this.licenceNo,
    this.branchId,
    this.roomId,
    this.hostelerDetails,
    this.hostelerId,
    this.admissionDate,
    this.hostelerName,
    this.courseName,
    this.fatherName,
    this.buildingId,
    this.floorId,
    this.roomType,
    this.roomNo,
    this.activeStatus,
    this.other1,
  });

  factory AssignRoomModel.fromJson(Map<String, dynamic> json) =>
      AssignRoomModel(
        id: json["id"],
        licenceNo: json["licence_no"],
        branchId: json["branch_id"],
        roomId: json["room_id"],
        hostelerDetails: json["hosteler_details"],
        hostelerId: json["hosteler_id"],
        admissionDate: json["admission_date"],
        hostelerName: json["hosteler_name"],
        courseName: json["course_name"],
        fatherName: json["father_name"],
        buildingId: json["building_id"],
        floorId: json["floor_id"],
        roomType: json["room_type"],
        roomNo: json["room_no"],
        activeStatus: json["active_status"],
        other1: json["other1"],
      );

  Map<String, dynamic> toJson() => {
    "id": id,
    "licence_no": licenceNo,
    "branch_id": branchId,
    "room_id": roomId,
    "hosteler_details": hostelerDetails,
    "hosteler_id": hostelerId,
    "admission_date": admissionDate,
    "hosteler_name": hostelerName,
    "course_name": courseName,
    "father_name": fatherName,
    "building_id": buildingId,
    "floor_id": floorId,
    "room_type": roomType,
    "room_no": roomNo,
    "active_status": activeStatus,
    "other1": other1,
  };
}
