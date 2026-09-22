import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  AppTypography._();

  static final String fontFamilyLatin = GoogleFonts.inter().fontFamily!;
  static final String fontFamilyArabic = GoogleFonts.almarai().fontFamily!;

  static TextStyle _style({
    required double fontSize,
    required FontWeight fontWeight,
    required String fontFamily,
    Color? color,
  }) => TextStyle(
    fontSize: fontSize,
    fontWeight: fontWeight,
    fontFamily: fontFamily,
    color: color,
  );

  static TextStyle largeTitle({required String fontFamily, Color? color}) =>
      _style(fontSize: 32, fontWeight: FontWeight.w400, fontFamily: fontFamily, color: color);

  static TextStyle title1({required String fontFamily, Color? color}) =>
      _style(fontSize: 26, fontWeight: FontWeight.w400, fontFamily: fontFamily, color: color);

  static TextStyle title2({required String fontFamily, Color? color}) =>
      _style(fontSize: 21, fontWeight: FontWeight.w400, fontFamily: fontFamily, color: color);

  static TextStyle title3({required String fontFamily, Color? color}) =>
      _style(fontSize: 19, fontWeight: FontWeight.w400, fontFamily: fontFamily, color: color);

  static TextStyle headline({required String fontFamily, Color? color}) =>
      _style(fontSize: 16, fontWeight: FontWeight.w600, fontFamily: fontFamily, color: color);

  static TextStyle buttonLabel({required String fontFamily, Color? color}) =>
      _style(fontSize: 14, fontWeight: FontWeight.w600, fontFamily: fontFamily, color: color);

  static TextStyle body({required String fontFamily, Color? color}) =>
      _style(fontSize: 16, fontWeight: FontWeight.w400, fontFamily: fontFamily, color: color);

  static TextStyle callout({required String fontFamily, Color? color}) =>
      _style(fontSize: 14, fontWeight: FontWeight.w400, fontFamily: fontFamily, color: color);

  static TextStyle subheadline({required String fontFamily, Color? color}) =>
      _style(fontSize: 13, fontWeight: FontWeight.w400, fontFamily: fontFamily, color: color);

  static TextStyle footnote({required String fontFamily, Color? color}) =>
      _style(fontSize: 12, fontWeight: FontWeight.w400, fontFamily: fontFamily, color: color);

  static TextStyle caption1({required String fontFamily, Color? color}) =>
      _style(fontSize: 11, fontWeight: FontWeight.w400, fontFamily: fontFamily, color: color);

  static TextStyle caption2({required String fontFamily, Color? color}) =>
      _style(fontSize: 10, fontWeight: FontWeight.w400, fontFamily: fontFamily, color: color);
}
