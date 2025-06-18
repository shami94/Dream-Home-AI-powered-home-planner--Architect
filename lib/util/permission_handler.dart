import 'package:logger/web.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestStoragePermission() async {
  var status = await Permission.storage.status;

  if (status.isGranted) {
    Logger().w("Storage Permission Already Granted");
  } else if (status.isDenied) {
    // Request permission again
    if (await Permission.storage.request().isGranted) {
      Logger().w("Storage Permission Granted");
    } else {
      Logger().w("Storage Permission Denied");
    }
  } else if (status.isPermanentlyDenied) {
    // Open app settings if permission is permanently denied
    Logger().w("Storage Permission Permanently Denied. Open App Settings.");
    openAppSettings();
  }
}
