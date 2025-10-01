import 'dart:typed_data';
import 'package:dorm_sync/model/voucher_model.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_saver/file_saver.dart';
import 'package:universal_html/html.dart' as html;

Future<void> exportVoucherListToExcel(List<VoucherModel> data) async {
  final Excel excel = Excel.createExcel();
  final Sheet sheet = excel['VoucherList'];

  // ✅ Header row
  sheet.appendRow([
    TextCellValue('ID'),
    TextCellValue('Licence No'),
    TextCellValue('Branch ID'),
    TextCellValue('Voucher Type'),
    TextCellValue('Voucher Date'),
    TextCellValue('Voucher No'),
    TextCellValue('Payment Mode'),
    TextCellValue('Payment Balance'),
    TextCellValue('Acc Ledger ID'),
    TextCellValue('Pay Ledger ID'),
    TextCellValue('Account Head'),
    TextCellValue('Account Balance'),
    TextCellValue('Amount'),
    TextCellValue('Narration'),
    TextCellValue('Paid By'),
    TextCellValue('Remark'),
    TextCellValue('Licence No (Object)'),
    TextCellValue('Branch Name'),
    TextCellValue('Branch City'),
    TextCellValue('Uploaded Files'),
  ]);

  // ✅ Data rows
  for (final v in data) {
    final filesStr = (v.uplodeFile ?? []).join(' | ');

    sheet.appendRow([
      TextCellValue(v.id?.toString() ?? ''),
      TextCellValue(v.licenceNo ?? ''),
      TextCellValue(v.branchId?.toString() ?? ''),
      TextCellValue(v.voucherType ?? ''),
      TextCellValue(v.voucherDate ?? ''),
      TextCellValue(v.voucherNo?.toString() ?? ''),
      TextCellValue(v.paymentMode ?? ''),
      TextCellValue(v.paymentBalance ?? ''),
      TextCellValue(v.accLedgerId ?? ''),
      TextCellValue(v.payLedgerId ?? ''),
      TextCellValue(v.accountHead ?? ''),
      TextCellValue(v.accountBalance ?? ''),
      TextCellValue(v.amount ?? ''),
      TextCellValue(v.narration ?? ''),
      TextCellValue(v.paidBy ?? ''),
      TextCellValue(v.remark ?? ''),
      TextCellValue(v.licence?.licenceNo ?? ''),
      TextCellValue(v.branch?.branchName ?? ''),
      TextCellValue(v.branch?.bCity ?? ''),
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
    final anchor =
        html.AnchorElement(href: url)
          ..setAttribute("download", "voucher_list.xlsx")
          ..click();
    html.Url.revokeObjectUrl(url);
  } else {
    // Mobile/Desktop
    await FileSaver.instance.saveFile(
      name: "voucher_list",
      bytes: Uint8List.fromList(fileBytes),
      fileExtension: "xlsx",
      mimeType: MimeType.microsoftExcel,
    );
  }
}
