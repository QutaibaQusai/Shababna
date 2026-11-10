import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import 'dashboard_card.dart';
import 'dashboard_count_up.dart';

class DashboardStatCard extends StatelessWidget {
  const DashboardStatCard({
    super.key,
    required this.asset,
    required this.value,
    required this.label,
    required this.onTap,
    this.badge,
  });

  final String asset;
  final int value;
  final String label;
  final VoidCallback onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final textTheme = context.textTheme;
    final badge = this.badge;

    return DashboardCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              DashboardIcon(asset: asset),
              const Spacer(),
              Icon(
                context.isRTL
                    ? LucideIcons.chevronLeft
                    : LucideIcons.chevronRight,
                size: AppSizes.iconSm,
                color: colors.onSurfaceVariant,
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          DashboardCountUp(
            value: value,
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
          if (badge != null) ...[
            SizedBox(height: AppSpacing.xs),
            _PendingPill(label: badge),
          ],
        ],
      ),
    );
  }
}

class _PendingPill extends StatelessWidget {
  const _PendingPill({required this.label});

  static const _backgroundAlpha = 0.12;

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: AppColors.warningColor.withValues(alpha: _backgroundAlpha),
        borderRadius: AppRadius.pillRadius,
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.textTheme.labelSmall?.copyWith(
          color: AppColors.warningColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
