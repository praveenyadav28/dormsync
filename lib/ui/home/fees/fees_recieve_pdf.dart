import 'package:dorm_sync/model/branches.dart';
import 'package:dorm_sync/model/fees_receive.dart';
import 'package:dorm_sync/ui/home/voucher/voucher_pdf.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<void> generateFeesReceivePdf(
  ReceivedListModel fees,
  BranchList? branchData,
) async {
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

            // 🔹 Branch & Company Info
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
                    "Fees Receipt",
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

            // 🔹 Student & Receipt Info
            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                pw.TableRow(
                  children: [
                    _cell("Received From :\n${fees.hostelerName ?? "-"}"),
                    _cell(
                      "Receipt No : ${fees.feesNo ?? "-"}\n"
                      "Date : ${fees.date ?? "-"}",
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
                    _cell("Father's Name : ${fees.fatherName ?? "-"}"),
                    _cell("Contact No : ${fees.contactNo ?? "-"}"),
                  ],
                ),
              ],
            ),

            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                pw.TableRow(
                  children: [
                    _cell("Amounts in Words :\n${numberToWords(fees.amount)}"),
                    _cell("Rs.: ${fees.amount ?? "0"}"),
                  ],
                ),
              ],
            ),

            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                pw.TableRow(
                  children: [
                    _cell("Course : ${fees.course ?? "-"}"),
                    _cell("Installment No : ${fees.installmentNo ?? "-"}"),
                  ],
                ),
              ],
            ),

            pw.Table(
              border: pw.TableBorder.all(),
              children: [
                pw.TableRow(
                  children: [
                    _cell("Narration : ${fees.narration ?? "-"}"),
                    _cell("Received By : ${fees.receiveBy ?? "-"}"),
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

pw.Widget _cell(String text) {
  return pw.Padding(
    padding: const pw.EdgeInsets.all(8),
    child: pw.Text(text, style: pw.TextStyle(fontSize: 10)),
  );
}
