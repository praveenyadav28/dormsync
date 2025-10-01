import 'dart:typed_data';
import 'package:dorm_sync/model/fees.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_saver/file_saver.dart';
import 'package:universal_html/html.dart' as html;

Future<void> exportFeesListToExcel(List<FeesList> data) async {
  final Excel excel = Excel.createExcel();
  final Sheet sheet = excel['FeesList'];

  // ✅ Header row
  sheet.appendRow([
    TextCellValue('ID'),
    TextCellValue('Licence No'),
    TextCellValue('Branch ID'),
    TextCellValue('Hosteler ID'),
    TextCellValue('Admission Date'),
    TextCellValue('Hosteler Name'),
    TextCellValue('Course Name'),
    TextCellValue('Father Name'),
    TextCellValue('Total Amount'),
    TextCellValue('Discount'),
    TextCellValue('Total Remaining'),
    TextCellValue('EMI Received'),
    TextCellValue('EMI Total'),
    TextCellValue('Branch Name'),
    TextCellValue('Branch City'),
    TextCellValue('Licence No (Object)'),
    TextCellValue('Fees Structure'),
    TextCellValue('Installment Structure'),
  ]);

  // ✅ Data rows
  for (final f in data) {
    // Flatten feesStructure
    final feesStructureStr = (f.feesStructure ?? [])
        .map((fs) =>
            '${fs.feesType ?? ''}: Price=${fs.price}, Disc=${fs.discount}, Rem=${fs.remaining}')
        .join(' | ');

    // Flatten installmentStructure
    final installmentStr = (f.installmentStructure ?? [])
        .map((ins) => '${ins.date ?? ''}: ${ins.price ?? 0}')
        .join(' | ');

    sheet.appendRow([
      TextCellValue(f.id?.toString() ?? ''),
      TextCellValue(f.licenceNo ?? ''),
      TextCellValue(f.branchId?.toString() ?? ''),
      TextCellValue(f.hostelerId ?? ''),
      TextCellValue(
          f.admissionDate != null ? f.admissionDate!.toIso8601String() : ''),
      TextCellValue(f.hostelerName ?? ''),
      TextCellValue(f.courseName ?? ''),
      TextCellValue(f.fatherName ?? ''),
      TextCellValue(f.totalAmount ?? ''),
      TextCellValue(f.discount?.toString() ?? ''),
      TextCellValue(f.totalRemaining?.toString() ?? ''),
      TextCellValue(f.emiRecived?.toString() ?? ''),
      TextCellValue(f.emiTotal?.toString() ?? ''),
      TextCellValue(f.branch?.branchName ?? ''),
      TextCellValue(f.branch?.bCity ?? ''),
      TextCellValue(f.licence?.licenceNo ?? ''),
      TextCellValue(feesStructureStr),
      TextCellValue(installmentStr),
    ]);
  }

  // Encode Excel
  final List<int>? fileBytes = excel.encode();
  if (fileBytes == null) return;

  if (kIsWeb) {
    // ✅ Web download
    final blob = html.Blob([fileBytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", "fees_list.xlsx")
      ..click();
    html.Url.revokeObjectUrl(url);
  } else {
    // ✅ Windows / Android / iOS
    await FileSaver.instance.saveFile(
      name: "fees_list",
      bytes: Uint8List.fromList(fileBytes),
      fileExtension: "xlsx",
      mimeType: MimeType.microsoftExcel,
    );
  }
}
