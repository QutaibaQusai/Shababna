import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/repositories/notifications_repository.dart';
import 'notification_time_text.dart';
import 'notification_icon.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    super.key,
    required this.notification,
    required this.onTap,
  });

  final AppNotification notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final isArabic = context.isArabic;
    final isUnread = !notification.isRead;
    final body = notification.body(isArabic);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.screenMargin,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NotificationIcon(
                type: notification.type,
                color: isUnread ? colors.primary : colors.onSurfaceVariant,
              ),
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
                              color: isUnread ? colors.primary : null,
                              fontWeight: isUnread
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                          ),
                        ),
                        SizedBox(width: AppSpacing.xs),
                        NotificationTimeText(createdAt: notification.createdAt),
                      ],
                    ),
                    if (body.isNotEmpty) ...[
                      SizedBox(height: AppSpacing.xxs),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              body,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: context.textTheme.bodySmall?.copyWith(
                                color: colors.onSurfaceVariant,
                              ),
                            ),
                          ),
                          if (isUnread) ...[
                            SizedBox(width: AppSpacing.xs),
                            const _UnreadDot(),
                          ],
                        ],
                      ),
                    ],
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

class _UnreadDot extends StatelessWidget {
  const _UnreadDot();

  @override
  Widget build(BuildContext context) {
    final size = AppSizes.notificationUnreadDotSize;

    return Padding(
      padding: EdgeInsets.only(top: AppSpacing.xxs),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: context.colorScheme.primary,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
