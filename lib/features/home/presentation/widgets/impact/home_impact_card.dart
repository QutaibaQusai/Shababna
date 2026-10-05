import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/repositories/home_repository.dart';
import '../shared/home_formatters.dart';

class HomeImpactCard extends StatelessWidget {
  const HomeImpactCard({super.key, required this.impact});

  static const _duration = Duration(milliseconds: 1400);
  static const _curve = Curves.easeOutCubic;
  static const _ringWidth = 6.0;
  static const _trackAlpha = 0.12;
  static const _percent = 100;

  final HomeImpact impact;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final textTheme = context.textTheme;
    final l10n = context.l10n;
    final tier = impact.tier;
    final nextTier = impact.nextTier;
    final iconSize = AppSizes.tierBadgeSize;
    final mutedStyle = textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin),
      child: Row(
        children: [
          CircularPercentIndicator(
            radius: AppSizes.homeImpactRingRadius,
            lineWidth: _ringWidth,
            percent: (impact.progressPercentage / _percent).clamp(0, 1).toDouble(),
            animation: true,
            animateFromLastPercent: true,
            animationDuration: _duration.inMilliseconds,
            curve: _curve,
            reverse: context.isRTL,
            circularStrokeCap: CircularStrokeCap.round,
            progressColor: colors.primary,
            backgroundColor: colors.primary.withValues(alpha: _trackAlpha),
            center: tier == null
                ? null
                : SvgPicture.network(
                    tier.iconUrl(isDark: context.isDark),
                    width: iconSize,
                    height: iconSize,
                    placeholderBuilder: (_) => SizedBox.square(dimension: iconSize),
                  ),
          ),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (tier != null)
                  Text(
                    tier.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                  ),
                SizedBox(height: AppSpacing.xxs),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: HomeFormatters.hours(context, impact.hours),
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      TextSpan(text: ' ${l10n.homeImpactHoursLabel}'),
                    ],
                  ),
                  style: textTheme.bodyMedium,
                ),
                SizedBox(height: AppSpacing.xxs),
                Text(
                  nextTier == null
                      ? l10n.homeImpactTopTier
                      : '${l10n.homeImpactToNext(HomeFormatters.hours(context, impact.remainingHours), nextTier.name)} · ${impact.progressPercentage}%',
                  style: mutedStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
