import 'dart:typed_data';
import 'package:dorm_sync/model/staff.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_saver/file_saver.dart';
import 'package:universal_html/html.dart' as html;

Future<void> exportStaffListToExcel(List<StaffList> data) async {
  final Excel excel = Excel.createExcel();
  final Sheet sheet = excel['StaffList'];

  // ✅ Header row
  sheet.appendRow([
    TextCellValue('ID'),
    TextCellValue('Licence No'),
    TextCellValue('Branch ID'),
    TextCellValue('Title'),
    TextCellValue('Staff ID'),
    TextCellValue('Staff Name'),
    TextCellValue('Relation Type'),
    TextCellValue('Name'),
    TextCellValue('Contact No'),
    TextCellValue('Whatsapp No'),
    TextCellValue('Email'),
    TextCellValue('Department'),
    TextCellValue('Designation'),
    TextCellValue('Joining Date'),
    TextCellValue('Aadhar No'),
    TextCellValue('Permanent Address'),
    TextCellValue('State'),
    TextCellValue('City'),
    TextCellValue('City/Town/Village'),
    TextCellValue('Address'),
    TextCellValue('Pin Code'),
    TextCellValue('Temporary Address'),
    TextCellValue('Licence No (Object)'),
    TextCellValue('Branch Name'),
    TextCellValue('Uploaded Files'),
  ]);

  // ✅ Data rows
  for (final s in data) {
    final filesStr = (s.uplodeFile ?? []).join(' | ');

    sheet.appendRow([
      TextCellValue(s.id?.toString() ?? ''),
      TextCellValue(s.licenceNo ?? ''),
      TextCellValue(s.branchId?.toString() ?? ''),
      TextCellValue(s.title ?? ''),
      TextCellValue(s.staffId ?? ''),
      TextCellValue(s.staffName ?? ''),
      TextCellValue(s.relationType ?? ''),
      TextCellValue(s.name ?? ''),
      TextCellValue(s.contactNo ?? ''),
      TextCellValue(s.whatsappNo?.toString() ?? ''),
      TextCellValue(s.email?.toString() ?? ''),
      TextCellValue(s.department ?? ''),
      TextCellValue(s.designation ?? ''),
      TextCellValue(s.joiningDate ?? ''),
      TextCellValue(s.aadharNo?.toString() ?? ''),
      TextCellValue(s.permanentAddress ?? ''),
      TextCellValue(s.state ?? ''),
      TextCellValue(s.city ?? ''),
      TextCellValue(s.cityTownVillage ?? ''),
      TextCellValue(s.address ?? ''),
      TextCellValue(s.pinCode ?? ''),
      TextCellValue(s.temporaryAddress ?? ''),
      TextCellValue(s.licence?.licenceNo ?? ''),
      TextCellValue(s.branch?.branchName ?? ''),
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
      ..setAttribute("download", "staff_list.xlsx")
      ..click();
    html.Url.revokeObjectUrl(url);
  } else {
    // Mobile/Desktop
    await FileSaver.instance.saveFile(
      name: "staff_list",
      bytes: Uint8List.fromList(fileBytes),
      fileExtension: "xlsx",
      mimeType: MimeType.microsoftExcel,
    );
  }
}
