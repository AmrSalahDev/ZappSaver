import 'package:flutter/material.dart';

extension MediaQueryValues on BuildContext {
  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
  double get topPadding => MediaQuery.of(this).padding.top;
  double get bottomPadding => MediaQuery.of(this).padding.bottom;
  bool get isLandscape =>
      MediaQuery.of(this).orientation == Orientation.landscape;
  TextScaler get textScaler => MediaQuery.textScalerOf(this);
}

extension LocalizationValues on BuildContext {
  Locale get locale => Localizations.localeOf(this);
  bool get isArabic => locale.languageCode == 'ar';
}

extension ThemeValues on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
}
