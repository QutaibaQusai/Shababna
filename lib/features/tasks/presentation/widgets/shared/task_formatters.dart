import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../../../../core/extensions/context_extensions.dart';

class TaskFormatters {
  TaskFormatters._();

  static const _bytesPerKilobyte = 1024;
  static const _hoursPerDay = 24;
  static const _relativeDaysLimit = 7;

  static String dueDate(BuildContext context, DateTime? date) {
    if (date == null) return context.l10n.taskNoDueDate;
    return DateFormat.yMMMd(context.locale.toLanguageTag()).add_jm().format(date);
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

  static String date(BuildContext context, DateTime date) =>
      DateFormat.yMMMd(context.locale.toLanguageTag()).add_jm().format(date);

  static String shortDate(BuildContext context, DateTime date) =>
      DateFormat.MMMd(context.locale.toLanguageTag()).format(date);

  static String hours(BuildContext context, double hours) {
    final formatted = NumberFormat.decimalPattern(context.locale.toLanguageTag()).format(hours);
    return context.l10n.taskHoursValue(formatted);
  }

  static String fileSize(int bytes) {
    if (bytes < _bytesPerKilobyte) return '$bytes B';
    final kilobytes = bytes / _bytesPerKilobyte;
    if (kilobytes < _bytesPerKilobyte) return '${kilobytes.toStringAsFixed(0)} KB';
    return '${(kilobytes / _bytesPerKilobyte).toStringAsFixed(1)} MB';
  }

  static int megabytes(int bytes) => (bytes / (_bytesPerKilobyte * _bytesPerKilobyte)).floor();

  static int _calendarDaysBetween(DateTime from, DateTime to) {
    final start = DateTime(from.year, from.month, from.day);
    final end = DateTime(to.year, to.month, to.day);
    return (end.difference(start).inHours / _hoursPerDay).round();
  }
}
