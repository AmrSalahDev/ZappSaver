import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {
  static const MethodChannel _channel = MethodChannel(
    'notification_listener_permission',
  );

  static Future<bool> requestStoragePermission() async {
    if (await Permission.storage.request().isGranted) {
      return true;
    }

    if (await Permission.manageExternalStorage.request().isGranted) {
      return true;
    }

    return false;
  }

  static void requestNotificationPermission() {
    const AndroidIntent intent = AndroidIntent(
      action: 'android.settings.ACTION_NOTIFICATION_LISTENER_SETTINGS',
      flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
    );
    intent.launch();
  }

  static Future<void> notificationPermissionStatus({
    required VoidCallback onEnabled,
    required VoidCallback onDisabled,
  }) async {
    try {
      final bool result = await _channel.invokeMethod(
        'isNotificationPermissionGranted',
      );
      if (result) {
        onEnabled();
      } else {
        onDisabled();
      }
    } catch (e) {
      print("Error checking permission: $e");
      onDisabled();
    }
  }
}
