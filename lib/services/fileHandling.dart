import 'dart:io';

import 'package:file/file.dart' as FILE;
import 'package:file/local.dart';
import 'package:get_pdf/utils/constants.dart';
import 'package:get_pdf/utils/permissions.dart';

class FileHandling {
  final FILE.FileSystem fs = const LocalFileSystem();
  FILE.Directory homeDirectory;
  FILE.Directory tempDirectory;

  FileHandling();

  Future<bool> initSystem() async {
    bool storagePermission = await Permissions.storagePermission();
    if (storagePermission && homeDirectory == null) {
      FILE.Directory root = fs.directory(Constants.root);
      homeDirectory = await root.childDirectory(Constants.home).create();
      tempDirectory = await homeDirectory.childDirectory(Constants.temp).create();
    }
    return storagePermission;
  }

  File getFile({String name}) {
    if (homeDirectory == null) return null;
    var postfixString = DateTime.now().millisecondsSinceEpoch.toString();
    if (name == null) name = Constants.base + postfixString + '.pdf';
    return homeDirectory.childFile(name);
  }

  File getTempFile({String name}) {
    if (tempDirectory == null) return null;
    var postfixString = DateTime.now().millisecondsSinceEpoch.toString();
    if (name == null) name = Constants.base + postfixString + '.pdf';
    return tempDirectory.childFile(name);
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
}
