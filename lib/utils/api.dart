// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:dorm_sync/utils/prefence.dart';
import 'package:dorm_sync/utils/snackbar.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

class ApiService {
  static const String baseurl = "https://api.dormsync.com/api";

  // ---------------- Fetch ----------------
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

  // ---------------- Post ----------------
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
        return response.body.isNotEmpty
            ? json.decode(response.body)
            : throw Exception('Response body is empty');
      } else {
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
        return response.body.isNotEmpty
            ? json.decode(response.body)
            : throw Exception('Response body is empty');
      } else {
        throw Exception('Failed to post data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to post data: $e');
    }
  }

  // ---------------- Delete ----------------
  static Future deleteData(String endpoint) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseurl/$endpoint'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${Preference.getString(PrefKeys.token)}',
        },
        body: {"licence_no": Preference.getString(PrefKeys.licenseNo)},
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

  // ---------------- File Conversion ----------------
  static Future<http.MultipartFile> toMultipartFile(
    XFile file,
    String fieldName,
  ) async {
    if (kIsWeb) {
      final bytes = await file.readAsBytes();
      final mimeType = lookupMimeType(file.name) ?? 'application/octet-stream';
      return http.MultipartFile.fromBytes(
        fieldName,
        bytes,
        filename: file.name,
        contentType: MediaType.parse(mimeType),
      );
    } else {
      return await http.MultipartFile.fromPath(fieldName, file.path);
    }
  }

  // ---------------- Universal Uploader ----------------
  static Future<Map<String, dynamic>> uploadFiles({
    required String endpoint,
    required Map<String, String> fields,
    Map<String, XFile?>? singleFiles, // e.g. {"profile": image}
    Map<String, List<XFile>>? multiFiles, // e.g. {"upload_file": docs}
    String method = 'POST',
  }) async {
    try {
      final uri = Uri.parse('$baseurl/$endpoint');
      final request = http.MultipartRequest(method, uri);

      request.headers.addAll({
        'Authorization': 'Bearer ${Preference.getString(PrefKeys.token)}',
        'Accept': 'application/json',
      });

      request.fields.addAll(fields);

      // Handle single files
      if (singleFiles != null) {
        for (final entry in singleFiles.entries) {
          if (entry.value != null) {
            request.files.add(await toMultipartFile(entry.value!, entry.key));
          }
        }
      }

      // Handle multiple files
      if (multiFiles != null) {
        for (final entry in multiFiles.entries) {
          for (final file in entry.value) {
            request.files.add(await toMultipartFile(file, entry.key));
          }
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception(
          'Upload failed: ${response.statusCode} → ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Upload error: $e');
    }
  }

  // ---------------- Profile Upload (wrapper) ----------------
  static Future<bool> uploadProfile({
    required String licenceNo,
    required int branchId,
    required XFile? pickedImage,
  }) async {
    try {
      final response = await uploadFiles(
        endpoint: "profile",
        fields: {"licence_no": licenceNo, "branch_id": branchId.toString()},
        singleFiles: {"profile": pickedImage},
      );

      if (response["status"] == true) {
        debugPrint("✅ Profile Upload Success: ${response.toString()}");
        return true;
      } else {
        debugPrint("❌ Profile Upload Failed: ${response.toString()}");
        return false;
      }
    } catch (e) {
      debugPrint("❌ Error uploading profile: $e");
      return false;
    }
  }

  // ---------------- Misc ----------------
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
