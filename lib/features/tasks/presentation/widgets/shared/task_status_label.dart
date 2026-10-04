import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';
import 'task_status_visual.dart';

class TaskStatusLabel extends StatelessWidget {
  const TaskStatusLabel({super.key, required this.visual});

  static const _tintAlpha = 0.12;

  final TaskStatusVisual visual;

  @override
  Widget build(BuildContext context) {
    final color = visual.color(context.colorScheme);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: _tintAlpha),
        borderRadius: AppRadius.pillRadius,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: AppSpacing.xxs),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(visual.icon, size: AppSizes.iconSm, color: color),
            SizedBox(width: AppSpacing.xxs),
            Text(
              visual.label(context.l10n),
              style: context.textTheme.labelMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
