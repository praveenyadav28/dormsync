import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_saver/file_saver.dart';
import 'package:universal_html/html.dart' as html;

Future<void> exportLedgerReportToExcel(
  List<Map<String, dynamic>> reportList,
) async {
  final Excel excel = Excel.createExcel();
  final Sheet sheet = excel['LedgerReport'];

  // ✅ Header row
  sheet.appendRow([
    TextCellValue('T-Type'),
    TextCellValue('T-Date'),
    TextCellValue('T-With'),
    TextCellValue('Amount'),
    TextCellValue('Balance'),
    TextCellValue('B-Type'),
  ]);

  // ✅ Data rows
  for (final item in reportList) {
    sheet.appendRow([
      TextCellValue(item['type'] ?? ''),
      TextCellValue(item['date'] ?? ''),
      TextCellValue(item['name'] ?? ''),
      TextCellValue(item['amount']?.toStringAsFixed(2) ?? '0'),
      TextCellValue(item['balance']?.toStringAsFixed(2) ?? '0'),
      TextCellValue(
        item['balance'] != null && item['balance'] < 0 ? 'Cr' : 'Dr',
      ),
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
          ..setAttribute("download", "ledger_report.xlsx")
          ..click();
    html.Url.revokeObjectUrl(url);
  } else {
    // Mobile/Desktop
    await FileSaver.instance.saveFile(
      name: "admission_list",
      bytes: Uint8List.fromList(fileBytes),
      fileExtension: "xlsx",
      mimeType: MimeType.microsoftExcel,
    );
  }
}
