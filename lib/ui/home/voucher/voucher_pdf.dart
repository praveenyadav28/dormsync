import 'package:dorm_sync/model/branches.dart';
import 'package:dorm_sync/model/voucher_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<void> generateVoucherPdf(
  VoucherModel voucher,
  BranchList? branchDate,
) async {
  final pdf = pw.Document();

  // Decide labels dynamically
  final bool isReceipt = (voucher.voucherType?.toLowerCase() == "receipt");
  final String accountLabel =
      isReceipt ? "Paid By" : "Received With Thanks From";

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(20),
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // 🔹 Header
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("", style: pw.TextStyle(fontSize: 12)),
                pw.Text("Original", style: pw.TextStyle(fontSize: 12)),
              ],
            ),
            pw.SizedBox(height: 10),

            pw.Center(
              child: pw.Column(
                children: [
                  pw.Text(
                    branchDate?.branchName ?? "",
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    branchDate?.bAddress ?? "",
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(fontSize: 10),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Text(
                    voucher.voucherType ?? "",
                    style: pw.TextStyle(
                      fontSize: 14,
                      decoration: pw.TextDecoration.underline,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 10),

            // 🔹 Receipt Info Table
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                pw.TableRow(
                  children: [
                    _cell("$accountLabel\n${voucher.accountHead ?? "-"}"),
                    _cell(
                      "Cheque Receipt is Subject To Realisation.\n"
                      "REF.NO : ${voucher.voucherNo ?? "-"}\n"
                      "DATE : ${voucher.voucherDate ?? "-"}",
                    ),
                  ],
                ),
              ],
            ),

            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                pw.TableRow(
                  children: [
                    _cell(
                      "Amounts in Words :\n${numberToWords(voucher.amount)}",
                    ),
                    _cell("Rs.: ${voucher.amount ?? "0"}"),
                  ],
                ),
              ],
            ),

            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                pw.TableRow(
                  children: [
                    _cell("Description :\n${voucher.narration ?? "-"}"),
                    _cell("For ${voucher.branch?.branchName ?? "Company"}"),
                  ],
                ),
              ],
            ),

            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                pw.TableRow(
                  children: [
                    _cell(
                      "Deposited in : ${voucher.paymentMode ?? "-"}\n"
                      "Date : ${voucher.voucherDate ?? "-"}\n"
                      "${isReceipt ? "Received From" : "Paid By"} : ${voucher.paidBy ?? "-"}",
                    ),
                    _cell("Authorised Signatory"),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    ),
  );

  await Printing.layoutPdf(onLayout: (format) async => pdf.save());
}

pw.Widget _cell(String text) {
  return pw.Padding(
    padding: const pw.EdgeInsets.all(8),
    child: pw.Text(text, style: pw.TextStyle(fontSize: 10)),
  );
}

String numberToWords(String? amount) {
  if (amount == null || amount.isEmpty) return "-";

  int value = int.tryParse(amount.split(".").first) ?? 0;

  if (value == 0) return "Zero Rupees Only.";

  final units = [
    "",
    "One",
    "Two",
    "Three",
    "Four",
    "Five",
    "Six",
    "Seven",
    "Eight",
    "Nine",
    "Ten",
    "Eleven",
    "Twelve",
    "Thirteen",
    "Fourteen",
    "Fifteen",
    "Sixteen",
    "Seventeen",
    "Eighteen",
    "Nineteen",
  ];

  final tens = [
    "",
    "",
    "Twenty",
    "Thirty",
    "Forty",
    "Fifty",
    "Sixty",
    "Seventy",
    "Eighty",
    "Ninety",
  ];

  String convert(int n) {
    if (n < 20) return units[n];
    if (n < 100) {
      return tens[n ~/ 10] + (n % 10 != 0 ? " ${units[n % 10]}" : "");
    }
    if (n < 1000) {
      return "${units[n ~/ 100]} Hundred${n % 100 != 0 ? " ${convert(n % 100)}" : ""}";
    }
    if (n < 100000) {
      return "${convert(n ~/ 1000)} Thousand${n % 1000 != 0 ? " ${convert(n % 1000)}" : ""}";
    }
    if (n < 10000000) {
      return "${convert(n ~/ 100000)} Lakh${n % 100000 != 0 ? " ${convert(n % 100000)}" : ""}";
    }
    return "${convert(n ~/ 10000000)} Crore${n % 10000000 != 0 ? " ${convert(n % 10000000)}" : ""}";
  }

  return "${convert(value)} Rupees Only.";
}
