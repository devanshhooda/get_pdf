import 'dart:io';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:open_file/open_file.dart';
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

  createFromImages(List<Asset> images) async {
    final pdf = pw.Document();

    for (int i=0; i<images.length; i++) {
      ByteData data = await images[i].getByteData();
      Codec codec = await instantiateImageCodec(data.buffer.asUint8List());
      var frame = await codec.getNextFrame();

      var imageBytes = await frame.image.toByteData();

      PdfImage image = new PdfImage(
          pdf.document,
          image: imageBytes.buffer.asUint8List(),
          width: images[i].originalWidth,
          height: images[i].originalHeight
      );

      pdf.addPage(pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Container(
                child: pw.Image(image)
            );
          }
      ));
    }

    await saveFile(pdf);
  }

  Future saveFile(pw.Document pdf) async {
    Directory dir = await getExternalStorageDirectory();
    String documentPath = dir.path;

    DateTime currentTime = DateTime.now();
    fileName = '$documentPath/GetPDF_${currentTime.toString()}.pdf';
    File file = File(fileName);

    await file.writeAsBytes(pdf.save());

    OpenFile.open(file.path);
  }
}
