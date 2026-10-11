import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/number_formatter.dart';
import '../../../domain/repositories/profile_repository.dart';

class TierProgressSummary extends StatelessWidget {
  const TierProgressSummary({
    super.key,
    required this.tier,
    required this.nextTier,
    required this.volunteeringHours,
    required this.percentage,
  });

  static const _duration = Duration(milliseconds: 1400);
  static const _curve = Curves.easeOutCubic;

  final VolunteerTier? tier;
  final NextVolunteerTier? nextTier;
  final double volunteeringHours;
  final int percentage;

  @override
  Widget build(BuildContext context) {
    final tier = this.tier;
    if (tier == null) return const SizedBox.shrink();

    final l10n = context.l10n;
    final next = nextTier;
    final mutedStyle = context.textTheme.bodySmall?.copyWith(
      color: context.colorScheme.onSurfaceVariant,
    );

    return ExcludeSemantics(
      child: Column(
        children: [
          Text(
            tier.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          Text(
            next == null
                ? _hoursText(context, volunteeringHours)
                : l10n.volunteerHoursProgress(
                    _formatHours(context, volunteeringHours),
                    _formatHours(context, next.requiredHours),
                  ),
            textAlign: TextAlign.center,
            style: mutedStyle,
          ),
          SizedBox(height: AppSpacing.xs),
          if (next == null)
            Text(l10n.volunteerTierMaxReached, textAlign: TextAlign.center, style: mutedStyle)
          else
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: percentage.toDouble()),
              duration: _duration,
              curve: _curve,
              builder: (context, value, _) => Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: _hoursText(context, next.remainingHours),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: context.colorScheme.onSurface,
                      ),
                    ),
                    TextSpan(text: ' ${l10n.volunteerTierToReach(next.name)} · '),
                    TextSpan(
                      text: '${value.round()}%',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: context.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
                style: mutedStyle,
              ),
            ),
        ],
      ),
    );
  }
}

String _formatHours(BuildContext context, double hours) =>
    NumberFormatter.decimal(hours, locale: context.locale, maxFractionDigits: 1);

String _hoursText(BuildContext context, double hours) =>
    context.l10n.volunteerHoursCount(hours, _formatHours(context, hours));
