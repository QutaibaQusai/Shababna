import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/extensions/context_extensions.dart';

class NotificationTimeText extends StatelessWidget {
  const NotificationTimeText({super.key, required this.createdAt});

  static const _minutesPerHour = 60;

  final DateTime createdAt;

  String _label(BuildContext context) {
    final l10n = context.l10n;
    final now = DateTime.now();
    final difference = now.difference(createdAt);
    final locale = context.locale.toLanguageTag();

    if (difference.inMinutes < 1) return l10n.notificationsJustNow;
    if (difference.inMinutes < _minutesPerHour) {
      return l10n.notificationsMinutesAgo(difference.inMinutes);
    }
    if (DateUtils.isSameDay(createdAt, now)) {
      return l10n.notificationsHoursAgo(difference.inHours);
    }

    final yesterday = DateUtils.addDaysToDate(DateUtils.dateOnly(now), -1);
    if (DateUtils.isSameDay(createdAt, yesterday)) {
      final separator = context.isArabic ? '، ' : ', ';
      return '${l10n.notificationsYesterday}$separator${DateFormat.jm(locale).format(createdAt)}';
    }
    return DateFormat.yMMMd(locale).format(createdAt);
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _label(context),
      style: context.textTheme.labelSmall?.copyWith(
        color: context.colorScheme.onSurfaceVariant,
      ),
    );
  }
}
