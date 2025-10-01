import 'dart:typed_data';
import 'package:dorm_sync/model/fees_receive.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_saver/file_saver.dart';
import 'package:universal_html/html.dart' as html;

Future<void> exportFeesToExcel(List<ReceivedListModel> data) async {
  final Excel excel = Excel.createExcel();
  final Sheet sheet = excel['FeesReceived'];

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
    TextCellValue('Fees No'),
    TextCellValue('Entry Type'),
    TextCellValue('Date'),
    TextCellValue('Course'),
    TextCellValue('Ledger ID'),
    TextCellValue('Ledger Name'),
    TextCellValue('Amount'),
    TextCellValue('Narration'),
    TextCellValue('Receive By'),
    TextCellValue('Remark'),
    TextCellValue('Installment No'),
    TextCellValue('Active'),
    TextCellValue('Branch Name'),
    TextCellValue('Branch City'),
  ]);

  // ✅ Data rows
  for (final f in data) {
    sheet.appendRow([
      TextCellValue(f.id?.toString() ?? ''),
      TextCellValue(f.licenceNo ?? ''),
      TextCellValue(f.branchId?.toString() ?? ''),
      TextCellValue(f.sessionId?.toString() ?? ''),
      TextCellValue(f.hostelerDetails ?? ''),
      TextCellValue(f.hostelerId ?? ''),
      TextCellValue(f.admissionDate ?? ''),
      TextCellValue(f.hostelerName ?? ''),
      TextCellValue(f.contactNo ?? ''),
      TextCellValue(f.fatherName ?? ''),
      TextCellValue(f.feesNo?.toString() ?? ''),
      TextCellValue(f.entryType ?? ''),
      TextCellValue(f.date ?? ''),
      TextCellValue(f.course?.toString() ?? ''),
      TextCellValue(f.ledgerId ?? ''),
      TextCellValue(f.ledgerName ?? ''),
      TextCellValue(f.amount ?? ''),
      TextCellValue(f.narration ?? ''),
      TextCellValue(f.receiveBy ?? ''),
      TextCellValue(f.remark ?? ''),
      TextCellValue(f.installmentNo ?? ''),
      TextCellValue(f.isActive?.toString() ?? ''),
      TextCellValue(f.branch?.branchName ?? ''),
      TextCellValue(f.branch?.bCity ?? ''),
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
          ..setAttribute("download", "fees_received.xlsx")
          ..click();
    html.Url.revokeObjectUrl(url);
  } else {
    // ✅ Windows / Android / iOS
    await FileSaver.instance.saveFile(
      name: "fees_received",
      bytes: Uint8List.fromList(fileBytes),
      fileExtension: "xlsx",
      mimeType: MimeType.microsoftExcel,
    );
  }
}
