import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/utils/number_formatter.dart';
import '../../../domain/repositories/profile_repository.dart';
import '../profile/volunteer_tier_badge.dart';

class TierArcFrame extends StatelessWidget {
  const TierArcFrame({
    super.key,
    required this.tier,
    required this.nextTier,
    required this.percentage,
    required this.childSize,
    required this.child,
  });

  static const _sweepFraction = 0.6;
  static const _percent = 100;
  static const _duration = Duration(milliseconds: 1400);
  static const _curve = Curves.easeOutCubic;

  final VolunteerTier? tier;
  final NextVolunteerTier? nextTier;
  final int percentage;
  final double childSize;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final tier = this.tier;
    if (tier == null) return child;

    final next = nextTier;
    final progress = next == null ? 1.0 : (percentage / _percent).clamp(0.0, 1.0).toDouble();
    final isRtl = context.isRTL;
    final medalSize = AppSizes.tierArcMedalSize;
    final strokeWidth = AppSizes.tierArcStroke;
    final radius = childSize / 2 + AppSizes.tierArcGap + strokeWidth / 2;
    final sweep = 2 * math.pi * _sweepFraction;
    final start = math.pi / 2 + (2 * math.pi - sweep) / 2;
    final halfWidth = math.max(
      radius + strokeWidth / 2,
      radius * math.cos(start).abs() + medalSize / 2,
    );
    final top = radius + strokeWidth / 2;
    final bottom = math.max(childSize / 2, radius * math.sin(start) + medalSize / 2);
    final center = Offset(halfWidth, top);

    Widget medal(double angle, Widget medal) {
      final dx = radius * math.cos(angle);
      return Positioned(
        left: center.dx + (isRtl ? -dx : dx) - medalSize / 2,
        top: center.dy + radius * math.sin(angle) - medalSize / 2,
        child: medal,
      );
    }

    return Semantics(
      label: _semanticsLabel(context, tier, next),
      value: '$percentage%',
      child: SizedBox(
        width: halfWidth * 2,
        height: top + bottom,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: Transform.flip(
                flipX: isRtl,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: progress),
                  duration: _duration,
                  curve: _curve,
                  builder: (context, value, _) => CustomPaint(
                    painter: _TierArcPainter(
                      progress: value,
                      center: center,
                      radius: radius,
                      startAngle: start,
                      sweepAngle: sweep,
                      strokeWidth: strokeWidth,
                      trackColor: context.colorScheme.surfaceContainerHighest,
                      startColor: Color(tier.color),
                      endColor: Color(next?.color ?? tier.color),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: center.dx - childSize / 2,
              top: center.dy - childSize / 2,
              width: childSize,
              height: childSize,
              child: child,
            ),
            medal(
              start,
              _TierMedal(
                name: tier.name,
                lightIconUrl: tier.lightIconUrl,
                darkIconUrl: tier.darkIconUrl,
                size: medalSize,
              ),
            ),
            if (next != null)
              medal(
                start + sweep,
                _TierMedal(
                  name: next.name,
                  lightIconUrl: next.lightIconUrl,
                  darkIconUrl: next.darkIconUrl,
                  size: medalSize,
                  isLocked: true,
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _semanticsLabel(BuildContext context, VolunteerTier tier, NextVolunteerTier? next) {
    final l10n = context.l10n;
    if (next == null) return '${tier.name}. ${l10n.volunteerTierMaxReached}';
    final hours = NumberFormatter.decimal(
      next.remainingHours,
      locale: context.locale,
      maxFractionDigits: 1,
    );
    final hoursText = l10n.volunteerHoursCount(next.remainingHours, hours);
    return '${tier.name}. $hoursText ${l10n.volunteerTierToReach(next.name)}';
  }
}

class _TierMedal extends StatelessWidget {
  const _TierMedal({
    required this.name,
    required this.lightIconUrl,
    required this.darkIconUrl,
    required this.size,
    this.isLocked = false,
  });

  static const _outline = 2.0;
  static const _lockedOpacity = 0.75;
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

  final String name;
  final String lightIconUrl;
  final String darkIconUrl;
  final double size;
  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    final badge = VolunteerTierBadge(
      name: name,
      lightIconUrl: lightIconUrl,
      darkIconUrl: darkIconUrl,
      size: size - _outline * 2,
    );

    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(_outline),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        shape: BoxShape.circle,
      ),
      child: isLocked
          ? Opacity(
              opacity: _lockedOpacity,
              child: ColorFiltered(colorFilter: _grayscale, child: badge),
            )
          : badge,
    );
  }
}

class _TierArcPainter extends CustomPainter {
  const _TierArcPainter({
    required this.progress,
    required this.center,
    required this.radius,
    required this.startAngle,
    required this.sweepAngle,
    required this.strokeWidth,
    required this.trackColor,
    required this.startColor,
    required this.endColor,
  });

  final double progress;
  final Offset center;
  final double radius;
  final double startAngle;
  final double sweepAngle;
  final double strokeWidth;
  final Color trackColor;
  final Color startColor;
  final Color endColor;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromCircle(center: center, radius: radius);
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, startAngle, sweepAngle, false, stroke..color = trackColor);
    if (progress <= 0) return;

    stroke.shader = SweepGradient(
      endAngle: sweepAngle,
      colors: [startColor, endColor],
      transform: GradientRotation(startAngle),
    ).createShader(rect);
    canvas.drawArc(rect, startAngle, sweepAngle * progress, false, stroke);
  }

  @override
  bool shouldRepaint(_TierArcPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.center != center ||
      oldDelegate.radius != radius ||
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.trackColor != trackColor ||
      oldDelegate.startColor != startColor ||
      oldDelegate.endColor != endColor;
}
