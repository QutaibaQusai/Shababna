import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class AppDimensions {
  AppDimensions._();

  static const Size designSize = Size(390, 844);

  // Spacing — 8pt grid
  static double get spacingXs => 8.r;
  static double get spacingSm => 16.r;
  static double get spacingMd => 24.r;
  static double get spacingLg => 32.r;
  static double get spacingXl => 40.r;
  static double get spacingXxl => 48.r;

  // Screen margin
  static double get screenMargin => 16.r;

  // Border radius
  static double get radiusSm => 8.r;
  static double get radiusMd => 12.r;
  static double get radiusLg => 16.r;

  // Component heights
  static double get buttonHeight => 50.h;
  static double get inputHeight => 52.h;
  static double get appBarHeight => 56.h;
  static double get bottomNavHeight => 56.h;

  // Elevation (static — not screen-adaptive)
  static const double elevationNone = 0;
  static const double elevationSm = 2;
  static const double elevationMd = 4;
}
