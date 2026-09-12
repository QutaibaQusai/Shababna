import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class AppDimensions {
  AppDimensions._();

  static const Size designSize = Size(390, 844);

  static double get spacingXs => 8.r;
  static double get spacingSm => 16.r;
  static double get spacingMd => 24.r;
  static double get spacingLg => 32.r;
  static double get spacingXl => 40.r;
  static double get spacingXxl => 48.r;

  static double get screenMargin => 16.r;

  static double get radiusSm => 8.r;
  static double get radiusMd => 12.r;
  static double get radiusLg => 16.r;

  static double get buttonHeight => 50.h;
  static double get inputHeight => 52.h;
  static double get appBarHeight => 56.h;
  static double get bottomNavHeight => 56.h;

  static double get iconSm => 16.r;
  static double get iconField => 20.r;
  static double get iconMd => 24.r;
  static double get iconLg => 32.r;

  static const double elevationNone = 0;
  static const double elevationSm = 2;
  static const double elevationMd = 4;
}
