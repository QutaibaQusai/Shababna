import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../../../../../core/extensions/context_extensions.dart';

class TaskFormatters {
  TaskFormatters._();

  static const _bytesPerKilobyte = 1024;

  static String dueDate(BuildContext context, DateTime? date) {
    if (date == null) return context.l10n.taskNoDueDate;
    return DateFormat.yMMMd(context.locale.toLanguageTag()).add_jm().format(date);
  }

  static String date(BuildContext context, DateTime date) =>
      DateFormat.yMMMd(context.locale.toLanguageTag()).add_jm().format(date);

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
}
