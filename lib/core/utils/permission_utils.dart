import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
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

  static Future<void> requestStoragePermissions({
    required VoidCallback onGranted,
    required VoidCallback onDenied,
    required VoidCallback onPermanentlyDenied,
  }) async {
    await Permission.storage
        .onGrantedCallback(onGranted)
        .onPermanentlyDeniedCallback(onPermanentlyDenied)
        .onDeniedCallback(onDenied)
        .request();

    if (Platform.isAndroid && await _isAndroid11OrAbove()) {
      await Permission.manageExternalStorage
          .onGrantedCallback(onGranted)
          .onPermanentlyDeniedCallback(onPermanentlyDenied)
          .onDeniedCallback(onDenied)
          .request();
    }
  }

  static Future<bool> _isAndroid11OrAbove() async {
    if (!Platform.isAndroid) return false;

    final androidInfo = await DeviceInfoPlugin().androidInfo;
    return androidInfo.version.sdkInt >= 30; // Android 11 = SDK 30
  }
}
