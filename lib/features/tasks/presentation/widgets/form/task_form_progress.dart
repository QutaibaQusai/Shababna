import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';

class TaskFormProgress extends StatelessWidget {
  const TaskFormProgress({super.key, required this.answered, required this.total});

  static const _trackAlpha = 0.12;
  static const _duration = Duration(milliseconds: 1400);
  static const _curve = Curves.easeOutCubic;

  final int answered;
  final int total;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.l10n.taskFormProgress(answered, total),
          style: context.textTheme.labelLarge?.copyWith(
            color: colors.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: AppSpacing.xs),
        LinearPercentIndicator(
          percent: total == 0 ? 1 : (answered / total).clamp(0, 1).toDouble(),
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
      ],
    );
  }
}
