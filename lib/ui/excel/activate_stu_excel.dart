import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_saver/file_saver.dart';
import 'package:dorm_sync/model/activated.dart';
import 'package:universal_html/html.dart' as html;

Future<void> exportActivatedListToExcel(List<ActivatedList> data) async {
  final Excel excel = Excel.createExcel();
  final Sheet sheet = excel['ActivatedList'];

  // ✅ Header row
  sheet.appendRow([
    TextCellValue('ID'),
    TextCellValue('Licence No'),
    TextCellValue('Branch ID'),
    TextCellValue('Session ID'),
    TextCellValue('Hosteler Details'),
    TextCellValue('Hosteler ID'),
    TextCellValue('Admission Date'),
    TextCellValue('Hosteler Name'),
    TextCellValue('Contact No'),
    TextCellValue('Father Name'),
    TextCellValue('Join Date'),
    TextCellValue('Active Status'),
    TextCellValue('Remark'),
  ]);

  // ✅ Data rows
  for (final item in data) {
    sheet.appendRow([
      TextCellValue(item.id?.toString() ?? ''),
      TextCellValue(item.licenceNo ?? ''),
      TextCellValue(item.branchId?.toString() ?? ''),
      TextCellValue(item.sessionId?.toString() ?? ''),
      TextCellValue(item.hostelerDetails ?? ''),
      TextCellValue(item.hostelerId ?? ''),
      TextCellValue(item.admissionDate ?? ''),
      TextCellValue(item.hostelerName ?? ''),
      TextCellValue(item.contactNo ?? ''),
      TextCellValue(item.fatherName ?? ''),
      TextCellValue(item.joinDate ?? ''),
      TextCellValue(item.activeStatus ?? ''),
      TextCellValue(item.remark ?? ''),
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
      ..setAttribute("download", "activated_list.xlsx")
      ..click();
    html.Url.revokeObjectUrl(url);
  } else {
    // Mobile/Desktop
    await FileSaver.instance.saveFile(
      name: "activated_list",
      bytes: Uint8List.fromList(fileBytes),
      fileExtension: "xlsx",
      mimeType: MimeType.microsoftExcel,
    );
  }
}
