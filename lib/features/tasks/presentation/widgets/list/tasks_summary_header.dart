import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../../../../core/config/app_assets.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../shared/task_formatters.dart';

class TasksSummaryHeader extends StatelessWidget {
  const TasksSummaryHeader({
    super.key,
    required this.completed,
    required this.total,
    required this.earnedHours,
    required this.waitingReview,
  });

  static const _trackAlpha = 0.12;
  static const _percent = 100;
  static const _duration = Duration(milliseconds: 1400);
  static const _curve = Curves.easeOutCubic;

  final int completed;
  final int total;
  final double earnedHours;
  final int waitingReview;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final l10n = context.l10n;
    final progress = total == 0 ? 0.0 : completed / total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.tasksProgress(completed, total),
                style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: progress * _percent),
              duration: _duration,
              curve: _curve,
              builder: (context, value, _) => Text(
                '${value.round()}%',
                textDirection: TextDirection.ltr,
                style: context.textTheme.titleSmall?.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.xs),
        LinearPercentIndicator(
          percent: progress.clamp(0, 1).toDouble(),
          lineHeight: AppSizes.progressBarHeightSm,
          padding: EdgeInsets.zero,
          barRadius: Radius.circular(AppRadius.pill),
          isRTL: context.isRTL,
          progressColor: colors.primary,
          backgroundColor: colors.primary.withValues(alpha: _trackAlpha),
          animation: true,
          animateFromLastPercent: true,
          animationDuration: _duration.inMilliseconds,
          curve: _curve,
        ),
        SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: _Stat(
                asset: AppAssets.iconTrophy,
                value: TaskFormatters.hours(context, earnedHours),
                label: l10n.tasksHoursEarned,
              ),
            ),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _Stat(
                asset: AppAssets.iconHourglass,
                value: '$waitingReview',
                label: l10n.tasksWaitingReview,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.asset, required this.value, required this.label});

  final String asset;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final size = AppSizes.iconButtonSize;

    return Row(
      children: [
        Image.asset(asset, width: size, height: size),
        SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.labelSmall?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
