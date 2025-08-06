import 'package:flutter/services.dart';

class AppUtils {
  static const _apkChannel = MethodChannel('apk_share_channel');

  static String countryCodeToEmoji(String countryCode) {
    return countryCode
        .toUpperCase()
        .runes
        .map((char) => String.fromCharCode(char + 127397))
        .join();
  }

  static Future<void> shareApk() async {
    try {
      await _apkChannel.invokeMethod('shareApk');
    } catch (e) {
      print("Error sharing APK: $e");
    }
  }
}
