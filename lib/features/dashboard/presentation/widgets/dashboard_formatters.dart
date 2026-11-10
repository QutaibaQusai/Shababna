import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/context_extensions.dart';

abstract final class DashboardFormatters {
  static const hoursDecimals = 2;

  static String number(BuildContext context, num value, {int decimals = 0}) {
    final format = NumberFormat.decimalPattern(context.locale.toLanguageTag())
      ..maximumFractionDigits = decimals;
    return format.format(value);
  }

  static String hours(BuildContext context, double value) =>
      number(context, value, decimals: hoursDecimals);
}
