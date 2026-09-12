import 'package:flutter/painting.dart';

class AppBorders {
  AppBorders._();

  static const double hairline = 1;
  static const double thick = 1.5;

  static BorderSide side(Color color, {double width = hairline}) =>
      BorderSide(color: color, width: width);
}
