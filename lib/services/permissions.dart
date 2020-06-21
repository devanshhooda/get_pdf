import 'package:permission_handler/permission_handler.dart';

class Permissions {
  static Future<bool> storagePermission() async {
    if (await Permission.storage.request().isGranted) {
      return true;
    } else {
      return false;
    }
  }
}