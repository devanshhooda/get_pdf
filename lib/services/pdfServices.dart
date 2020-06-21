import 'dart:io';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:get_pdf/services/file_handling.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfServices {

  var pdf = pw.Document();

  // createFile() async {
  //   final pdf = pw.Document();
  //   pdf.addPage(pw.MultiPage(
  //       pageFormat: PdfPageFormat.a4,
  //       margin: pw.EdgeInsets.all(30),
  //       build: (pw.Context context) {
  //         return <pw.Widget>[
  //           // pw.Container(
  //           //     decoration: pw.BoxDecoration(image: pw.DecorationImage())),
  //           pw.Header(
  //             child: pw.Text('Carry bhai'),
  //           ),
  //           pw.Paragraph(
  //             text: 'To kaise hain aap log',
  //           ),
  //           pw.Align(
  //               alignment: pw.Alignment.bottomRight,
  //               child: pw.Footer(trailing: pw.Text('GetPDF')))
  //         ];
  //       }));
  //   await saveFile(pdf);
  // }

  Future<String> createPdfFromImages(List<Asset> images) async {
    pdf = pw.Document();
    try {
      for (int i = 0; i < images.length; i++) {
        ByteData data = await images[i].getByteData();
        Codec codec = await instantiateImageCodec(data.buffer.asUint8List());
        var frame = await codec.getNextFrame();

        var imageBytes = await frame.image.toByteData();

        PdfImage image = new PdfImage(pdf.document,
            image: imageBytes.buffer.asUint8List(),
            width: images[i].originalWidth,
            height: images[i].originalHeight);

        pdf.addPage(pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context) {
              return pw.Container(child: pw.Image(image));
            }));
      }

      return await savePdfFile();
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<String> savePdfFile() async {
    FileHandling handler = FileHandling();
    await handler.initSystem();

    // List<FileSystemEntity> files = handler.allFiles();
    // files.forEach((element) {print(element);});

    File file = handler.getFile();
    if (file == null) return null; // Error
    await file.writeAsBytes(pdf.save());
    print('Saved File: ${file.path}');
    return file.path;
  }
}
