import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';

class EventPill extends StatelessWidget {
  const EventPill({
    super.key,
    required this.label,
    required this.color,
    this.icon,
    this.background,
  });

  static const _tintAlpha = 0.12;

  final String label;
  final Color color;
  final IconData? icon;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    final icon = this.icon;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: background ?? color.withValues(alpha: _tintAlpha),
        borderRadius: AppRadius.pillRadius,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: AppSpacing.xxs),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: AppSizes.iconSm, color: color),
              SizedBox(width: AppSpacing.xxs),
            ],
            Text(
              label,
              style: context.textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
