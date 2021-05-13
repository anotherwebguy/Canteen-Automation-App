import 'dart:typed_data';
import 'dart:ui';

import 'package:canteen_app/Helpers/pdfView.dart';
import 'package:canteen_app/Model/recieptorder.dart';
import 'package:canteen_app/Services/dbdata.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart' as material;
recieptView(context, List<Orders> orderslist) async {
  final Document pdf = Document();

  final profileImage = MemoryImage(
    (await rootBundle.load('assets/food_icon.png')).buffer.asUint8List(),
  );

  pdf.addPage(MultiPage(
      pageFormat:
          PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
      crossAxisAlignment: CrossAxisAlignment.start,
      header: (Context context) {
        if (context.pageNumber == 1) {
          return null;
        }
        return Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            padding: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 0.5, color: PdfColors.grey),
              ),
            ),
            child: Text('Sales-Report',
                style: Theme.of(context)
                    .defaultTextStyle
                    .copyWith(color: PdfColors.grey)));
      },
      footer: (Context context) {
        return Container(
            alignment: Alignment.centerRight,
            margin: const EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
            child: Text('Page ${context.pageNumber} of ${context.pagesCount}',
                style: Theme.of(context)
                    .defaultTextStyle
                    .copyWith(color: PdfColors.grey)));
      },
      build: (Context context) => <Widget>[
            Header(
                level: 0,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('InstaFood\nSales-Report', textScaleFactor: 2),
                    ])),
            SizedBox(height: 10),
            Center(
              child: Container(
                  height: 100, width: 100, child: Image.provider(profileImage)),
            ),
            Center(
              child: Text('InstaFood App', textScaleFactor: 2)
            ),
            SizedBox(height: 10),
            Text("Sales-Report Generation of Year: " +
                DateTime.now().year.toString()),
            SizedBox(height: 10),
            Header(
                level: 1,
                text: 'Sales-Report Generated From The InstaFood App'),
            Padding(padding: const EdgeInsets.all(10)),
            Table.fromTextArray(context: context, data: <List<String>>[
              <String>['Month', 'Total Earnings', 'Profit %', 'Loss %'],
              <String>[
                orderslist[0].getIndex(0),
                "Rs" + " " + orderslist[0].getIndex(3),
                orderslist[0].getIndex(1) + "%",
                orderslist[0].getIndex(2) + "%"
              ],
              <String>[
                orderslist[1].getIndex(0),
                "Rs" + " " + orderslist[1].getIndex(3),
                orderslist[1].getIndex(1) + "%",
                orderslist[1].getIndex(2) + "%"
              ],
              <String>[
                orderslist[2].getIndex(0),
                "Rs" + " " + orderslist[2].getIndex(3),
                orderslist[2].getIndex(1) + "%",
                orderslist[2].getIndex(2) + "%"
              ],
              <String>[
                orderslist[3].getIndex(0),
                "Rs" + " " + orderslist[3].getIndex(3),
                orderslist[3].getIndex(1) + "%",
                orderslist[3].getIndex(2) + "%"
              ],
              <String>[
                orderslist[4].getIndex(0),
                "Rs" + " " + orderslist[4].getIndex(3),
                orderslist[4].getIndex(1) + "%",
                orderslist[4].getIndex(2) + "%"
              ],
              <String>[
                orderslist[5].getIndex(0),
                "Rs" + " " + orderslist[5].getIndex(3),
                orderslist[5].getIndex(1) + "%",
                orderslist[5].getIndex(2) + "%"
              ],
              <String>[
                orderslist[6].getIndex(0),
                "Rs" + " " + orderslist[6].getIndex(3),
                orderslist[6].getIndex(1) + "%",
                orderslist[6].getIndex(2) + "%"
              ],
              <String>[
                orderslist[7].getIndex(0),
                "Rs" + " " + orderslist[7].getIndex(3),
                orderslist[7].getIndex(1) + "%",
                orderslist[7].getIndex(2) + "%"
              ],
              <String>[
                orderslist[8].getIndex(0),
                "Rs" + " " + orderslist[8].getIndex(3),
                orderslist[8].getIndex(1) + "%",
                orderslist[8].getIndex(2) + "%"
              ],
              <String>[
                orderslist[9].getIndex(0),
                "Rs" + " " + orderslist[9].getIndex(3),
                orderslist[9].getIndex(1) + "%",
                orderslist[9].getIndex(2) + "%"
              ],
              <String>[
                orderslist[10].getIndex(0),
                "Rs" + " " + orderslist[10].getIndex(3),
                orderslist[10].getIndex(1) + "%",
                orderslist[10].getIndex(2) + "%"
              ],
              <String>[
                orderslist[11].getIndex(0),
                "Rs" + " " + orderslist[11].getIndex(3),
                orderslist[11].getIndex(1) + "%",
                orderslist[11].getIndex(2) + "%"
              ],
            ]),
            SizedBox(height: 10),
            Paragraph(
                text: 'Thankyou for your Business',
                style: const TextStyle(fontSize: 20)),
          ]));
  //save PDF

  final String dir = (await getApplicationDocumentsDirectory()).path;
  final String path = '$dir/invoice.pdf';
  final File file = File(path);
  await file.writeAsBytes(await pdf.save());
  material.Navigator.of(context).push(
    material.MaterialPageRoute(
      builder: (_) => PdfPreviewScreen(path: path, file: file),
    ),
  );
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}

// import 'dart:io';
// import 'package:canteen_app/Helpers/pdfView.dart';
// import 'package:canteen_app/Model/recieptorder.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;

// recieptView(context, List<Orders> orderlist) async {
//   final head = ["Month", "Total Earnings", "Profit", "Loss"];
//   final doc = pw.Document();
//   String path = "";

//   final profileImage = pw.MemoryImage(
//     (await rootBundle.load('assets/app.png')).buffer.asUint8List(),
//   );
//   doc.addPage(
//     pw.MultiPage(
//       pageFormat:
//           PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
//       crossAxisAlignment: pw.CrossAxisAlignment.start,
//       header: (context) {
//         if (context.pageNumber == 1) {
//           print("!");
//           return null;
//         }
//         return pw.Container(
//             alignment: pw.Alignment.centerRight,
//             margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
//             padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
//             decoration: pw.BoxDecoration(
//               border: pw.Border(
//                 bottom: pw.BorderSide(width: 0.5, color: PdfColors.grey),
//               ),
//             ),
//             child: pw.Text('Sales Report',
//                 style: pw.Theme.of(context)
//                     .defaultTextStyle
//                     .copyWith(color: PdfColors.grey)));
//       },
//       footer: (context) {
//         print("!");
//         return pw.Container(
//             alignment: pw.Alignment.centerRight,
//             margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
//             child: pw.Text(
//                 'Page ${context.pageNumber} of ${context.pagesCount}',
//                 style: pw.Theme.of(context)
//                     .defaultTextStyle
//                     .copyWith(color: PdfColors.grey)));
//       },
//       build: (pw.Context context) => <pw.Widget>[
// pw.Row(
//   mainAxisAlignment: pw.MainAxisAlignment.end,
//   children: [
//     pw.Text("InstaFood\nSales-Report",
//         style:
//             pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
//     pw.Container(
//       height: 100,
//       width: 400,
//       child: pw.Image.provider(profileImage),
//     ),
//   ],
// ),
//         pw.Header(
//           child: pw.Text("Report Table"),
//           level: 0,
//         ),
//         // pw.Table.fromTextArray(
//         //   headers: List<String>.generate(head.length, (index) => head[index]),
//         //   data: List<List<String>>.generate(
//         //       orderlist.length,
//         //       (row) => List<String>.generate(
//         //             head.length,
//         //             (index) => orderlist[row].getIndex(index),
//         //           )),
//         // ),
//       ],
//     ),
//   );
//   //save PDF

//   final String dir = (await getApplicationDocumentsDirectory()).path;
//   path = '$dir/salesreport.pdf';
//   final File file = File(path);
//   await file.writeAsBytes(await doc.save());
//   Navigator.of(context).push(
//     MaterialPageRoute(
//       builder: (_) => PdfPreviewScreen(path: path, file: file),
//     ),
//   );
// }
