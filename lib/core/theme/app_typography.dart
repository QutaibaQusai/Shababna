import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Font sizes are fixed logical pixels, not scaled by [flutter_screenutil_plus]
/// (`.sp`): text legibility should stay constant across screen widths and
/// only respond to the user's own system font-size setting, which Flutter's
/// text widgets already apply - scaling by device width on top of that made
/// every size increasingly oversized on screens wider than the design size.
class AppTypography {
  AppTypography._();

  static final String fontFamilyLatin = GoogleFonts.poppins().fontFamily!;
  static final String fontFamilyArabic =
      GoogleFonts.ibmPlexSansArabic().fontFamily!;

  static TextStyle _style({
    required double fontSize,
    required FontWeight fontWeight,
    Color? color,
  }) => TextStyle(fontSize: fontSize, fontWeight: fontWeight, color: color);

  static TextStyle largeTitle({Color? color}) =>
      _style(fontSize: 32, fontWeight: FontWeight.w400, color: color);

  static TextStyle title1({Color? color}) =>
      _style(fontSize: 26, fontWeight: FontWeight.w400, color: color);

  static TextStyle title2({Color? color}) =>
      _style(fontSize: 21, fontWeight: FontWeight.w400, color: color);

  static TextStyle title3({Color? color}) =>
      _style(fontSize: 19, fontWeight: FontWeight.w400, color: color);

  static TextStyle headline({Color? color}) =>
      _style(fontSize: 16, fontWeight: FontWeight.w600, color: color);

  /// Button and other action-label text. Sized to Material 3's labelLarge
  /// (14sp) rather than [headline] - buttons were previously forced onto
  /// the same 17sp style used for page headings, which read as oversized.
  static TextStyle buttonLabel({Color? color}) =>
      _style(fontSize: 14, fontWeight: FontWeight.w600, color: color);

  static TextStyle body({Color? color}) =>
      _style(fontSize: 16, fontWeight: FontWeight.w400, color: color);

  static TextStyle callout({Color? color}) =>
      _style(fontSize: 14, fontWeight: FontWeight.w400, color: color);

  static TextStyle subheadline({Color? color}) =>
      _style(fontSize: 13, fontWeight: FontWeight.w400, color: color);

  static TextStyle footnote({Color? color}) =>
      _style(fontSize: 12, fontWeight: FontWeight.w400, color: color);

  static TextStyle caption1({Color? color}) =>
      _style(fontSize: 11, fontWeight: FontWeight.w400, color: color);

  static TextStyle caption2({Color? color}) =>
      _style(fontSize: 10, fontWeight: FontWeight.w400, color: color);
}
