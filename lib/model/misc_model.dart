import 'dart:convert';

List<Goruppartmodel> grouppartmodelFromJson(String str) =>
    List<Goruppartmodel>.from(
        json.decode(str).map((x) => Goruppartmodel.fromJson(x)));

String grouppartmodelToJson(List<Goruppartmodel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Goruppartmodel {
  final int id;
  final String name;

  Goruppartmodel({
    required this.id,
    required this.name,
  });

  factory Goruppartmodel.fromJson(Map<String, dynamic> json) =>
      Goruppartmodel(id: json["id"], name: json["name"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
