// To parse this JSON data, do
//
//     final ledgerList = ledgerListFromJson(jsonString);

import 'dart:convert';

List<LedgerList> ledgerListFromJson(List<dynamic> jsonList) {
  return List<LedgerList>.from(
    jsonList.map((x) => LedgerList.fromJson(x as Map<String, dynamic>)),
  );
}

String ledgerListToJson(List<LedgerList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LedgerList {
  int? id;
  String? licenceNo;
  int? branchId;
  dynamic studentId;
  String? title;
  String? ledgerName;
  String? relationType;
  String? name;
  String? contactNo;
  dynamic whatsappNo;
  dynamic email;
  String? ledgerGroup;
  List<String>? uplodeFile;
  String? openingBalance;
  String? openingType;
  String? closingBalance;
  String? closingType;
  dynamic gstNo;
  dynamic aadharNo;
  String? permanentAddress;
  String? state;
  String? city;
  String? cityTownVillage;
  String? pinCode;
  String? tstate;
  String? tcity;
  String? tcityTownVillage;
  String? tpinCode;
  String? other1;
  String? other2;
  String? other3;
  String? other4;
  String? other5;
  dynamic temporaryAddress;

  LedgerList({
    this.id,
    this.licenceNo,
    this.branchId,
    this.studentId,
    this.title,
    this.ledgerName,
    this.relationType,
    this.name,
    this.contactNo,
    this.whatsappNo,
    this.email,
    this.ledgerGroup,
    this.openingBalance,
    this.openingType,
    this.closingBalance,
    this.closingType,
    this.gstNo,
    this.aadharNo,
    this.permanentAddress,
    this.state,
    this.uplodeFile,
    this.city,
    this.cityTownVillage,
    this.pinCode,
    this.tstate,
    this.tcity,
    this.tcityTownVillage,
    this.tpinCode,
    this.other1,
    this.other2,
    this.other3,
    this.other4,
    this.other5,
    this.temporaryAddress,
  });

  factory LedgerList.fromJson(Map<String, dynamic> json) {
    List<String>? parsedFiles;
    final dynamic uploadedFiles = json["ledger_file"];

    if (uploadedFiles is List) {
      // Case 1: The value is already a List (which is ideal).
      parsedFiles = uploadedFiles.cast<String>();
    } else if (uploadedFiles is String && uploadedFiles.isNotEmpty) {
      // Case 2: The value is a stringified JSON array.
      try {
        parsedFiles = List<String>.from(jsonDecode(uploadedFiles));
      } catch (e) {
        // Handle parsing errors gracefully.
        print("Error decoding ledger_file: $e");
      }
    }
    return LedgerList(
      id: json["id"],
      licenceNo: json["licence_no"],
      branchId: json["branch_id"],
      studentId: json["student_id"],
      title: json["title"],
      ledgerName: json["ledger_name"],
      relationType: json["relation_type"],
      name: json["name"],
      contactNo: json["contact_no"],
      whatsappNo: json["whatsapp_no"],
      email: json["email"],
      ledgerGroup: json["ledger_group"],
      openingBalance: json["opening_balance"],
      openingType: json["opening_type"],
      closingBalance: json["closing_balance"],
      closingType: json["closing_type"],
      gstNo: json["gst_no"],
      aadharNo: json["aadhar_no"],
      permanentAddress: json["permanent_address"],
      state: json["state"],
      uplodeFile: parsedFiles, // Use the safely parsed list here
      city: json["city"],
      cityTownVillage: json["city_town_village"],
      pinCode: json["pin_code"],
      tstate: json["t_state"],
      tcity: json["t_city"],
      tcityTownVillage: json["t_city_town_village"],
      tpinCode: json["t_pin_code"],
      other1: json["other1"],
      other2: json["other2"],
      other3: json["other3"],
      other4: json["other4"],
      other5: json["other5"],
      temporaryAddress: json["temporary_address"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "licence_no": licenceNo,
    "branch_id": branchId,
    "student_id": studentId,
    "title": title,
    "ledger_name": ledgerName,
    "relation_type": relationType,
    "name": name,
    "contact_no": contactNo,
    "whatsapp_no": whatsappNo,
    "email": email,
    "ledger_group": ledgerGroup,
    "opening_balance": openingBalance,
    "opening_type": openingType,
    "closing_balance": closingBalance,
    "closing_type": closingType,
    "gst_no": gstNo,
    "aadhar_no": aadharNo,
    "permanent_address": permanentAddress,
    "state": state,
    "city": city,
    "city_town_village": cityTownVillage,
    "pin_code": pinCode,
    "t_state": tstate,
    "t_city": tcity,
    "t_city_town_village": tcityTownVillage,
    "t_pin_code": tpinCode,
    "other1": other1,
    "other2": other2,
    "other3": other3,
    "other4": other4,
    "other5": other5,
    "temporary_address": temporaryAddress,
  };
}
