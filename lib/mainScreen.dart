import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_pdf/viewPdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String fileName = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Get PDF'),
      ),
      // body: Center(
      //   child: RaisedButton(
      //     onPressed: () {
      //       createFile();
      //     },
      //     child: Text('Make File'),
      //   ),
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await createFile();
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ViewPdf(
                    documentPath: fileName,
                  )));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  createFile() async {
    final pdf = pw.Document();
    pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(30),
        build: (pw.Context context) {
          return <pw.Widget>[
            // pw.Container(
            //     decoration: pw.BoxDecoration(image: pw.DecorationImage())),
            pw.Header(
              child: pw.Text('Carry bhai'),
            ),
            pw.Paragraph(
              text: 'To kaise hain aap log',
            ),
            pw.Align(
                alignment: pw.Alignment.bottomRight,
                child: pw.Footer(trailing: pw.Text('GetPDF')))
          ];
        }));
    await saveFile(pdf);
  }

  Future saveFile(pw.Document pdf) async {
    Directory dir = await getApplicationDocumentsDirectory();
    String documentPath = dir.path;

    DateTime currentTime = DateTime.now();
    fileName = '$documentPath/GetPDF_$currentTime';
    File file = File(fileName);

    file.writeAsBytesSync(pdf.save());
  }
}
