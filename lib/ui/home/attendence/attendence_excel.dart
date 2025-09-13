// ignore_for_file: unused_local_variable

import 'dart:typed_data';
import 'package:dorm_sync/model/attendencemodel.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_saver/file_saver.dart';
import 'package:universal_html/html.dart' as html;

Future<void> exportAttendanceToExcel(List<AttendenceModel> data) async {
  var excel = Excel.createExcel();
  Sheet sheet = excel['Attendance'];

  // Header row
  sheet.appendRow([
    TextCellValue('Hosteler ID'),
    TextCellValue('Admission Date'),
    TextCellValue('Hosteler Name'),
    TextCellValue('Father Name'),
    TextCellValue('Course'),
    TextCellValue('Biomax ID'),
    TextCellValue('Active Status'),
  ]);

  // Data rows
  for (var student in data) {
    sheet.appendRow([
      TextCellValue(student.hostelerId ?? ''),
      TextCellValue(student.admissionDate ?? ''),
      TextCellValue(student.hostelerName ?? ''),
      TextCellValue(student.fatherName ?? ''),
      TextCellValue(student.courseName ?? ''),
      TextCellValue(student.hostelBiomax ?? ''),
      TextCellValue(student.activeStatus == "1" ? "Active" : "Inactive"),
    ]);
  }

  final fileBytes = excel.encode();

  if (fileBytes == null) return;

  if (kIsWeb) {
    // ✅ Web download
    final blob = html.Blob([fileBytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor =
        html.AnchorElement(href: url)
          ..setAttribute("download", "attendance.xlsx")
          ..click();
    html.Url.revokeObjectUrl(url);
  } else {
    // ✅ Windows / Android / iOS
    await FileSaver.instance.saveFile(
      name: "attendance",
      bytes: Uint8List.fromList(fileBytes),
      fileExtension: "xlsx",
      mimeType: MimeType.microsoftExcel,
    );
  }
}
