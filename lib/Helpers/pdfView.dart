import 'dart:io';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:share/share.dart';
import 'package:flutter/material.dart';


class PdfPreviewScreen extends StatefulWidget {
  final String path;
  final File file;

  PdfPreviewScreen({this.path,this.file});

  @override
  _PdfPreviewScreenState createState() => _PdfPreviewScreenState();
}

class _PdfPreviewScreenState extends State<PdfPreviewScreen> {

  bool _isLoading = true;
  PDFDocument document;

  @override
  void initState() {
    super.initState();
    loadDocument();
  }

  loadDocument() async {
    document = await PDFDocument.fromFile(widget.file);

    setState(() => _isLoading = false);
  }


  Future<void> share() async {
    Share.shareFiles([widget.path], text: 'Your PDF!');
  }

  @override
  Widget build(BuildContext context) {
    var getScreenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Sales Report"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              share();
            },
          ),
        ],

      ),
      body: Center(
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : PDFViewer(
          document: document,
          zoomSteps: 1,
          //uncomment below line to preload all pages
          lazyLoad: false,
          // uncomment below line to scroll vertically
          scrollDirection: Axis.vertical,


        ),
      ),
    );
  }
}