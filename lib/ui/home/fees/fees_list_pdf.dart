import 'package:dorm_sync/model/fees.dart';
import 'package:dorm_sync/model/branches.dart';
import 'package:dorm_sync/ui/home/voucher/voucher_pdf.dart'; // for numberToWords
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<void> generateFeesListPdf(FeesList fees, BranchList? branchData) async {
  final pdf = pw.Document();

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

            // 🔹 Branch Info
            pw.Center(
              child: pw.Column(
                children: [
                  pw.Text(
                    branchData?.branchName ?? "",
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    branchData?.bCity ?? "",
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(fontSize: 10),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Text(
                    "Fee Structure",
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

            // 🔹 Student Info
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                pw.TableRow(
                  children: [
                    _cell("Student Name : ${fees.hostelerName ?? "-"}"),
                    _cell("Father's Name : ${fees.fatherName ?? "-"}"),
                  ],
                ),
                pw.TableRow(
                  children: [
                    _cell("Course : ${fees.courseName ?? "-"}"),
                    _cell(
                      "Admission Date : ${fees.admissionDate != null ? "${fees.admissionDate!.day}/${fees.admissionDate!.month}/${fees.admissionDate!.year}" : "-"}",
                    ),
                  ],
                ),
              ],
            ),

            pw.SizedBox(height: 10),

            // 🔹 Fee Structure Table
            pw.Text(
              "Fee Details:",
              style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
            ),
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                pw.TableRow(
                  children: [
                    _headerCell("Fee Type"),
                    _headerCell("Price"),
                    _headerCell("Discount"),
                    _headerCell("Remaining"),
                  ],
                ),
                ...?fees.feesStructure?.map(
                  (f) => pw.TableRow(
                    children: [
                      _cell(f.feesType ?? "-"),
                      _cell("Rs. ${f.price ?? 0}"),
                      _cell("Rs. ${f.discount ?? 0}"),
                      _cell("Rs. ${f.remaining ?? 0}"),
                    ],
                  ),
                ),
              ],
            ),

            pw.SizedBox(height: 10),

            // 🔹 Installments Table
            pw.Text(
              "Installment Plan:",
              style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
            ),
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                pw.TableRow(
                  children: [_headerCell("Date"), _headerCell("Amount")],
                ),
                ...?fees.installmentStructure?.map(
                  (i) => pw.TableRow(
                    children: [
                      _cell(i.date ?? "-"),
                      _cell("Rs. ${i.price?.toStringAsFixed(2) ?? "0"}"),
                    ],
                  ),
                ),
              ],
            ),

            pw.SizedBox(height: 10),

            // 🔹 Totals
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                pw.TableRow(
                  children: [
                    _cell("Total Fees: Rs. ${fees.totalAmount ?? "0"}"),
                    _cell("Discount: Rs. ${fees.discount ?? 0}"),
                  ],
                ),
                pw.TableRow(
                  children: [
                    _cell("EMI Received: Rs. ${fees.emiRecived ?? 0}"),
                    _cell("EMI Total: Rs. ${fees.emiTotal ?? 0}"),
                  ],
                ),
                pw.TableRow(
                  children: [
                    _cell("Remaining: Rs. ${fees.totalRemaining ?? 0}"),
                    _cell(
                      "Amount in Words: ${numberToWords(fees.totalAmount)}",
                    ),
                  ],
                ),
              ],
            ),

            pw.SizedBox(height: 20),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                "Authorised Signatory",
                style: pw.TextStyle(fontSize: 12),
              ),
            ),
          ],
        );
      },
    ),
  );

  await Printing.layoutPdf(onLayout: (format) async => pdf.save());
}

// 🔹 Helpers
pw.Widget _cell(String text) {
  return pw.Padding(
    padding: const pw.EdgeInsets.all(6),
    child: pw.Text(text, style: pw.TextStyle(fontSize: 10)),
  );
}

pw.Widget _headerCell(String text) {
  return pw.Padding(
    padding: const pw.EdgeInsets.all(6),
    child: pw.Text(
      text,
      style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
    ),
  );
}
