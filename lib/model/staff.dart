// To parse this JSON data, do
//
//     final staffList = staffListFromJson(jsonString);

import 'dart:convert';

import 'package:intl/intl.dart';

List<StaffList> staffListFromJson(List<dynamic> jsonList) {
  return List<StaffList>.from(
    jsonList.map((x) => StaffList.fromJson(x as Map<String, dynamic>)),
  );
}

String staffListToJson(List<StaffList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StaffList {
  int? id;
  String? licenceNo;
  int? branchId;
  String? title;
  String? staffId;
  String? staffName;
  String? relationType;
  String? name;
  String? contactNo;
  dynamic whatsappNo;
  dynamic email;
  String? department;
  String? designation;
  String? joiningDate;
  dynamic aadharNo;
  String? permanentAddress;
  String? state;
  String? city;
  String? openingBalance;
  String? openingType;
  String? cityTownVillage;
  String? address;
  String? pinCode;
  String? other1;
  String? other2;
  String? other3;
  String? other4;
  String? temporaryAddress;
  Licence? licence;
  Branch? branch;

  StaffList({
    this.id,
    this.licenceNo,
    this.branchId,
    this.title,
    this.staffId,
    this.staffName,
    this.relationType,
    this.name,
    this.contactNo,
    this.whatsappNo,
    this.email,
    this.department,
    this.designation,
    this.joiningDate,
    this.aadharNo,
    this.permanentAddress,
    this.state,
    this.city,
    this.openingBalance,
    this.openingType,
    this.cityTownVillage,
    this.address,
    this.pinCode,
    this.other1,
    this.other2,
    this.other3,
    this.other4,
    this.temporaryAddress,
    this.licence,
    this.branch,
  });

  factory StaffList.fromJson(Map<String, dynamic> json) => StaffList(
    id: json["id"],
    licenceNo: json["licence_no"],
    branchId: json["branch_id"],
    title: json["title"],
    staffId: json["staff_id"].toString(),
    staffName: json["staff_name"],
    relationType: json["relation_type"],
    name: json["name"],
    contactNo: json["contact_no"],
    whatsappNo: json["whatsapp_no"],
    email: json["email"],
    department: json["department"],
    designation: json["designation"],
    joiningDate: json["joining_date"],
    aadharNo: json["aadhar_no"],
    permanentAddress: json["permanent_address"],
    state: json["state"],
    city: json["city"],
    openingBalance: json["opening_balance"],
    openingType: json["opening_type"],
    cityTownVillage: json["city_town_village"],
    address: json["address"],
    pinCode: json["pin_code"],
    temporaryAddress: json["temporary_address"],
    licence: json["licence"] == null ? null : Licence.fromJson(json["licence"]),
    branch: json["branch"] == null ? null : Branch.fromJson(json["branch"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "licence_no": licenceNo,
    "branch_id": branchId,
    "title": title,
    "staff_name": staffName,
    "staff_id": staffId.toString(),
    "relation_type": relationType,
    "name": name,
    "contact_no": contactNo,
    "whatsapp_no": whatsappNo,
    "email": email,
    "department": department,
    "designation": designation,
    "joining_date": joiningDate,
    "aadhar_no": aadharNo,
    "permanent_address": permanentAddress,
    "state": state,
    "city": city,
    "opening_balance": openingBalance,
    "opening_type": openingType,
    "city_town_village": cityTownVillage,
    "address": address,
    "pin_code": pinCode,
    "other1": other1,
    "other2": other2,
    "other3": other3,
    "other4": other4,
    "temporary_address": temporaryAddress,
    "licence": licence?.toJson(),
    "branch": branch?.toJson(),
  };
}

class Branch {
  int? id;
  String? licenceNo;
  String? contactNo;
  String? name;
  String? branchName;
  String? bAddress;
  String? bCity;
  String? bState;
  int? locationId;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  Branch({
    this.id,
    this.licenceNo,
    this.contactNo,
    this.name,
    this.branchName,
    this.bAddress,
    this.bCity,
    this.bState,
    this.locationId,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory Branch.fromJson(Map<String, dynamic> json) => Branch(
    id: json["id"],
    licenceNo: json["licence_no"],
    contactNo: json["contact_no"],
    name: json["name"],
    branchName: json["branch_name"],
    bAddress: json["b_address"],
    bCity: json["b_city"],
    bState: json["b_state"],
    locationId: json["location_id"],
    createdAt:
        json["created_at"] == null
            ? null
            : DateFormat('dd/MM/yyyy').parse(json["created_at"]),
    updatedAt:
        json["updated_at"] == null
            ? null
            : DateFormat('dd/MM/yyyy').parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "licence_no": licenceNo,
    "contact_no": contactNo,
    "name": name,
    "branch_name": branchName,
    "b_address": bAddress,
    "b_city": bCity,
    "b_state": bState,
    "location_id": locationId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
  };
}

class Licence {
  int? id;
  String? licenceNo;
  DateTime? licenseDueDate;
  DateTime? amcDueDate;
  String? companyName;
  String? lAddress;
  String? lCity;
  String? lState;
  String? gstNo;
  String? ownerName;
  String? contactNo;
  String? dealAmt;
  String? receiveAmt;
  String? dueAmt;
  int? branchCount;
  String? branchList;
  String? salesman;
  String? remarks;

  Licence({
    this.id,
    this.licenceNo,
    this.licenseDueDate,
    this.amcDueDate,
    this.companyName,
    this.lAddress,
    this.lCity,
    this.lState,
    this.gstNo,
    this.ownerName,
    this.contactNo,
    this.dealAmt,
    this.receiveAmt,
    this.dueAmt,
    this.branchCount,
    this.branchList,
    this.salesman,
    this.remarks,
  });

  factory Licence.fromJson(Map<String, dynamic> json) => Licence(
    id: json["id"],
    licenceNo: json["licence_no"],
    licenseDueDate:
        json["license_due_date"] == null
            ? null
            : DateFormat('dd/MM/yyyy').parse(json["license_due_date"]),
    amcDueDate:
        json["amc_due_date"] == null
            ? null
            : DateFormat('dd/MM/yyyy').parse(json["amc_due_date"]),
    companyName: json["company_name"],
    lAddress: json["l_address"],
    lCity: json["l_city"],
    lState: json["l_state"],
    gstNo: json["gst_no"],
    ownerName: json["owner_name"],
    contactNo: json["contact_no"],
    dealAmt: json["deal_amt"],
    receiveAmt: json["receive_amt"],
    dueAmt: json["due_amt"],
    branchCount: json["branch_count"],
    branchList: json["branch_list"],
    salesman: json["salesman"],
    remarks: json["remarks"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "licence_no": licenceNo,
    "license_due_date": DateFormat(
      'dd/MM/yyyy',
    ).format(licenseDueDate ?? DateTime.now()),
    "amc_due_date": DateFormat(
      'dd/MM/yyyy',
    ).format(amcDueDate ?? DateTime.now()),
    "company_name": companyName,
    "l_address": lAddress,
    "l_city": lCity,
    "l_state": lState,
    "gst_no": gstNo,
    "owner_name": ownerName,
    "contact_no": contactNo,
    "deal_amt": dealAmt,
    "receive_amt": receiveAmt,
    "due_amt": dueAmt,
    "branch_count": branchCount,
    "branch_list": branchList,
    "salesman": salesman,
    "remarks": remarks,
  };
}
