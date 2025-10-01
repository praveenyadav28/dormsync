import 'dart:typed_data';
import 'package:dorm_sync/model/item_model.dart';
import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_saver/file_saver.dart';
import 'package:universal_html/html.dart' as html;

Future<void> exportItemListToExcel(List<ItemList> data) async {
  final Excel excel = Excel.createExcel();
  final Sheet sheet = excel['ItemList'];

  // ✅ Header row
  sheet.appendRow([
    TextCellValue('ID'),
    TextCellValue('Licence No'),
    TextCellValue('Branch ID'),
    TextCellValue('Item No'),
    TextCellValue('Item Name'),
    TextCellValue('Item Group'),
    TextCellValue('Manufacturer'),
    TextCellValue('Stock Quantity'),
  ]);

  // ✅ Data rows
  for (final item in data) {
    sheet.appendRow([
      TextCellValue(item.id?.toString() ?? ''),
      TextCellValue(item.licenceNo ?? ''),
      TextCellValue(item.branchId?.toString() ?? ''),
      TextCellValue(item.itemNo ?? ''),
      TextCellValue(item.itemName ?? ''),
      TextCellValue(item.itemGroup ?? ''),
      TextCellValue(item.manufacturer ?? ''),
      TextCellValue(item.stockQty?.toString() ?? ''),
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
      ..setAttribute("download", "item_list.xlsx")
      ..click();
    html.Url.revokeObjectUrl(url);
  } else {
    // Mobile/Desktop
    await FileSaver.instance.saveFile(
      name: "item_list",
      bytes: Uint8List.fromList(fileBytes),
      fileExtension: "xlsx",
      mimeType: MimeType.microsoftExcel,
    );
  }
}
