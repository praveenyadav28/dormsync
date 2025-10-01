List<UserModel> userModelFromJson(List<dynamic> jsonList) {
  return List<UserModel>.from(
    jsonList.map((x) => UserModel.fromJson(x as Map<String, dynamic>)),
  );
}

class UserModel {
  int? id;
  String? licenceNo;
  int? branchId;
  String? staffName;
  String? userName;
  String? password;
  List<String>? rights; // ✅ rights stored as a List

  UserModel({
    this.id,
    this.licenceNo,
    this.branchId,
    this.staffName,
    this.userName,
    this.password,
    this.rights,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    List<String> parsedRights = [];

    if (json["rights"] != null) {
      if (json["rights"] is String) {
        // ✅ handle comma-separated string like "Create,Update,Delete"
        parsedRights =
            (json["rights"] as String).split(",").map((e) => e.trim()).toList();
      } else if (json["rights"] is List) {
        // ✅ handle already a list
        parsedRights = List<String>.from(json["rights"]);
      }
    }

    return UserModel(
      id: json["id"],
      licenceNo: json["licence_no"],
      branchId: json["branch_id"],
      staffName: json["u_name"],
      userName: json["username"],
      password: json["password"],
      rights: parsedRights,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "licence_no": licenceNo,
      "branch_id": branchId,
      "u_name": staffName,
      "user_name": userName,
      "password": password,
      "rights": rights ?? [], // ✅ always serialize as List
    };
  }
}
