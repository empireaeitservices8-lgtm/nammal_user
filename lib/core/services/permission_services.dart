import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  /// Request audio call permissions (Microphone & Bluetooth)
  static Future<bool> requestAudioCallPermissions() async {
    final micStatus = await Permission.microphone.request();

    // Android 12+ bluetooth permission for wireless headsets
    if (await Permission.bluetoothConnect.isRestricted == false) {
      await Permission.bluetoothConnect.request();
    }

    if (micStatus.isGranted) {
      return true;
    } else if (micStatus.isPermanentlyDenied) {
      // Direct user to Android App Settings
      await openAppSettings();
      return false;
    }
    return false;
  }

  /// Request video call permissions (Microphone & Camera)
  static Future<bool> requestVideoCallPermissions() async {
    final Map<Permission, PermissionStatus> statuses = await [
      Permission.microphone,
      Permission.camera,
    ].request();

    final isMicGranted = statuses[Permission.microphone]?.isGranted ?? false;
    final isCameraGranted = statuses[Permission.camera]?.isGranted ?? false;

    if (isMicGranted && isCameraGranted) {
      return true;
    }

    if (statuses[Permission.microphone]?.isPermanentlyDenied == true ||
        statuses[Permission.camera]?.isPermanentlyDenied == true) {
      await openAppSettings();
      return false;
    }

    return false;
  }

  /// Request push notifications (Android 13+)
  static Future<bool> requestNotificationPermission() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }
}
