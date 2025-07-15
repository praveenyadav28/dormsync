// import 'package:flutter/material.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';

// class AdmissionFormPrintScreen extends StatefulWidget {
//   const AdmissionFormPrintScreen({super.key});

//   @override
//   _AdmissionFormPrintScreenState createState() => _AdmissionFormPrintScreenState();
// }

// class _AdmissionFormPrintScreenState extends State<AdmissionFormPrintScreen> {
//   final nameController = TextEditingController();
//   final fatherController = TextEditingController();
//   final motherController = TextEditingController();
//   final dobController = TextEditingController();
//   final addressController = TextEditingController();

//   Future<void> _generatePdf() async {
//     final pdf = pw.Document();

//     final image = await imageFromAssetBundle('assets/form_eng.png');

//     pdf.addPage(
//       pw.Page(
//         pageFormat: PdfPageFormat.a4,
//         build: (context) {
//           return pw.Stack(
//             children: [
//               pw.Positioned(child: pw.Center(child: pw.Image(image))),

//               // You need to adjust these `top` and `left` values as per your form layout
//               pw.Positioned(
//                 left: 100,
//                 top: 150,
//                 child: pw.Text('Name: ${nameController.text}', style: pw.TextStyle(fontSize: 12)),
//               ),
//               pw.Positioned(
//                 left: 100,
//                 top: 170,
//                 child: pw.Text('Father\'s Name: ${fatherController.text}', style: pw.TextStyle(fontSize: 12)),
//               ),
//               pw.Positioned(
//                 left: 100,
//                 top: 190,
//                 child: pw.Text('Mother\'s Name: ${motherController.text}', style: pw.TextStyle(fontSize: 12)),
//               ),
//               pw.Positioned(
//                 left: 100,
//                 top: 210,
//                 child: pw.Text('DOB: ${dobController.text}', style: pw.TextStyle(fontSize: 12)),
//               ),
//               pw.Positioned(
//                 left: 100,
//                 top: 230,
//                 child: pw.Text('Address: ${addressController.text}', style: pw.TextStyle(fontSize: 12)),
//               ),
//             ],
//           );
//         },
//       ),
//     );

//     await Printing.layoutPdf(onLayout: (format) => pdf.save());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Fill & Print Admission Form")),
//       body: Padding(
//         padding: EdgeInsets.all(16),
//         child: ListView(
//           children: [
//             TextField(controller: nameController, decoration: InputDecoration(labelText: 'Name')),
//             TextField(controller: fatherController, decoration: InputDecoration(labelText: 'Father\'s Name')),
//             TextField(controller: motherController, decoration: InputDecoration(labelText: 'Mother\'s Name')),
//             TextField(controller: dobController, decoration: InputDecoration(labelText: 'Date of Birth')),
//             TextField(controller: addressController, decoration: InputDecoration(labelText: 'Address')),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _generatePdf,
//               child: Text("Save & Print PDF"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
