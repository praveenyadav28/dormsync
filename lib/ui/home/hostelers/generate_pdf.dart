import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart' as http;
import 'package:dorm_sync/model/admission.dart';
import 'package:printing/printing.dart';

/// For web, we need dart:html
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

/// Generate Admission PDF with English form (Page 1)
/// and full asset images on Page 2 & Page 3.
Future<void> generateAdmissionPdf({
  required AdmissionList data,
  String? photoUrl, // network photo
  String? rulesPage2Image, // asset image path for page 2
  String? rulesPage3Image, // asset image path for page 3
  bool autoPrint = true,
}) async {
  final pdf = pw.Document();

  // Styles
  final headerStyle = pw.TextStyle(
    fontSize: 16,
    fontWeight: pw.FontWeight.bold,
  );
  final normalStyle = pw.TextStyle(fontSize: 13);
  final labelStyle = pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold);
  final smallStyle = pw.TextStyle(fontSize: 10);

  // Load student photo from network
  Uint8List? photoBytes;
  if (photoUrl != null) {
    final response = await http.get(Uri.parse(photoUrl));
    if (response.statusCode == 200) {
      photoBytes = response.bodyBytes;
    }
  }
  final photoImage = photoBytes != null ? pw.MemoryImage(photoBytes) : null;

  // Load rule images from assets
  pw.MemoryImage? page2Image;
  if (rulesPage2Image != null) {
    final bytes = await rootBundle.load(rulesPage2Image);
    page2Image = pw.MemoryImage(bytes.buffer.asUint8List());
  }

  pw.MemoryImage? page3Image;
  if (rulesPage3Image != null) {
    final bytes = await rootBundle.load(rulesPage3Image);
    page3Image = pw.MemoryImage(bytes.buffer.asUint8List());
  }

  // 🔹 Page 1: Admission Form
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(18),
      build: (context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Center(
              child: pw.Text(
                'Utkarsh Teacher Training College Sajjangarh, Banswara (Raj.)',
                style: headerStyle,
              ),
            ),
            pw.Center(
              child: pw.Text(
                'Hostel Admission Application Form',
                style: headerStyle,
              ),
            ),
            pw.SizedBox(height: 12),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Left
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                        children: [
                          pw.Text('Serial No.:', style: normalStyle),
                          pw.Expanded(
                            child: pw.Container(
                              height: 1,
                              color: PdfColors.black,
                              margin: pw.EdgeInsets.only(left: 4),
                            ),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 12),
                      pw.Container(
                        padding: pw.EdgeInsets.all(8),
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: PdfColors.black),
                        ),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Center(
                              child: pw.Text(
                                'For Office Use',
                                style: labelStyle,
                              ),
                            ),
                            pw.SizedBox(height: 8),
                            pw.Text(
                              '1. Admission/Re-admission Fee .......................',
                              style: normalStyle,
                            ),
                            pw.Text(
                              '2. Receipt No. ...................',
                              style: normalStyle,
                            ),
                            pw.SizedBox(height: 12),
                            pw.Center(
                              child: pw.Text(
                                'Receiver\'s Signature',
                                style: normalStyle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(width: 20),
                // Right
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('Session: ${data.year}', style: labelStyle),
                      pw.SizedBox(height: 4),
                      pw.Row(
                        children: [
                          pw.Text('College Admission No.', style: normalStyle),
                          pw.Expanded(
                            child: pw.Container(
                              height: 1,
                              color: PdfColors.black,
                              margin: pw.EdgeInsets.only(left: 4),
                            ),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 12),
                      pw.Container(
                        width: 100,
                        height: 120,
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(width: 1),
                        ),
                        child:
                            photoImage != null
                                ? pw.Image(photoImage, fit: pw.BoxFit.cover)
                                : pw.Center(
                                  child: pw.Text(
                                    'Signature with Photo',
                                    style: smallStyle,
                                  ),
                                ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 18),
            _twoColRow('1. Student-Teacher\'s Name', data.studentName ?? ""),
            _twoColRow('2. Father\'s Name', data.fatherName ?? ""),
            _twoColRow('3. Mother\'s Name', data.motherName ?? ""),
            _twoColRow(
              '4. Date of Birth',
              "${data.dateOfBirth!.day}-${data.dateOfBirth!.month}-${data.dateOfBirth!.year}",
            ),
            _twoColRow(
              '5. Correspondence Address',
              data.permanentAddress ?? "",
            ),
            _twoColRow('Aadhar Card No.', data.aadharNo ?? ""),
            _twoColRow('Pin Code', data.permanentPinCode ?? ""),
            _twoColRow(
              '6. Local Guardian\'s Name & Address (if any)',
              data.guardian ?? "",
            ),
            _twoColRow('Parent/Guardian Mobile No.', data.parentContect ?? ""),
            pw.SizedBox(height: 15),
            pw.Center(child: pw.Text('Oath', style: labelStyle)),
            pw.SizedBox(height: 8),
            pw.Text(
              'I hereby declare that I have thoroughly studied all the hostel rules mentioned in the college prospectus and will remain dutiful towards them. In case of non-compliance, the college/hostel will have the right to take disciplinary action against me.',
              style: normalStyle,
              textAlign: pw.TextAlign.left,
            ),
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                'Student-Teacher\'s Signature',
                style: normalStyle,
              ),
            ),
            pw.SizedBox(height: 12),
            pw.Text('Date:-', style: normalStyle),
            pw.SizedBox(height: 15),
            pw.Text(
              'Mr. / Ms. ${data.studentName ?? ""} is granted admission after paying the fee as per rules.',
              style: normalStyle,
            ),
            pw.SizedBox(height: 18),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Principal', style: normalStyle),
                pw.Text('Hostel Warden\'s Signature', style: normalStyle),
              ],
            ),
          ],
        );
      },
    ),
  );

  // 🔹 Page 2 & 3 Images
  if (page2Image != null) {
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (c) => pw.Image(page2Image!, fit: pw.BoxFit.fitWidth),
      ),
    );
  }
  if (page3Image != null) {
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (c) => pw.Image(page3Image!, fit: pw.BoxFit.fitWidth),
      ),
    );
  }

  // 🔹 Open PDF (Web vs Mobile)
  if (kIsWeb) {
    final bytes = await pdf.save();
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.window.open(url, "_blank");
  } else {
    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }
}

/// Helper for two-column row
pw.Widget _twoColRow(String label, String value) {
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 9),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          flex: 2,
          child: pw.Text(
            label,
            style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
          ),
        ),
        pw.Expanded(
          flex: 4,
          child: pw.Text(value, style: pw.TextStyle(fontSize: 13)),
        ),
      ],
    ),
  );
}
