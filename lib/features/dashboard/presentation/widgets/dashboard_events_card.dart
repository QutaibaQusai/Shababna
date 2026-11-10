import 'package:flutter/material.dart';

import '../../../../core/config/app_assets.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/repositories/dashboard_repository.dart';
import 'dashboard_card.dart';
import 'dashboard_count_up.dart';

class DashboardEventsCard extends StatelessWidget {
  const DashboardEventsCard({super.key, required this.dashboard});

  final VolunteerDashboard dashboard;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = context.textTheme;

    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const DashboardIcon(asset: AppAssets.iconCalendar3d),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  l10n.impactEvents,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DashboardCountUp(
                value: dashboard.registeredEventsCount,
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: _StatusTile(
                  asset: AppAssets.iconCheckCircle,
                  value: dashboard.completedEventsCount,
                  label: l10n.impactCompleted,
                ),
              ),
              SizedBox(width: AppSpacing.xs),
              Expanded(
                child: _StatusTile(
                  asset: AppAssets.iconAlarmClock,
                  value: dashboard.upcomingEventsCount,
                  label: l10n.impactUpcoming,
                ),
              ),
              SizedBox(width: AppSpacing.xs),
              Expanded(
                child: _StatusTile(
                  asset: AppAssets.iconHourglass,
                  value: dashboard.pendingApprovalCount,
                  label: l10n.impactPending,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusTile extends StatelessWidget {
  const _StatusTile({
    required this.asset,
    required this.value,
    required this.label,
  });

  final String asset;
  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final iconSize = AppSizes.iconLg;

    return Container(
      padding: EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
        borderRadius: AppRadius.mdRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(asset, width: iconSize, height: iconSize),
          SizedBox(height: AppSpacing.xs),
          DashboardCountUp(
            value: value,
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.labelSmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
