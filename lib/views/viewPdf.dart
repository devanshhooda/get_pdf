import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';

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
    print(path);
    return PDFViewerScaffold(
      path: path,
      appBar: AppBar(
        title: Text('${path.substring(45)}'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save_alt), onPressed: () {}),
          IconButton(icon: Icon(Icons.share), onPressed: () {})
        ],
      ),
    );
  }
}
