import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_extend/share_extend.dart';

class ViewPdf extends StatefulWidget {
  final String documentPath;
  ViewPdf({this.documentPath});
  @override
  _ViewPdfState createState() => _ViewPdfState();
}

class _ViewPdfState extends State<ViewPdf> {
  @override
  Widget build(BuildContext context) {
    String path = widget.documentPath;
    String fileName = path.split('/').removeLast();
    return PDFViewerScaffold(
      path: path,
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
    );
  }
}
