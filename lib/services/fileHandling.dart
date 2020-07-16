import 'dart:io';
import 'package:file/file.dart' as FILE;
import 'package:file/local.dart';
import 'package:get_pdf/utils/constants.dart';
import 'package:get_pdf/utils/permissions.dart';

class FileHandling {
  final FILE.FileSystem fs = const LocalFileSystem();
  FILE.Directory homeDirectory;
  FILE.Directory tempDirectory;
  FILE.Directory thmbDirectory;

  FileHandling();

  Future<bool> initSystem() async {
    bool storagePermission = await Permissions.storagePermission();
    if (storagePermission && homeDirectory == null) {
      FILE.Directory root = fs.directory(Constants.root);
      homeDirectory = await root.childDirectory(Constants.home).create();
      tempDirectory =
          await homeDirectory.childDirectory(Constants.temp).create();
      thmbDirectory =
          await homeDirectory.childDirectory(Constants.thumb).create();
    }
    return storagePermission;
  }

  File getFile({String name}) {
    if (homeDirectory == null) return null;
    String postfixString = '';
    // postfixString = DateTime.now().millisecondsSinceEpoch.toString();
    // yyyymmdd hhmmss
    var time = DateTime.now();
    postfixString +=
        int2str(time.year) + int2str(time.month) + int2str(time.day);
    postfixString += ' ';
    postfixString +=
        int2str(time.hour) + int2str(time.minute) + int2str(time.second);
    if (name == null) name = Constants.base + postfixString + '.pdf';
    return homeDirectory.childFile(name);
  }

  String int2str(int n) {
    if (n < 10) return '0' + n.toString();
    return n.toString();
  }

  File getTempFile({String name}) {
    if (tempDirectory == null) return null;
    var postfixString = DateTime.now().millisecondsSinceEpoch.toString();
    if (name == null) name = Constants.base + postfixString + '.pdf';
    return tempDirectory.childFile(name);
  }

  File getThumbFile(String name) {
    if (thmbDirectory == null) return null;
    List<String> parts = name.split('/').removeLast().split('.');
    String thumbName = '';
    for (int i = 0; i < parts.length - 1; i++) {
      thumbName += parts[i];
    }
    thumbName += '.jpg';
    return thmbDirectory.childFile(thumbName);
  }

  File thumbPath(String name) {
    List<String> parts = name.split('/').removeLast().split('.');
    String thumbName = '';
    for (int i = 0; i < parts.length - 1; i++) {
      thumbName += parts[i];
    }
    thumbName += '.jpg';
    return File(thmbDirectory.path + '/' + thumbName);
  }

  Future<void> deleteTemp() async {
    tempDirectory.deleteSync(recursive: true);
    tempDirectory = await homeDirectory.childDirectory(Constants.temp).create();
  }

  List<FileSystemEntity> allFiles() {
    if (homeDirectory == null) return null;
    List<FileSystemEntity> list = homeDirectory.listSync();
    List<FileSystemEntity> files = List<FileSystemEntity>();
    for (int i = 0; i < list.length; i++) {
      if (!fs.isDirectorySync(list[i].path)) {
        files.add(list[i]);
      }
    }
    list.clear();
    return files;
  }

  void deleteFile(FileSystemEntity file) {
    file.deleteSync(recursive: true);
  }
}
