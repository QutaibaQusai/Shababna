import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/number_formatter.dart';
import '../../../domain/repositories/profile_repository.dart';
import '../../cubit/profile/profile_cubit.dart';
import '../profile/volunteer_tier_badge.dart';

class VolunteerTierProgress extends StatelessWidget {
  const VolunteerTierProgress({super.key});

  static const _duration = Duration(milliseconds: 1400);
  static const _curve = Curves.easeOutCubic;

  @override
  Widget build(BuildContext context) {
    final profile = context.select((ProfileCubit cubit) => cubit.state.profile);
    final tier = profile?.tier;
    if (profile == null || tier == null) return const SizedBox.shrink();

    final next = profile.nextTier;
    final percentage = profile.tierProgressPercentage;
    final startColor = Color(tier.color);
    final endColor = next == null ? startColor : Color(next.color);
    final mutedStyle = context.textTheme.bodySmall?.copyWith(
      color: context.colorScheme.onSurfaceVariant,
    );

    return Semantics(
      label: _semanticsLabel(context, tier, next),
      value: '$percentage%',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              VolunteerTierBadge(
                name: tier.name,
                lightIconUrl: tier.lightIconUrl,
                darkIconUrl: tier.darkIconUrl,
                size: AppSizes.tierBadgeSize,
              ),
              SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tier.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    Text(
                      next == null
                          ? _hoursText(context, profile.volunteeringHours)
                          : context.l10n.volunteerHoursProgress(
                              _formatHours(context, profile.volunteeringHours),
                              _formatHours(context, next.requiredHours),
                            ),
                      style: mutedStyle,
                    ),
                  ],
                ),
              ),
              if (next != null) _LockedTierBadge(tier: next, size: AppSizes.tierBadgeSizeSmall),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          _TierProgressBar(
            percent: (percentage / 100).clamp(0, 1).toDouble(),
            startColor: startColor,
            endColor: endColor,
            duration: _duration,
            curve: _curve,
          ),
          SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: next == null
                    ? Text(context.l10n.volunteerTierMaxReached, style: mutedStyle)
                    : Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: _hoursText(context, next.remainingHours),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: context.colorScheme.onSurface,
                              ),
                            ),
                            TextSpan(text: ' ${context.l10n.volunteerTierToReach(next.name)}'),
                          ],
                        ),
                        style: mutedStyle,
                      ),
              ),
              SizedBox(width: AppSpacing.xs),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: percentage.toDouble()),
                duration: _duration,
                curve: _curve,
                builder: (context, value, _) => Text(
                  '${value.round()}%',
                  textDirection: TextDirection.ltr,
                  style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _semanticsLabel(BuildContext context, VolunteerTier tier, NextVolunteerTier? next) {
    if (next == null) return '${tier.name}. ${context.l10n.volunteerTierMaxReached}';
    final hours = _hoursText(context, next.remainingHours);
    return '${tier.name}. $hours ${context.l10n.volunteerTierToReach(next.name)}';
  }
}

String _formatHours(BuildContext context, double hours) =>
    NumberFormatter.decimal(hours, locale: context.locale, maxFractionDigits: 1);

String _hoursText(BuildContext context, double hours) =>
    context.l10n.volunteerHoursCount(hours, _formatHours(context, hours));

class _TierProgressBar extends StatelessWidget {
  const _TierProgressBar({
    required this.percent,
    required this.startColor,
    required this.endColor,
    required this.duration,
    required this.curve,
  });

  final double percent;
  final Color startColor;
  final Color endColor;
  final Duration duration;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    final isRtl = context.isRTL;

    return LinearPercentIndicator(
      percent: percent,
      lineHeight: AppSizes.progressBarHeight,
      padding: EdgeInsets.zero,
      barRadius: Radius.circular(AppRadius.pill),
      isRTL: isRtl,
      backgroundColor: context.colorScheme.surfaceContainerHighest,
      linearGradient: LinearGradient(
        begin: isRtl ? Alignment.centerRight : Alignment.centerLeft,
        end: isRtl ? Alignment.centerLeft : Alignment.centerRight,
        colors: [startColor, endColor],
      ),
      animation: true,
      animateFromLastPercent: true,
      animationDuration: duration.inMilliseconds,
      curve: curve,
    );
  }
}

class _LockedTierBadge extends StatelessWidget {
  const _LockedTierBadge({required this.tier, required this.size});

  static const _grayscale = ColorFilter.matrix(<double>[
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0.2126,
    0.7152,
    0.0722,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
  ]);

  final NextVolunteerTier tier;
  final double size;

  @override
  Widget build(BuildContext context) {
    final lockSize = AppSizes.iconSm;
    final lockOffset = -AppSpacing.xxs / 2;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Opacity(
          opacity: 0.55,
          child: ColorFiltered(
            colorFilter: _grayscale,
            child: VolunteerTierBadge(
              name: tier.name,
              lightIconUrl: tier.lightIconUrl,
              darkIconUrl: tier.darkIconUrl,
              size: size,
            ),
          ),
        ),
        PositionedDirectional(
          end: lockOffset,
          bottom: lockOffset,
          child: Container(
            width: lockSize,
            height: lockSize,
            decoration: BoxDecoration(
              color: context.colorScheme.surface,
              shape: BoxShape.circle,
              border: Border.all(color: context.colorScheme.outlineVariant),
            ),
            child: Icon(
              LucideIcons.lock,
              size: lockSize * 0.6,
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}
