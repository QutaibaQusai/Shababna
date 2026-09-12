import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  AppTextStyles._();

  static final String fontFamilyLatin = GoogleFonts.inter().fontFamily!;
  static final String fontFamilyArabic = GoogleFonts.almarai().fontFamily!;

  static TextStyle _style({
    required double fontSize,
    required FontWeight fontWeight,
    Color? color,
  }) => TextStyle(fontSize: fontSize.sp, fontWeight: fontWeight, color: color);

  static TextStyle largeTitle({Color? color}) =>
      _style(fontSize: 34, fontWeight: FontWeight.w400, color: color);

  static TextStyle title1({Color? color}) =>
      _style(fontSize: 28, fontWeight: FontWeight.w400, color: color);

  static TextStyle title2({Color? color}) =>
      _style(fontSize: 22, fontWeight: FontWeight.w400, color: color);

  static TextStyle title3({Color? color}) =>
      _style(fontSize: 20, fontWeight: FontWeight.w400, color: color);

  static TextStyle headline({Color? color}) =>
      _style(fontSize: 17, fontWeight: FontWeight.w600, color: color);

  static TextStyle body({Color? color}) =>
      _style(fontSize: 17, fontWeight: FontWeight.w400, color: color);

  static TextStyle callout({Color? color}) =>
      _style(fontSize: 16, fontWeight: FontWeight.w400, color: color);

  static TextStyle subheadline({Color? color}) =>
      _style(fontSize: 15, fontWeight: FontWeight.w400, color: color);

  static TextStyle footnote({Color? color}) =>
      _style(fontSize: 13, fontWeight: FontWeight.w400, color: color);

  static TextStyle caption1({Color? color}) =>
      _style(fontSize: 12, fontWeight: FontWeight.w400, color: color);

  static TextStyle caption2({Color? color}) =>
      _style(fontSize: 11, fontWeight: FontWeight.w400, color: color);
}
