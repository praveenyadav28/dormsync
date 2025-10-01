import 'dart:typed_data';
import 'package:dorm_sync/model/branches.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_saver/file_saver.dart';
import 'package:universal_html/html.dart' as html;

Future<void> exportBranchListToExcel(List<BranchList> data) async {
  final Excel excel = Excel.createExcel();
  final Sheet sheet = excel['BranchList'];

  // ✅ Header row
  sheet.appendRow([
    TextCellValue('ID'),
    TextCellValue('Licence No'),
    TextCellValue('Contact No'),
    TextCellValue('Name'),
    TextCellValue('Branch Name'),
    TextCellValue('Address'),
    TextCellValue('City'),
    TextCellValue('State'),
    TextCellValue('Location ID'),
  ]);

  // ✅ Data rows
  for (final b in data) {
    sheet.appendRow([
      TextCellValue(b.id?.toString() ?? ''),
      TextCellValue(b.licenceNo ?? ''),
      TextCellValue(b.contactNo ?? ''),
      TextCellValue(b.name ?? ''),
      TextCellValue(b.branchName ?? ''),
      TextCellValue(b.bAddress ?? ''),
      TextCellValue(b.bCity ?? ''),
      TextCellValue(b.bState ?? ''),
      TextCellValue(b.locationId?.toString() ?? ''),
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
      ..setAttribute("download", "branch_list.xlsx")
      ..click();
    html.Url.revokeObjectUrl(url);
  } else {
    // Mobile/Desktop
    await FileSaver.instance.saveFile(
      name: "branch_list",
      bytes: Uint8List.fromList(fileBytes),
      fileExtension: "xlsx",
      mimeType: MimeType.microsoftExcel,
    );
  }
}
