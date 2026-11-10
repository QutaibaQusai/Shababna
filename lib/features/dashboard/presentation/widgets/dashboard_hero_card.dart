import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../../../core/config/app_assets.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/repositories/dashboard_repository.dart';
import 'dashboard_card.dart';
import 'dashboard_count_up.dart';
import 'dashboard_formatters.dart';

class DashboardHeroCard extends StatelessWidget {
  const DashboardHeroCard({super.key, required this.dashboard});

  static const _duration = Duration(milliseconds: 1400);
  static const _curve = Curves.easeOutCubic;
  static const _trackAlpha = 0.12;
  static const _fullProgress = 100;

  final VolunteerDashboard dashboard;

  int get _progress => dashboard.tier != null && dashboard.nextTier == null
      ? _fullProgress
      : dashboard.tierProgressPercentage;

  String? _caption(BuildContext context) {
    final l10n = context.l10n;
    final nextTier = dashboard.nextTier;
    if (nextTier != null) {
      return l10n.impactToNextTier(
        DashboardFormatters.hours(context, nextTier.remainingHours),
        nextTier.name,
      );
    }
    return dashboard.tier == null ? null : l10n.impactTopTier;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final textTheme = context.textTheme;
    final l10n = context.l10n;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final mutedStyle = textTheme.bodyMedium?.copyWith(
      color: colors.onSurfaceVariant,
    );
    final caption = _caption(context);

    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.impactHoursLabel, style: mutedStyle),
          SizedBox(height: AppSpacing.xxs),
          DashboardCountUp(
            value: dashboard.totalVolunteeringHours,
            decimals: DashboardFormatters.hoursDecimals,
            style: textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: colors.onSurface,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _TierIcon(tier: dashboard.tier),
              SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  dashboard.tier?.name ?? l10n.impactNoTier,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DashboardCountUp(
                value: _progress,
                suffix: '%',
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.xs),
          LinearPercentIndicator(
            percent: (_progress / _fullProgress).clamp(0, 1).toDouble(),
            lineHeight: AppSizes.progressBarHeightSm,
            padding: EdgeInsets.zero,
            barRadius: Radius.circular(AppRadius.pill),
            isRTL: context.isRTL,
            progressColor: colors.primary,
            backgroundColor: colors.primary.withValues(alpha: _trackAlpha),
            animation: !reduceMotion,
            animateFromLastPercent: true,
            animationDuration: _duration.inMilliseconds,
            curve: _curve,
          ),
          if (caption != null) ...[
            SizedBox(height: AppSpacing.xs),
            Text(
              caption,
              style: textTheme.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TierIcon extends StatelessWidget {
  const _TierIcon({required this.tier});

  final DashboardTier? tier;

  @override
  Widget build(BuildContext context) {
    final size = AppSizes.tierBadgeSize;
    final url = tier?.iconUrl(isDark: context.isDark) ?? '';

    if (url.isEmpty) {
      return Image.asset(AppAssets.iconTrophy, width: size, height: size);
    }
    return SvgPicture.network(
      url,
      width: size,
      height: size,
      placeholderBuilder: (_) => SizedBox.square(dimension: size),
    );
  }
}
