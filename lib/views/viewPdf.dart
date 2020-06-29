import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_extend/share_extend.dart';

class ViewPdf extends StatefulWidget {
  final String documentPath;
  ViewPdf({this.documentPath});
  @override
  _ViewPdfState createState() => _ViewPdfState();
}

class _ViewPdfState extends State<ViewPdf> {
  int pages = 0;
  int currentPage = 0;
  bool isReady = false;

  @override
  Widget build(BuildContext context) {
    String path = widget.documentPath;
    String fileName = path.split('/').removeLast();
    final Completer<PDFViewController> _controller =
        Completer<PDFViewController>();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.deepOrangeAccent,
        title: Text(
          '$fileName',
          style: GoogleFonts.cantoraOne(),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                ShareExtend.share(widget.documentPath, "pdf");
              })
        ],
      ),
      body: PDFView(
        filePath: path,
        enableSwipe: true,
        // swipeHorizontal: true,
        autoSpacing: true,
        pageFling: false,
        fitEachPage: false,
        fitPolicy: FitPolicy.BOTH,
        // nightMode: true,

        onRender: (_pages) {
          // setState(() {
          //   pages = _pages;
          //   isReady = true;
          // });
        },
        onError: (error) {
          print(error.toString());
        },
        onPageError: (page, error) {
          print('$page: ${error.toString()}');
        },
        onViewCreated: (PDFViewController pdfViewController) {
          // _controller.complete(pdfViewController);
        },
        onPageChanged: (int page, int total) {
          print('page change: $page/$total');
        },
      ),
    );
  }
}
