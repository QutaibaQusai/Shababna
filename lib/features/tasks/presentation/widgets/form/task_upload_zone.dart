import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';

class TaskUploadZone extends StatelessWidget {
  const TaskUploadZone({
    super.key,
    required this.icon,
    required this.title,
    required this.hint,
    required this.hasError,
    required this.onTap,
  });

  static const _tintAlpha = 0.05;

  final IconData icon;
  final String title;
  final String hint;
  final bool hasError;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final color = hasError ? colors.error : colors.primary;

    return Material(
      color: color.withValues(alpha: _tintAlpha),
      borderRadius: AppRadius.mdRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.mdRadius,
        child: CustomPaint(
          painter: _DashedBorderPainter(color: color, radius: AppRadius.md),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.sm),
            child: Column(
              children: [
                Icon(icon, size: AppSizes.iconLg, color: color),
                SizedBox(height: AppSpacing.xs),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: context.textTheme.titleSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: AppSpacing.xxs),
                Text(
                  hint,
                  textAlign: TextAlign.center,
                  style: context.textTheme.labelSmall?.copyWith(color: colors.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({required this.color, required this.radius});

  static const _strokeWidth = 1.5;
  static const _dashLength = 6.0;
  static const _gapLength = 4.0;

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = _strokeWidth
      ..style = PaintingStyle.stroke;
    final inset = _strokeWidth / 2;
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(inset, inset, size.width - _strokeWidth, size.height - _strokeWidth),
          Radius.circular(radius),
        ),
      );

    for (final PathMetric metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(metric.extractPath(distance, distance + _dashLength), paint);
        distance += _dashLength + _gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.radius != radius;
}
