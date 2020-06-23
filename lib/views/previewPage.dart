import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/pdfServices.dart';
import 'viewPdf.dart';

class PreviewPage extends StatefulWidget {
  final List<File> imageList;
  PreviewPage({this.imageList});
  @override
  _PreviewPageState createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  PdfServices pdfServices;

  @override
  void initState() {
    pdfServices = PdfServices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        title: Text(
          'Preview',
          style: GoogleFonts.cantoraOne(),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                Navigator.of(context).pop();
              })
        ],
      ),
      body: Container(
        child: GridView.builder(
            itemCount: widget.imageList.length,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (context, i) {
              return GestureDetector(
                onTap: () {
                  print('Editing image process to be done');
                },
                child: Container(
                  margin: EdgeInsets.all(5),
                  color: Colors.white,
                  child: Image.file(
                    widget.imageList[i],
                    fit: BoxFit.contain,
                  ),
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        onPressed: () async {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              });
          String filename =
              await pdfServices.createPdfFromImages(widget.imageList);
          Navigator.of(context).pop();
          if (filename == null) return;
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ViewPdf(
                documentPath: filename,
              )
            )
          ).then((value) => Navigator.of(context).pop());
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
