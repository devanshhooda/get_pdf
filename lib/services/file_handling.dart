import 'dart:io';

import 'package:file/file.dart' as FILE;
import 'package:file/local.dart';
import 'package:get_pdf/services/constants.dart';
import 'package:get_pdf/services/permissions.dart';

class FileHandling {
  final FILE.FileSystem fs = const LocalFileSystem();
  FILE.Directory home;

  FileHandling();

  Future<bool> initSystem() async {
    bool perm = await Permissions.storagePermission();
    if (perm && home == null) {
      FILE.Directory root = fs.directory(Constants.root);
      home = await root.childDirectory(Constants.home).create();
    }
    return perm;
  }

  File getFile({String name}) {
    if (home == null) return null;
    var d = DateTime.now();
    if (name == null) name = Constants.base + d.millisecondsSinceEpoch.toString() + '.pdf';
    return home.childFile(name);
  }

  List<File> allFiles() {
    if (home == null) return null;
    List<FileSystemEntity> list = home.listSync();
    List<File> files = List<File> ();
    for (int i = 0; i < list.length; i++) {
      if (fs.isDirectorySync(list[i].path)) {
        files.add(File(list[i].path));
      }
    }
    return files;
  }
}