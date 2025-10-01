import 'dart:typed_data';
import 'package:dorm_sync/model/ledger.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_saver/file_saver.dart';
import 'package:universal_html/html.dart' as html;

Future<void> exportLedgerListToExcel(List<LedgerList> data) async {
  final Excel excel = Excel.createExcel();
  final Sheet sheet = excel['LedgerList'];

  // ✅ Header row
  sheet.appendRow([
    TextCellValue('ID'),
    TextCellValue('Licence No'),
    TextCellValue('Branch ID'),
    TextCellValue('Student ID'),
    TextCellValue('Title'),
    TextCellValue('Ledger Name'),
    TextCellValue('Relation Type'),
    TextCellValue('Name'),
    TextCellValue('Contact No'),
    TextCellValue('Whatsapp No'),
    TextCellValue('Email'),
    TextCellValue('Ledger Group'),
    TextCellValue('Opening Balance'),
    TextCellValue('Opening Type'),
    TextCellValue('Closing Balance'),
    TextCellValue('Closing Type'),
    TextCellValue('GST No'),
    TextCellValue('Aadhar No'),
    TextCellValue('Permanent Address'),
    TextCellValue('State'),
    TextCellValue('City'),
    TextCellValue('City/Town/Village'),
    TextCellValue('Pin Code'),
    TextCellValue('Temporary State'),
    TextCellValue('Temporary City'),
    TextCellValue('Temporary City/Town/Village'),
    TextCellValue('Temporary Pin Code'),
    TextCellValue('Temporary Address'),
    TextCellValue('Uploaded Files'),
  ]);

  // ✅ Data rows
  for (final l in data) {
    final filesStr = (l.uplodeFile ?? []).join(' | ');

    sheet.appendRow([
      TextCellValue(l.id?.toString() ?? ''),
      TextCellValue(l.licenceNo ?? ''),
      TextCellValue(l.branchId?.toString() ?? ''),
      TextCellValue(l.studentId?.toString() ?? ''),
      TextCellValue(l.title ?? ''),
      TextCellValue(l.ledgerName ?? ''),
      TextCellValue(l.relationType ?? ''),
      TextCellValue(l.name ?? ''),
      TextCellValue(l.contactNo ?? ''),
      TextCellValue(l.whatsappNo?.toString() ?? ''),
      TextCellValue(l.email?.toString() ?? ''),
      TextCellValue(l.ledgerGroup ?? ''),
      TextCellValue(l.openingBalance ?? ''),
      TextCellValue(l.openingType ?? ''),
      TextCellValue(l.closingBalance ?? ''),
      TextCellValue(l.closingType ?? ''),
      TextCellValue(l.gstNo?.toString() ?? ''),
      TextCellValue(l.aadharNo?.toString() ?? ''),
      TextCellValue(l.permanentAddress ?? ''),
      TextCellValue(l.state ?? ''),
      TextCellValue(l.city ?? ''),
      TextCellValue(l.cityTownVillage ?? ''),
      TextCellValue(l.pinCode ?? ''),
      TextCellValue(l.tstate ?? ''),
      TextCellValue(l.tcity ?? ''),
      TextCellValue(l.tcityTownVillage ?? ''),
      TextCellValue(l.tpinCode ?? ''),
      TextCellValue(l.temporaryAddress?.toString() ?? ''),
      TextCellValue(filesStr),
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
      ..setAttribute("download", "ledger_list.xlsx")
      ..click();
    html.Url.revokeObjectUrl(url);
  } else {
    // Mobile/Desktop
    await FileSaver.instance.saveFile(
      name: "ledger_list",
      bytes: Uint8List.fromList(fileBytes),
      fileExtension: "xlsx",
      mimeType: MimeType.microsoftExcel,
    );
  }
}
