import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_assets.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/shared/widgets/app_page_header.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/repositories/dashboard_repository.dart';
import 'dashboard_events_card.dart';
import 'dashboard_hero_card.dart';
import 'dashboard_stat_card.dart';

class DashboardContent extends StatelessWidget {
  const DashboardContent({super.key, required this.dashboard});

  final VolunteerDashboard dashboard;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final pendingReview = dashboard.pendingTaskSubmissionsCount;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(AppSpacing.screenMargin),
      children: [
        AppPageHeader(
          title: l10n.myImpactTitle,
          subtitle: l10n.impactHeaderSubtitle,
        ),
        SizedBox(height: AppSpacing.md),
        DashboardHeroCard(dashboard: dashboard),
        SizedBox(height: AppSpacing.sm),
        DashboardEventsCard(dashboard: dashboard),
        SizedBox(height: AppSpacing.sm),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: DashboardStatCard(
                  asset: AppAssets.iconDiploma,
                  value: dashboard.earnedCertificatesCount,
                  label: l10n.impactCertificates,
                  onTap: () => context.push(AppRoutes.certificates),
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: DashboardStatCard(
                  asset: AppAssets.iconChecklist,
                  value: dashboard.tasksCompletedCount,
                  label: l10n.impactTasksCompleted,
                  badge: pendingReview > 0
                      ? l10n.impactPendingReview(pendingReview)
                      : null,
                  onTap: () => context.push(AppRoutes.tasks),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
