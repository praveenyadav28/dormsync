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
    int? locationId;
    dynamic other1;
    dynamic other2;
    dynamic other3;
    dynamic other4;
    dynamic other5;
    DateTime? createdAt;
    DateTime? updatedAt;
    List<User>? user;

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
        this.other1,
        this.other2,
        this.other3,
        this.other4,
        this.other5,
        this.createdAt,
        this.updatedAt,
        this.user,
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
        locationId: json["location_id"],
        other1: json["other1"],
        other2: json["other2"],
        other3: json["other3"],
        other4: json["other4"],
        other5: json["other5"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        user: json["users"] == null ? [] : List<User>.from(json["users"]!.map((x) => User.fromJson(x))),
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
        "other1": other1,
        "other2": other2,
        "other3": other3,
        "other4": other4,
        "other5": other5,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "users": user == null ? [] : List<dynamic>.from(user!.map((x) => x.toJson())),
    };
}

class User {
    int? id;
    int? branchId;
    String? username;
    String? password;
    String? role;

    User({
        this.id,
        this.branchId,
        this.username,
        this.password,
        this.role,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        branchId: json["branch_id"],
        username: json["username"],
        password: json["password"],
        role: json["role"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "branch_id": branchId,
        "username": username,
        "password": password,
        "role": role,
    };
}
