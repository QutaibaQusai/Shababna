import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/utils/number_formatter.dart';

class CertificateFormatters {
  CertificateFormatters._();

  static const _maxHourDigits = 1;

  static String date(BuildContext context, DateTime date) =>
      DateFormat.yMMMd(context.locale.toLanguageTag()).format(date);

  static String hours(BuildContext context, double hours) => context.l10n.volunteerHoursCount(
    hours,
    NumberFormatter.decimal(hours, locale: context.locale, maxFractionDigits: _maxHourDigits),
  );

  static String period(BuildContext context, DateTime start, DateTime end) {
    final from = date(context, start);
    final to = date(context, end);
    return from == to ? from : '$from – $to';
  }
}
