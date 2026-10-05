import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/extensions/context_extensions.dart';

class HomeFormatters {
  HomeFormatters._();

  static const _afternoonHour = 12;
  static const _eveningHour = 17;
  static const _hoursPerDay = 24;
  static const _relativeDaysLimit = 7;

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

  static String relativeDue(BuildContext context, DateTime? dueAt) {
    final l10n = context.l10n;
    if (dueAt == null) return l10n.taskNoDueDate;

    final now = DateTime.now();
    final days = _calendarDaysBetween(now, dueAt);
    if (dueAt.isBefore(now)) {
      return days < 0 ? l10n.taskOverdueByDays(-days) : l10n.taskOverdue;
    }
    return switch (days) {
      0 => l10n.taskDueToday,
      1 => l10n.taskDueTomorrow,
      < _relativeDaysLimit => l10n.taskDueInDays(days),
      _ => l10n.taskDueOn(DateFormat.MMMd(context.locale.toLanguageTag()).format(dueAt)),
    };
  }

  static int _calendarDaysBetween(DateTime from, DateTime to) {
    final start = DateTime(from.year, from.month, from.day);
    final end = DateTime(to.year, to.month, to.day);
    return (end.difference(start).inHours / _hoursPerDay).round();
  }

  static String date(BuildContext context, DateTime date) =>
      DateFormat.yMMMd(context.locale.toLanguageTag()).format(date);

  static String weekday(BuildContext context, DateTime date) =>
      DateFormat.E(context.locale.toLanguageTag()).format(date);

  static String dayOfMonth(BuildContext context, DateTime date) =>
      DateFormat.d(context.locale.toLanguageTag()).format(date);
}
