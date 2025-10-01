import 'dart:typed_data';
import 'package:dorm_sync/model/admission.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_saver/file_saver.dart';
import 'package:universal_html/html.dart' as html;

Future<void> exportAdmissionListToExcel(List<AdmissionList> data) async {
  final Excel excel = Excel.createExcel();
  final Sheet sheet = excel['AdmissionList'];

  // ✅ Header row
  sheet.appendRow([
    TextCellValue('ID'),
    TextCellValue('Licence No'),
    TextCellValue('Branch ID'),
    TextCellValue('Admission Date'),
    TextCellValue('Student ID'),
    TextCellValue('Student Name'),
    TextCellValue('Gender'),
    TextCellValue('Marital Status'),
    TextCellValue('Aadhar No'),
    TextCellValue('Caste'),
    TextCellValue('Primary Contact'),
    TextCellValue('Whatsapp No'),
    TextCellValue('Email'),
    TextCellValue('College Name'),
    TextCellValue('Course'),
    TextCellValue('Date of Birth'),
    TextCellValue('Year'),
    TextCellValue('Father Name'),
    TextCellValue('Mother Name'),
    TextCellValue('Parent Contact'),
    TextCellValue('Guardian'),
    TextCellValue('Emergency No'),
    TextCellValue('Permanent Address'),
    TextCellValue('Permanent State'),
    TextCellValue('Permanent City'),
    TextCellValue('Permanent City Town'),
    TextCellValue('Permanent PinCode'),
    TextCellValue('Temporary Address'),
    TextCellValue('Temporary State'),
    TextCellValue('Temporary City'),
    TextCellValue('Temporary City Town'),
    TextCellValue('Temporary PinCode'),
    TextCellValue('Active Status'),
    TextCellValue('Branch Name'),
    TextCellValue('Ledger Name'),
    TextCellValue('Uploaded Files'),
  ]);

  // ✅ Data rows
  for (final a in data) {
    final filesStr = (a.uplodeFile ?? []).join(' | ');

    sheet.appendRow([
      TextCellValue(a.id?.toString() ?? ''),
      TextCellValue(a.licenceNo ?? ''),
      TextCellValue(a.branchId?.toString() ?? ''),
      TextCellValue(a.admissionDate?.toIso8601String() ?? ''),
      TextCellValue(a.studentId ?? ''),
      TextCellValue(a.studentName ?? ''),
      TextCellValue(a.gender ?? ''),
      TextCellValue(a.maritalStatus ?? ''),
      TextCellValue(a.aadharNo ?? ''),
      TextCellValue(a.caste ?? ''),
      TextCellValue(a.primaryContactNo ?? ''),
      TextCellValue(a.whatsappNo ?? ''),
      TextCellValue(a.email ?? ''),
      TextCellValue(a.collegeName ?? ''),
      TextCellValue(a.course ?? ''),
      TextCellValue(a.dateOfBirth?.toIso8601String() ?? ''),
      TextCellValue(a.year ?? ''),
      TextCellValue(a.fatherName ?? ''),
      TextCellValue(a.motherName ?? ''),
      TextCellValue(a.parentContect ?? ''),
      TextCellValue(a.guardian ?? ''),
      TextCellValue(a.emergencyNo ?? ''),
      TextCellValue(a.permanentAddress ?? ''),
      TextCellValue(a.permanentState ?? ''),
      TextCellValue(a.permanentCity ?? ''),
      TextCellValue(a.permanentCityTown ?? ''),
      TextCellValue(a.permanentPinCode ?? ''),
      TextCellValue(a.temporaryAddress ?? ''),
      TextCellValue(a.temporaryState ?? ''),
      TextCellValue(a.temporaryCity ?? ''),
      TextCellValue(a.temporaryCityTown ?? ''),
      TextCellValue(a.temporaryPinCode ?? ''),
      TextCellValue(a.activeStatus ?? ''),
      TextCellValue(a.branch?.branchName ?? ''),
      TextCellValue(a.ledger?.ledgerName ?? ''),
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
      ..setAttribute("download", "admission_list.xlsx")
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
