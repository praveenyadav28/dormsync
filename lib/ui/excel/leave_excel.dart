import 'dart:typed_data';
import 'package:dorm_sync/model/leave.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_saver/file_saver.dart';
import 'package:universal_html/html.dart' as html;

Future<void> exportLeaveListToExcel(List<LeaveList> data) async {
  final Excel excel = Excel.createExcel();
  final Sheet sheet = excel['LeaveList'];

  // ✅ Header row
  sheet.appendRow([
    TextCellValue('ID'),
    TextCellValue('Licence No'),
    TextCellValue('Branch ID'),
    TextCellValue('Hosteler Details'),
    TextCellValue('Hosteler ID'),
    TextCellValue('Admission Date'),
    TextCellValue('Hosteler Name'),
    TextCellValue('Course Name'),
    TextCellValue('Father Name'),
    TextCellValue('From Date'),
    TextCellValue('Accompanied By'),
    TextCellValue('Relation'),
    TextCellValue('Destination'),
    TextCellValue('Contact'),
    TextCellValue('Aadhar No'),
    TextCellValue('Purpose Of Leave'),
    TextCellValue('To Date'),
    TextCellValue('Other1'),
    TextCellValue('Other2'),
    TextCellValue('Other3'),
    TextCellValue('Other4'),
    TextCellValue('Other5'),
  ]);

  // ✅ Data rows
  for (final l in data) {
    sheet.appendRow([
      TextCellValue(l.id?.toString() ?? ''),
      TextCellValue(l.licenceNo ?? ''),
      TextCellValue(l.branchId?.toString() ?? ''),
      TextCellValue(l.hostelerDetails ?? ''),
      TextCellValue(l.hostelerId ?? ''),
      TextCellValue(l.admissionDate ?? ''),
      TextCellValue(l.hostelerName ?? ''),
      TextCellValue(l.courseName ?? ''),
      TextCellValue(l.fatherName ?? ''),
      TextCellValue(l.fromDate ?? ''),
      TextCellValue(l.accompainedBy ?? ''),
      TextCellValue(l.relation ?? ''),
      TextCellValue(l.destination ?? ''),
      TextCellValue(l.contact ?? ''),
      TextCellValue(l.aadharNo ?? ''),
      TextCellValue(l.purposeOfLeave ?? ''),
      TextCellValue(l.toDate ?? ''),
      TextCellValue(l.other1?.toString() ?? ''),
      TextCellValue(l.other2?.toString() ?? ''),
      TextCellValue(l.other3?.toString() ?? ''),
      TextCellValue(l.other4?.toString() ?? ''),
      TextCellValue(l.other5?.toString() ?? ''),
    ]);
  }

  // ✅ Encode Excel
  final List<int>? fileBytes = excel.encode();
  if (fileBytes == null) return;

  if (kIsWeb) {
    // Web download
    final blob = html.Blob([fileBytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", "leave_list.xlsx")
      ..click();
    html.Url.revokeObjectUrl(url);
  } else {
    // Mobile/Desktop
    await FileSaver.instance.saveFile(
      name: "leave_list",
      bytes: Uint8List.fromList(fileBytes),
      fileExtension: "xlsx",
      mimeType: MimeType.microsoftExcel,
    );
  }
}
