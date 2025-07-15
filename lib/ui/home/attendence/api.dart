import 'dart:convert';

import 'package:dorm_sync/model/attendencemodel.dart';
import 'package:http/http.dart' as http;

class ApiSalary {
  Future<List<DeviceLog>> fetchLogs(String fromDate, String toDate) async {
    final response = await http.get(
      Uri.parse(
        "http://103.178.113.149:82/api/v2/WebAPI/GetDeviceLogs?APIKey=555312092406&FromDate=$fromDate&ToDate=$toDate",
      ),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => DeviceLog.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load device logs');
    }
  }
}
