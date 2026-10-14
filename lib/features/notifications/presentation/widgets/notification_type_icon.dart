import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/notifications/push_message.dart';
import '../../../../core/theme/app_sizes.dart';

class NotificationTypeIcon extends StatelessWidget {
  const NotificationTypeIcon({super.key, required this.type});

  static const _tintAlpha = 0.1;

  final NotificationType type;

  IconData get _icon => switch (type) {
    NotificationType.news => LucideIcons.newspaper,
    NotificationType.event => LucideIcons.calendarDays,
    NotificationType.registration => LucideIcons.clipboardCheck,
    NotificationType.task => LucideIcons.listTodo,
    NotificationType.tier => LucideIcons.trophy,
    NotificationType.certificate => LucideIcons.award,
    NotificationType.general ||
    NotificationType.unknown => LucideIcons.megaphone,
  };

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: primary.withValues(alpha: _tintAlpha),
        shape: BoxShape.circle,
      ),
      child: SizedBox.square(
        dimension: AppSizes.notificationIconSize,
        child: Icon(_icon, size: AppSizes.iconField, color: primary),
      ),
    );
  }
}
