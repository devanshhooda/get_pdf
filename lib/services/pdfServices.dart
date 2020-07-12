import 'dart:io';
import 'package:get_pdf/services/fileHandling.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfServices {
  var pdf = pw.Document();

  Future<String> createPdfFromImages(List<File> images) async {
    pdf = pw.Document();

    try {
      for (int i = 0; i < images.length; i++) {
        var image = images[i];
        PdfImage pdfImage =
            new PdfImage.file(pdf.document, bytes: image.readAsBytesSync());

        pdf.addPage(pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context) {
              return pw.Container(
                height: double.infinity,
                width: double.infinity,
                child: pw.Image(pdfImage, fit: pw.BoxFit.fill),
              );
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
    File file = handler.getFile();
    if (file == null) return null; // Error
    await file.writeAsBytes(pdf.save());
    print('Saved File: ${file.path}');
    return file.path;
  }
}
