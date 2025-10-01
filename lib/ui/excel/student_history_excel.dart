import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_saver/file_saver.dart';
import 'package:universal_html/html.dart' as html;
import 'package:dorm_sync/model/assign_report.dart';

Future<void> exportStudentHistoryToExcel({
  required List<StudentReportList> studentList,
  required bool showExHostlerList,
  required Map<int, String> buildingMap,
  required Map<int, String> floorMap,
}) async {
  final Excel excel = Excel.createExcel();
  final Sheet sheet = excel['StudentHistory'];

  // ✅ Header row
  sheet.appendRow(showExHostlerList
      ? [
          TextCellValue('H-ID'),
          TextCellValue('Admission Date'),
          TextCellValue('Hosteler Name'),
          TextCellValue('Father Name'),
          TextCellValue('Contact Details'),
          TextCellValue('Building'),
          TextCellValue('Floor'),
          TextCellValue('Type'),
          TextCellValue('Room'),
        ]
      : [
          TextCellValue('H-ID'),
          TextCellValue('Admission Date'),
          TextCellValue('Hosteler Name'),
          TextCellValue('Father Name'),
          TextCellValue('Contact Details'),
        ]);

  // ✅ Data rows
  for (var student in studentList) {
    sheet.appendRow(showExHostlerList
        ? [
            TextCellValue(student.studentId ?? ''),
            TextCellValue(student.admissionDate ?? ''),
            TextCellValue(student.studentName ?? ''),
            TextCellValue(student.fatherName ?? ''),
            TextCellValue(student.primaryContactNo ?? ''),
            TextCellValue(buildingMap[student.buildingId] ?? ''),
            TextCellValue(floorMap[student.floorId] ?? ''),
            TextCellValue(student.roomType ?? ''),
            TextCellValue(student.roomNo ?? ''),
          ]
        : [
            TextCellValue(student.studentId ?? ''),
            TextCellValue(student.admissionDate ?? ''),
            TextCellValue(student.studentName ?? ''),
            TextCellValue(student.fatherName ?? ''),
            TextCellValue(student.primaryContactNo ?? ''),
          ]);
  }

  // ✅ Encode Excel
  final List<int>? fileBytes = excel.encode();
  if (fileBytes == null) return;

  if (kIsWeb) {
    final blob = html.Blob([fileBytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", "student_history.xlsx")
      ..click();
    html.Url.revokeObjectUrl(url);
  } else {
    await FileSaver.instance.saveFile(
      name: "student_history",
      bytes: Uint8List.fromList(fileBytes),
      fileExtension: "xlsx",
    );
  }
}
