import 'dart:io';
import 'package:get_pdf/services/fileHandling.dart';
import 'package:get_pdf/utils/constants.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PdfServices {
  var pdf = pw.Document();
  SharedPreferences pref;
  bool fitImages = true;

  PdfServices() {
    _initSP();
  }

  Future<String> createPdfFromImages(List<File> images) async {
    pdf = pw.Document();
    _checkFitProperty();
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
                child: pw.Image(pdfImage,
                    fit: fitImages ? pw.BoxFit.fill : pw.BoxFit.contain),
              );
            }));
      }

      return await savePdfFile(images[0]);
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<String> savePdfFile(File image) async {
    FileHandling handler = FileHandling();
    await handler.initSystem();
    File file = handler.getFile();
    if (file == null) return null; // Error
    await file.writeAsBytes(pdf.save());
    File thmb = handler.getThumbFile(file.path);
    thmb.writeAsBytesSync(image.readAsBytesSync()); // TODO: resize image
    print('Saved File: ${file.path}');
    return file.path;
  }

  Future<void> createThumbnails(File pdfFile) async {
    try {
      FileHandling handler = FileHandling();
      await handler.initSystem();
      File file = handler.getThumbFile(pdfFile.path);
      var pdf = pdfFile.readAsBytesSync();
      print(file);
      // var page =
      //     await Printing.raster(pdfFile.readAsBytesSync(), pages: [0], dpi: 30)
      //         .first;
      List<int> hhh = [0, 1];
      var pages = Printing.raster(pdf, pages: hhh, dpi: 72).first;
      // await for (var page in pages) {
      //   print('hello');
      // }
      //print(page.pixels);
      //var image = await page.toImage();
      //var data = await image.toByteData();
      //await file.writeAsBytes(page.pixels);
    } catch (err) {
      print('HERE');
      print(err);
    }
  }

  _checkFitProperty() {
    fitImages = pref.getBool(Constants.fitImages) ?? true;
  }

  _initSP() async {
    pref = await SharedPreferences.getInstance();
  }
}
