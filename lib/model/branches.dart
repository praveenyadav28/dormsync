import 'dart:convert';

List<BranchList> branchListFromJson(List<dynamic> jsonList) {
  return List<BranchList>.from(
    jsonList.map((x) => BranchList.fromJson(x as Map<String, dynamic>)),
  );
}

String branchListToJson(List<BranchList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BranchList {
  int? id;
  String? licenceNo;
  String? contactNo;
  String? name;
  String? branchName;
  String? bAddress;
  String? bCity;
  String? bState;
  String? other1;
  String? other2;
  int? locationId;
  dynamic licence;
  User? user;

  BranchList({
    this.id,
    this.licenceNo,
    this.contactNo,
    this.name,
    this.branchName,
    this.bAddress,
    this.bCity,
    this.bState,
    this.locationId,
    this.licence,
    this.user,
    this.other1,
    this.other2
  });

  factory BranchList.fromJson(Map<String, dynamic> json) => BranchList(
    id: json["id"],
    licenceNo: json["licence_no"],
    contactNo: json["contact_no"],
    name: json["name"],
    branchName: json["branch_name"],
    bAddress: json["b_address"],
    bCity: json["b_city"],
    bState: json["b_state"],
    other1: json["other1"],
    other2: json["other2"],
    locationId: json["location_id"],
    licence: json["licence"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
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
    "other1": other1,
    "other2": other2,
    "location_id": locationId,
    "licence": licence,
    "user": user?.toJson(),
  };
}

class User {
  String? username;
  String? password;

  User({this.username, this.password});

  factory User.fromJson(Map<String, dynamic> json) =>
      User(username: json["username"], password: json["password"]);

  Map<String, dynamic> toJson() => {"username": username, "password": password};
}
