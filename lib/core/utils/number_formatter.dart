import 'dart:ui';

import 'package:intl/intl.dart';

class NumberFormatter {
  NumberFormatter._();

  static String decimal(num value, {required Locale locale, required int maxFractionDigits}) {
    final format = NumberFormat.decimalPattern(locale.toLanguageTag())
      ..maximumFractionDigits = maxFractionDigits;
    return format.format(value);
  }
}
