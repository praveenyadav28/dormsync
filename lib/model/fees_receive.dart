import 'dart:convert';

List<ReceivedListModel> feesReceiveModelFromJson(List<dynamic> jsonList) {
  return List<ReceivedListModel>.from(
    jsonList.map((x) => ReceivedListModel.fromJson(x as Map<String, dynamic>)),
  );
}

String feesReceiveModelToJson(List<ReceivedListModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReceivedListModel {
  int? id;
  String? licenceNo;
  int? branchId;
  int? sessionId;
  String? hostelerDetails;
  String? hostelerId;
  List<String>? uplodeFile;
  String? admissionDate;
  String? hostelerName;
  String? contactNo;
  String? fatherName;
  int? feesNo;
  String? entryType;
  String? date;
  dynamic course;
  String? ledgerId;
  String? ledgerName;
  String? amount;
  String? narration;
  String? receiveBy;
  String? remark;
  String? installmentNo;
  bool? isActive;
  dynamic other1;
  dynamic other2;
  dynamic other3;
  dynamic other4;
  dynamic other5;
  DateTime? createdAt;
  DateTime? updatedAt;
  Licence? licence;
  Branch? branch;

  ReceivedListModel({
    this.id,
    this.licenceNo,
    this.branchId,
    this.sessionId,
    this.uplodeFile,
    this.hostelerDetails,
    this.hostelerId,
    this.admissionDate,
    this.hostelerName,
    this.contactNo,
    this.fatherName,
    this.feesNo,
    this.entryType,
    this.date,
    this.course,
    this.ledgerId,
    this.ledgerName,
    this.amount,
    this.narration,
    this.receiveBy,
    this.remark,
    this.installmentNo,
    this.isActive,
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

  factory ReceivedListModel.fromJson(Map<String, dynamic> json) {
    List<String>? parsedFiles;
    final dynamic uploadedFiles = json["ss_image"];

    if (uploadedFiles is List) {
      // Case 1: The value is already a List (which is ideal).
      parsedFiles = uploadedFiles.cast<String>();
    } else if (uploadedFiles is String && uploadedFiles.isNotEmpty) {
      // Case 2: The value is a stringified JSON array.
      try {
        parsedFiles = List<String>.from(jsonDecode(uploadedFiles));
      } catch (e) {
        // Handle parsing errors gracefully.
        print("Error decoding ss_image: $e");
      }
    }
    return ReceivedListModel(
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
      feesNo: json["fees_no"],
      entryType: json["entry_type"],
      date: json["date"],
      uplodeFile: parsedFiles, // Use the safely parsed list here
      course: json["course"],
      ledgerId: json["ledger_id"],
      ledgerName: json["ledger_name"],
      amount: json["amount"],
      narration: json["narration"],
      receiveBy: json["receive_by"],
      remark: json["remark"],
      installmentNo: json["installment_no"],
      isActive: json["is_active"],
      other1: json["other1"],
      other2: json["other2"],
      other3: json["other3"],
      other4: json["other4"],
      other5: json["other5"],
      createdAt:
          json["created_at"] == null
              ? null
              : DateTime.parse(json["created_at"]),
      updatedAt:
          json["updated_at"] == null
              ? null
              : DateTime.parse(json["updated_at"]),
      licence:
          json["licence"] == null ? null : Licence.fromJson(json["licence"]),
      branch: json["branch"] == null ? null : Branch.fromJson(json["branch"]),
    );
  }

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
    "fees_no": feesNo,
    "entry_type": entryType,
    "date": date,
    "course": course,
    "ledger_id": ledgerId,
    "ledger_name": ledgerName,
    "amount": amount,
    "narration": narration,
    "receive_by": receiveBy,
    "remark": remark,
    "installment_no": installmentNo,
    "is_active": isActive,
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
