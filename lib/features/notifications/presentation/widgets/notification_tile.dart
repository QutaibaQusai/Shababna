import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/repositories/notifications_repository.dart';
import 'notification_time_text.dart';
import 'notification_type_icon.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    super.key,
    required this.notification,
    required this.onTap,
  });

  static const _unreadTintAlpha = 0.05;

  final AppNotification notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final isArabic = context.isArabic;
    final isUnread = !notification.isRead;
    final body = notification.body(isArabic);

    return Material(
      color: isUnread
          ? colors.primary.withValues(alpha: _unreadTintAlpha)
          : Colors.transparent,
      borderRadius: AppRadius.lgRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.lgRadius,
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.sm),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NotificationTypeIcon(type: notification.type),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title(isArabic),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.titleSmall?.copyWith(
                              fontWeight: isUnread
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                          ),
                        ),
                        if (isUnread) ...[
                          SizedBox(width: AppSpacing.xs),
                          Container(
                            width: AppSizes.notificationUnreadDotSize,
                            height: AppSizes.notificationUnreadDotSize,
                            decoration: BoxDecoration(
                              color: colors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (body.isNotEmpty) ...[
                      SizedBox(height: AppSpacing.xxs),
                      Text(
                        body,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                    SizedBox(height: AppSpacing.xs),
                    NotificationTimeText(createdAt: notification.createdAt),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
