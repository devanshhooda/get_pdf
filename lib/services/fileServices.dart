import 'dart:io';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

class FileServices {
  String fileName = '';
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
