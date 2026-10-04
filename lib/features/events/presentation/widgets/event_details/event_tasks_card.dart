import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';

class EventTasksCard extends StatelessWidget {
  const EventTasksCard({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final l10n = context.l10n;

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.mdRadius,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.tasksEventTitle,
                  style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: AppSpacing.xxs),
                Text(
                  l10n.eventTasksCardSubtitle,
                  style: context.textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
                ),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          DecoratedBox(
            decoration: BoxDecoration(color: colors.primary, shape: BoxShape.circle),
            child: SizedBox.square(
              dimension: AppSizes.iconButtonSize,
              child: Icon(
                context.isRTL ? LucideIcons.arrowLeft : LucideIcons.arrowRight,
                size: AppSizes.iconField,
                color: colors.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
