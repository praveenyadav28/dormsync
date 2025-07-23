// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:dorm_sync/utils/prefence.dart';
import 'package:dorm_sync/utils/snackbar.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseurl = "http://192.168.1.7:8000/api";

  static Future fetchData(String endpoint) async {
    final response = await http.get(
      Uri.parse('$baseurl/$endpoint'),
      headers: {
        'Authorization': 'Bearer ${Preference.getString(PrefKeys.token)}',
        'Accept': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

  static Future postData(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseurl/$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${Preference.getString(PrefKeys.token)}',
        },
        body: jsonEncode(data),
      );

      print(response.body);
      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          return json.decode(response.body);
        } else {
          throw Exception('Response body is empty');
        }
      } else {
        print(response.body);
        throw Exception('Failed to post data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to post data: $e');
    }
  }

  static Future postDataBeforeLogin(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseurl/$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          return json.decode(response.body);
        } else {
          throw Exception('Response body is empty');
        }
      } else {
        throw Exception('Failed to post data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to post data: $e');
    }
  }

  static Future deleteData(String endpoint) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseurl/$endpoint'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${Preference.getString(PrefKeys.token)}',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return json.decode(response.body.isNotEmpty ? response.body : '{}');
      } else {
        throw Exception('Failed to delete data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete data: $e');
    }
  }

  static Future uploadMultipleFiles({
    required String endpoint,
    required Map<String, String> fields,
    required List<http.MultipartFile> files,
  }) async {
    try {
      var uri = Uri.parse('$baseurl/$endpoint');
      var request = http.MultipartRequest('POST', uri);

      request.headers.addAll({
        'Authorization': 'Bearer ${Preference.getString(PrefKeys.token)}',
        'Accept': 'application/json',
      });

      request.fields.addAll(fields);

      for (var file in files) {
        request.files.add(file);
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Upload failed: ${response.body}');
      }
    } catch (e) {
      throw Exception('Upload error: $e');
    }
  }

  static Future postMisc(int id, String name, context, groupList) async {
    var response = await ApiService.postData('misc', {
      'licence_no': Preference.getString(PrefKeys.licenseNo),
      'misc_id': id,
      'name': name,
    });

    if (response["status"] == true) {
      showCustomSnackbarSuccess(context, response['message']);
      await getGroupList(id, groupList);
    } else {
      showCustomSnackbarError(context, response['message']);
    }
  }

  static Future<void> getGroupList(int id, List groupList) async {
    var response = await ApiService.fetchData(
      'misc?licence_no=${Preference.getString(PrefKeys.licenseNo)}&misc_id=$id',
    );
    if (response["status"] == true) {
      List<dynamic> data = response["data"];
      groupList.clear();
      groupList.addAll(data.map((e) => e['name'].toString()).toList());
    }
  }
}
