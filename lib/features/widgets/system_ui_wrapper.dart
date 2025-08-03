import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SystemUiWrapper extends StatelessWidget {
  final Widget child;
  final Color statusBarColor;
  final Brightness statusBarIconBrightness;
  final Color navigationBarColor;
  final Brightness navigationBarIconBrightness;

  const SystemUiWrapper({
    super.key,
    required this.child,
    required this.statusBarColor,
    required this.statusBarIconBrightness,
    required this.navigationBarColor,
    required this.navigationBarIconBrightness,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: statusBarColor,
        statusBarIconBrightness: statusBarIconBrightness,
        systemNavigationBarColor: navigationBarColor,
        systemNavigationBarIconBrightness: navigationBarIconBrightness,
      ),
      child: child,
    );
  }
}
