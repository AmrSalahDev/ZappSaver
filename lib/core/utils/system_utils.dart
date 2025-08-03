import 'package:flutter/services.dart';

class SystemUtils {
  static void makePortraitOnly() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  static void setSystemBarsStyle({
    required Color statusBarColor,
    required Brightness statusBarBrightness,
    required Color navigationBarColor,
    required Brightness navigationBarBrightness,
  }) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: statusBarColor,
        statusBarIconBrightness: statusBarBrightness,
        systemNavigationBarColor: navigationBarColor,
        systemNavigationBarIconBrightness: navigationBarBrightness,
      ),
    );
  }
}
