import 'dart:typed_data';
import 'package:dorm_sync/model/visitor.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_saver/file_saver.dart';
import 'package:universal_html/html.dart' as html;

Future<void> exportVisitorListToExcel(List<VisitorList> data) async {
  final Excel excel = Excel.createExcel();
  final Sheet sheet = excel['VisitorList'];

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
    TextCellValue('Visiting Date'),
    TextCellValue('Visitor Name'),
    TextCellValue('Relation'),
    TextCellValue('Contact'),
    TextCellValue('Aadhar No'),
    TextCellValue('Purpose Of Visit'),
    TextCellValue('Date Of Leave'),
    TextCellValue('Visit Time'),
    TextCellValue('Leave Time'),
  ]);

  // ✅ Data rows
  for (final v in data) {
    sheet.appendRow([
      TextCellValue(v.id?.toString() ?? ''),
      TextCellValue(v.licenceNo ?? ''),
      TextCellValue(v.branchId?.toString() ?? ''),
      TextCellValue(v.hostelerDetails ?? ''),
      TextCellValue(v.hostelerId ?? ''),
      TextCellValue(v.admissionDate ?? ''),
      TextCellValue(v.hostelerName ?? ''),
      TextCellValue(v.courseName ?? ''),
      TextCellValue(v.fatherName ?? ''),
      TextCellValue(v.visitingDate ?? ''),
      TextCellValue(v.visitorName ?? ''),
      TextCellValue(v.relation ?? ''),
      TextCellValue(v.contact ?? ''),
      TextCellValue(v.aadharNo ?? ''),
      TextCellValue(v.purposeOfVisit ?? ''),
      TextCellValue(v.dateOfLeave ?? ''),
      TextCellValue(v.other1?.toString() ?? ''),
      TextCellValue(v.other2?.toString() ?? ''),
    ]);
  }

  // ✅ Encode Excel
  final List<int>? fileBytes = excel.encode();
  if (fileBytes == null) return;

  if (kIsWeb) {
    // Web download
    final blob = html.Blob([fileBytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor =
        html.AnchorElement(href: url)
          ..setAttribute("download", "visitor_list.xlsx")
          ..click();
    html.Url.revokeObjectUrl(url);
  } else {
    // Mobile/Desktop
    await FileSaver.instance.saveFile(
      name: "visitor_list",
      bytes: Uint8List.fromList(fileBytes),
      fileExtension: "xlsx",
      mimeType: MimeType.microsoftExcel,
    );
  }
}
