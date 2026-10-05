import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/extensions/context_extensions.dart';

class HomeFormatters {
  HomeFormatters._();

  static const _afternoonHour = 12;
  static const _eveningHour = 17;

  static String greeting(BuildContext context, DateTime now) {
    final l10n = context.l10n;
    if (now.hour < _afternoonHour) return l10n.homeGreetingMorning;
    if (now.hour < _eveningHour) return l10n.homeGreetingAfternoon;
    return l10n.homeGreetingEvening;
  }

  static String hours(BuildContext context, double hours) =>
      NumberFormat.decimalPattern(context.locale.toLanguageTag()).format(hours);

  static String dateRange(BuildContext context, DateTime from, DateTime to) {
    final locale = context.locale.toLanguageTag();
    final full = DateFormat.yMMMd(locale);
    if (DateUtils.isSameDay(from, to)) return full.format(from);
    final start = from.year == to.year ? DateFormat.MMMd(locale) : full;
    return '${start.format(from)} – ${full.format(to)}';
  }

  static String date(BuildContext context, DateTime date) =>
      DateFormat.yMMMd(context.locale.toLanguageTag()).format(date);

  static String weekday(BuildContext context, DateTime date) =>
      DateFormat.E(context.locale.toLanguageTag()).format(date);

  static String dayOfMonth(BuildContext context, DateTime date) =>
      DateFormat.d(context.locale.toLanguageTag()).format(date);
}
