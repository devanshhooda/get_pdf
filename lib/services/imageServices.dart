import 'dart:io';
import 'package:file_picker/file_picker.dart';

class ImageServices {
  List<File> imageList = List<File>();
  Future<List<File>> pickImages() async {
    List<File> imageList = List<File>();
    try {
      imageList = await FilePicker.getMultiFile(
        type: FileType.image,
      );
      return imageList;
    } catch (e) {
      print(e);
    }
  }
}
