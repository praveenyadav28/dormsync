import 'dart:convert';
import 'package:dorm_sync/model/staff.dart';
import 'package:intl/intl.dart';

List<FeesList> feesListFromJson(List<dynamic> jsonList) {
  return List<FeesList>.from(
    jsonList.map((x) => FeesList.fromJson(x as Map<String, dynamic>)),
  );
}

String feesListToJson(List<FeesList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FeesList {
  int? id;
  String? licenceNo;
  int? branchId;
  dynamic hostelerDetails;
  String? hostelerId;
  DateTime? admissionDate;
  String? hostelerName;
  String? courseName;
  String? fatherName;
  List<FeesStructure>? feesStructure;
  List<InstallmentStructure>? installmentStructure;
  String? totalAmount;
  int? discount;
  int? totalRemaining;
  int? emiRecived;
  int? emiTotal;
  dynamic other1;
  dynamic other2;
  dynamic other3;
  dynamic other4;
  dynamic other5;
  Licence? licence;
  Branch? branch;

  FeesList({
    this.id,
    this.licenceNo,
    this.branchId,
    this.hostelerDetails,
    this.hostelerId,
    this.admissionDate,
    this.hostelerName,
    this.courseName,
    this.fatherName,
    this.feesStructure,
    this.installmentStructure,
    this.totalAmount,
    this.discount,
    this.totalRemaining,
    this.emiRecived,
    this.emiTotal,
    this.other1,
    this.other2,
    this.other3,
    this.other4,
    this.other5,
    this.licence,
    this.branch,
  });

  factory FeesList.fromJson(Map<String, dynamic> json) => FeesList(
    id: json["id"],
    licenceNo: json["licence_no"],
    branchId: json["branch_id"],
    hostelerDetails: json["hosteler_details"],
    hostelerId: json["hosteler_id"],
    admissionDate:
        json["admission_date"] == null
            ? null
            : DateFormat('dd/MM/yyyy').parse(json["admission_date"]),
    hostelerName: json["hosteler_name"],
    courseName: json["course_name"],
    fatherName: json["father_name"],
    feesStructure:
        json["fees_structure"] == null
            ? []
            : List<FeesStructure>.from(
              json["fees_structure"]!.map((x) => FeesStructure.fromJson(x)),
            ),
    installmentStructure:
        json["installmant_structure"] == null
            ? []
            : List<InstallmentStructure>.from(
              json["installmant_structure"]!.map(
                (x) => InstallmentStructure.fromJson(x),
              ),
            ),
    totalAmount: json["total_amount"],
    discount: json["discount"],
    totalRemaining: json["total_remaining"],
    emiRecived: json["EMI_recived"],
    emiTotal: json["EMI_total"],
    other1: json["other1"],
    other2: json["other2"],
    other3: json["other3"],
    other4: json["other4"],
    other5: json["other5"],
    licence: json["licence"] == null ? null : Licence.fromJson(json["licence"]),
    branch: json["branch"] == null ? null : Branch.fromJson(json["branch"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "licence_no": licenceNo,
    "branch_id": branchId,
    "hosteler_details": hostelerDetails,
    "hosteler_id": hostelerId,
    "admission_date": admissionDate?.toIso8601String(),
    "hosteler_name": hostelerName,
    "course_name": courseName,
    "father_name": fatherName,
    "fees_structure":
        feesStructure == null
            ? []
            : List<dynamic>.from(feesStructure!.map((x) => x.toJson())),
    "installmant_structure":
        installmentStructure == null
            ? []
            : List<dynamic>.from(installmentStructure!.map((x) => x.toJson())),
    "total_amount": totalAmount,
    "discount": discount,
    "total_remaining": totalRemaining,
    "EMI_recived": emiRecived,
    "EMI_total": emiTotal,
    "other1": other1,
    "other2": other2,
    "other3": other3,
    "other4": other4,
    "other5": other5,
    "licence": licence?.toJson(),
    "branch": branch?.toJson(),
  };
}

class FeesStructure {
  String? feesType;
  int? price;
  int? discount;
  int? remaining;

  FeesStructure({this.feesType, this.price, this.discount, this.remaining});

  factory FeesStructure.fromJson(Map<String, dynamic> json) => FeesStructure(
    feesType: json["fees_type"],
    price: json["price"],
    discount: json["discount"],
    remaining: json["remaining"],
  );

  Map<String, dynamic> toJson() => {
    "fees_type": feesType,
    "price": price,
    "discount": discount,
    "remaining": remaining,
  };
}

class InstallmentStructure {
  String? date;
  double? price;

  InstallmentStructure({this.date, this.price});

  factory InstallmentStructure.fromJson(Map<String, dynamic> json) =>
      InstallmentStructure(
        date: json["date"],
        price:
            json["price"] is String
                ? double.tryParse(json["price"]) ?? 0.0
                : (json["price"] as num).toDouble(),
      );
  Map<String, dynamic> toJson() => {"date": date, "price": price};
}
