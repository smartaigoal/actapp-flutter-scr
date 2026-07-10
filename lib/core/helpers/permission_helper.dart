import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  static Future<bool> requestLocationPermission() async {
    final status = await Permission.location.request();
    return status.isGranted;
  }

  static Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  static Future<bool> requestGalleryPermission() async {
    final status = await Permission.photos.request();
    return status.isGranted;
  }

  static Future<PermissionStatus> checkLocationPermission() async {
    return await Permission.location.status;
  }
}
