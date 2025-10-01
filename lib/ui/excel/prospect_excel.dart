import 'dart:typed_data';
import 'package:dorm_sync/model/prospect.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_saver/file_saver.dart';
import 'package:universal_html/html.dart' as html;

Future<void> exportProspectsToExcel(List<ProspectList> data) async {
  // Create a new Excel workbook
  final Excel excel = Excel.createExcel();
  final Sheet sheet = excel['Prospects'];

  // ✅ Header row
  sheet.appendRow([
    TextCellValue('ID'),
    TextCellValue('Licence No'),
    TextCellValue('Branch ID'),
    TextCellValue('Student Name'),
    TextCellValue('Gender'),
    TextCellValue('Contact No'),
    TextCellValue('Father Name'),
    TextCellValue('Father Contact'),
    TextCellValue('Address'),
    TextCellValue('Staff'),
    TextCellValue('Next Appointment'),
    TextCellValue('Prospect Date'),
    TextCellValue('Time'),
    TextCellValue('Remark'),
    TextCellValue('City'),
    TextCellValue('State'),
    TextCellValue('Prospect Status'),
  ]);

  // ✅ Data rows
  for (final p in data) {
    sheet.appendRow([
      TextCellValue(p.id?.toString() ?? ''),
      TextCellValue(p.licenceNo ?? ''),
      TextCellValue(p.branchId?.toString() ?? ''),
      TextCellValue(p.studentName ?? ''),
      TextCellValue(p.gender ?? ''),
      TextCellValue(p.contactNo ?? ''),
      TextCellValue(p.fatherName ?? ''),
      TextCellValue(p.fContactNo ?? ''),
      TextCellValue(p.address ?? ''),
      TextCellValue(p.staff ?? ''),
      TextCellValue(p.nextAppointmentDate ?? ''),
      TextCellValue(p.prospectDate ?? ''),
      TextCellValue(p.time ?? ''),
      TextCellValue(p.remark ?? ''),
      TextCellValue(p.city ?? ''),
      TextCellValue(p.state ?? ''),
      TextCellValue(p.prospectStatus ?? ''),
    ]);
  }

  // Encode Excel
  final List<int>? fileBytes = excel.encode();
  if (fileBytes == null) return;

  if (kIsWeb) {
    // ✅ Web download
    final blob = html.Blob([fileBytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor =
        html.AnchorElement(href: url)
          ..setAttribute("download", "prospects.xlsx")
          ..click();
    html.Url.revokeObjectUrl(url);
  } else {
    // ✅ Windows / Android / iOS
    await FileSaver.instance.saveFile(
      name: "prospects",
      bytes: Uint8List.fromList(fileBytes),
      fileExtension: "xlsx",
      mimeType: MimeType.microsoftExcel,
    );
  }
}
