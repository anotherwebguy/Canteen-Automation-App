import 'dart:io';
import 'package:canteen_app/Helpers/pdfView.dart';
import 'package:canteen_app/Model/recieptorder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

recieptView(context, List<Orders> orderlist) async {
  final head = ["Month","Total Earnings","Profit","Loss"];
  final doc = pw.Document();
  String path="";

  final profileImage = pw.MemoryImage((await rootBundle.load('assets/app.png'))
    .buffer.asUint8List(),);
    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(32),
        header: (context) {
        if (context.pageNumber == 1) {
          return null;
        }
        return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
            decoration:  pw.BoxDecoration(
              border:pw.Border(
                bottom: pw.BorderSide(width: 0.5, color: PdfColors.grey),
              ),),
            child: pw.Text('Sales Report',
                style: pw.Theme.of(context)
                    .defaultTextStyle
                    .copyWith(color: PdfColors.grey))
        );
      },
      footer: ( context) {
        return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
            child: pw.Text('Page ${context.pageNumber} of ${context.pagesCount}',
                style: pw.Theme.of(context)
                    .defaultTextStyle
                    .copyWith(color: PdfColors.grey)));
      },
        build: (pw.Context context)=><pw.Widget>[
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.Text("InstaFood\nSales-Report",style: pw.TextStyle(fontSize: 30,fontWeight: pw.FontWeight.bold)),
              pw.Container(
                height: 100,
                width: 400,
                child: pw.Image.provider(profileImage),
              ),
            ],
          ),
          pw.Header(
            child: pw.Text("Report Table"),
            level: 0,  
          ),
          pw.Table.fromTextArray(
            headers: List<String>.generate(
              head.length, 
              (index) => head[index]),
            data: List<List<String>>.generate(
              orderlist.length, 
              (row) => List<String>.generate(
                head.length, 
                (index) => orderlist[row].getIndex(index),
                )),
            ),
        ],
      ),
    );
  //save PDF

  Directory dir = await getApplicationDocumentsDirectory();
    path = dir.path;
    File file = File("$path/example.pdf");
    await file.writeAsBytesSync(doc.save());
    Navigator.of(context).push(
     MaterialPageRoute(
      builder: (_) => PdfPreviewScreen(path: path,file: file),
    ),
  );
}