// To parse this JSON data, do
//
//     final staffList = staffListFromJson(jsonString);

import 'dart:convert';

List<VoucherModel> voucherModelFromJson(List<dynamic> jsonList) {
  return List<VoucherModel>.from(
    jsonList.map((x) => VoucherModel.fromJson(x as Map<String, dynamic>)),
  );
}

String voucherModelToJson(List<VoucherModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VoucherModel {
  int? id;
  String? licenceNo;
  int? branchId;
  String? voucherType;
  String? voucherDate;
  int? voucherNo;
  String? paymentMode;
  String? paymentBalance;
  List<String>? uplodeFile;
  String? accountHead;
  String? accountBalance;
  String? accLedgerId;
  String? payLedgerId;
  String? amount;
  String? narration;
  String? paidBy;
  String? remark;
  dynamic other1;
  dynamic other2;
  dynamic other3;
  dynamic other4;
  dynamic other5;
  DateTime? createdAt;
  DateTime? updatedAt;
  Licence? licence;
  Branch? branch;

  VoucherModel({
    this.id,
    this.licenceNo,
    this.branchId,
    this.voucherType,
    this.voucherDate,
    this.voucherNo,
    this.paymentMode,
    this.paymentBalance,
    this.accountHead,
    this.accountBalance,
    this.uplodeFile,
    this.accLedgerId,
    this.payLedgerId,
    this.amount,
    this.narration,
    this.paidBy,
    this.remark,
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

  factory VoucherModel.fromJson(Map<String, dynamic> json) {
    List<String>? parsedFiles;
    final dynamic uploadedFiles = json["document"];

    if (uploadedFiles is List) {
      // Case 1: The value is already a List (which is ideal).
      parsedFiles = uploadedFiles.cast<String>();
    } else if (uploadedFiles is String && uploadedFiles.isNotEmpty) {
      // Case 2: The value is a stringified JSON array.
      try {
        parsedFiles = List<String>.from(jsonDecode(uploadedFiles));
      } catch (e) {
        // Handle parsing errors gracefully.
        print("Error decoding document: $e");
      }
    }
    return VoucherModel(
      id: json["id"],
      licenceNo: json["licence_no"],
      branchId: json["branch_id"],
      voucherType: json["voucher_type"],
      voucherDate: json["voucher_date"],
      voucherNo: json["voucher_no"],
      paymentMode: json["payment_mode"],
      paymentBalance: json["payment_balance"].toString(),
      uplodeFile: parsedFiles, // Use the safely parsed list here
      payLedgerId: json["pay_ladger_id"].toString(),
      accLedgerId: json["acc_ladger_id"].toString(),
      accountHead: json["account_head"],
      accountBalance: json["account_balance"].toString(),
      amount: json["amount"].toString(),
      narration: json["narration"],
      paidBy: json["paid_by"],
      remark: json["remark"],
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
    "voucher_type": voucherType,
    "voucher_date": voucherDate,
    "voucher_no": voucherNo,
    "payment_mode": paymentMode,
    "payment_balance": paymentBalance,
    "pay_ladger_id": payLedgerId,
    "acc_ladger_id": accLedgerId,
    "account_head": accountHead,
    "account_balance": accountBalance,
    "amount": amount,
    "narration": narration,
    "paid_by": paidBy,
    "remark": remark,
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
