// To parse this JSON data, do
//
//     final staffList = staffListFromJson(jsonString);

import 'dart:convert';

List<ItemList> itemListFromJson(List<dynamic> jsonList) {
  return List<ItemList>.from(
    jsonList.map((x) => ItemList.fromJson(x as Map<String, dynamic>)),
  );
}

String itemListToJson(List<ItemList> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ItemList {
  int? id;
  String? licenceNo;
  int? branchId;
  String? itemNo;
  String? itemName;
  String? itemGroup;
  String? manufacturer;
  int? stockQty;

  ItemList({
    this.id,
    this.licenceNo,
    this.branchId,
    this.itemGroup,
    this.itemName,
    this.itemNo,
    this.manufacturer,
    this.stockQty,
  });

  factory ItemList.fromJson(Map<String, dynamic> json) => ItemList(
    id: json["id"],
    licenceNo: json["licence_no"],
    branchId: json["branch_id"],
    itemGroup: json["item_group"],
    itemName: json["item_name"],
    itemNo: json["item_no"],
    manufacturer: json["manufacturer"],
    stockQty: json["stock_qty"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "licence_no": licenceNo,
    "branch_id": branchId,
    'item_no': itemNo,
    'item_name': itemName,
    'item_group': itemGroup,
    'manufacturer': manufacturer,
    'stock_qty': stockQty,
  };
}
