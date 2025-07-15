// To parse this JSON data, do
//
//     final AdmissionList = admissionListFromJson(jsonString);

import 'dart:convert';

import 'package:dorm_sync/model/branches.dart';
import 'package:dorm_sync/model/ledger.dart';
import 'package:intl/intl.dart';

List<AdmissionList> admissionListFromJson(List<dynamic> jsonList) {
  return List<AdmissionList>.from(
    jsonList.map((x) => AdmissionList.fromJson(x as Map<String, dynamic>)),
  );
}

String admissonListToJson(List<AdmissionList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AdmissionList {
  int? id;
  String? licenceNo;
  int? branchId;
  DateTime? admissionDate;
  String? studentId;
  String? studentName;
  String? gender;
  String? maritalStatus;
  String? aadharNo;
  String? caste;
  String? primaryContactNo;
  String? whatsappNo;
  String? email;
  String? collegeName;
  String? course;
  DateTime? dateOfBirth;
  String? year;
  String? fatherName;
  String? motherName;
  String? parentContect;
  String? guardian;
  String? emergencyNo;
  String? permanentAddress;
  String? permanentState;
  String? permanentCity;
  String? permanentCityTown;
  String? permanentPinCode;
  String? temporaryAddress;
  String? temporaryState;
  String? temporaryCity;
  String? temporaryCityTown;
  String? temporaryPinCode;
  String? activeStatus;
  BranchList? branch;
  LedgerList? ledger;

  AdmissionList({
    this.id,
    this.licenceNo,
    this.branchId,
    this.admissionDate,
    this.studentId,
    this.studentName,
    this.gender,
    this.maritalStatus,
    this.aadharNo,
    this.caste,
    this.primaryContactNo,
    this.whatsappNo,
    this.email,
    this.collegeName,
    this.course,
    this.dateOfBirth,
    this.year,
    this.fatherName,
    this.motherName,
    this.parentContect,
    this.guardian,
    this.emergencyNo,
    this.permanentAddress,
    this.permanentState,
    this.permanentCity,
    this.permanentCityTown,
    this.permanentPinCode,
    this.temporaryAddress,
    this.temporaryState,
    this.temporaryCity,
    this.temporaryCityTown,
    this.temporaryPinCode,
    this.activeStatus,
    this.branch,
    this.ledger,
  });

  factory AdmissionList.fromJson(Map<String, dynamic> json) => AdmissionList(
    id: json["id"],
    licenceNo: json["licence_no"],
    branchId: json["branch_id"],
    admissionDate:
        json["admission_date"] == null
            ? null
            : DateFormat('dd/MM/yyyy').parse(json["admission_date"]),
    studentId: json["student_id"].toString(),
    studentName: json["student_name"],
    gender: json["gender"],
    maritalStatus: json["marital_status"],
    aadharNo: json["aadhar_no"],
    caste: json["caste"],
    primaryContactNo: json["primary_contact_no"],
    whatsappNo: json["whatsapp_no"],
    email: json["email"],
    collegeName: json["college_name"],
    course: json["course"],
    dateOfBirth:
        json["date_of_birth"] == null
            ? null
            : DateFormat('dd/MM/yyyy').parse(json["date_of_birth"]),
    year: json["year"],
    fatherName: json["father_name"],
    motherName: json["mother_name"],
    parentContect: json["parent_contect"],
    guardian: json["guardian"],
    emergencyNo: json["emergency_no"],
    permanentAddress: json["permanent_address"],
    permanentState: json["permanent_state"],
    permanentCity: json["permanent_city"],
    permanentCityTown: json["permanent_city_town"],
    permanentPinCode: json["permanent_pin_code"],
    temporaryAddress: json["temporary_address"],
    temporaryState: json["temporary_state"],
    temporaryCity: json["temporary_city"],
    temporaryCityTown: json["temporary_city_town"],
    temporaryPinCode: json["temporary_pin_code"],
    activeStatus: json["active_status"].toString(),
    branch: json["branch"] == null ? null : BranchList.fromJson(json["branch"]),
    ledger: json["ledger"] == null ? null : LedgerList.fromJson(json["ledger"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "licence_no": licenceNo,
    "branch_id": branchId,
    "admission_date": DateFormat('dd/MM/yyyy').format(admissionDate!),
    "student_id": studentId,
    "student_name": studentName,
    "gender": gender,
    "marital_status": maritalStatus,
    "aadhar_no": aadharNo,
    "caste": caste,
    "primary_contact_no": primaryContactNo,
    "whatsapp_no": whatsappNo,
    "email": email,
    "college_name": collegeName,
    "course": course,
    "date_of_birth": DateFormat('dd/MM/yyyy').format(dateOfBirth!),
    "year": year,
    "father_name": fatherName,
    "mother_name": motherName,
    "parent_contect": parentContect,
    "guardian": guardian,
    "emergency_no": emergencyNo,
    "permanent_address": permanentAddress,
    "permanent_state": permanentState,
    "permanent_city": permanentCity,
    "permanent_city_town": permanentCityTown,
    "permanent_pin_code": permanentPinCode,
    "temporary_address": temporaryAddress,
    "temporary_state": temporaryState,
    "temporary_city": temporaryCity,
    "temporary_city_town": temporaryCityTown,
    "temporary_pin_code": temporaryPinCode,
    "active_status": activeStatus,
    "branch": branch?.toJson(),
    "ledger": ledger?.toJson(),
  };
}
