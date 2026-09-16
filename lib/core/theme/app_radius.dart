import 'package:flutter/painting.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';


class AppRadius {
  AppRadius._();

  static double get sm => 8.r;
  static double get md => 10.r;
  static double get lg => 12.r;
  static double get pill => 999;

  static BorderRadius get smRadius => BorderRadius.circular(sm);
  static BorderRadius get mdRadius => BorderRadius.circular(md);
  static BorderRadius get lgRadius => BorderRadius.circular(lg);
  static BorderRadius get pillRadius => BorderRadius.circular(pill);
}
