import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../domain/task_grouping.dart';

class TaskGroupHeader extends StatelessWidget {
  const TaskGroupHeader({super.key, required this.window, required this.count});

  final TaskDueWindow window;
  final int count;

  static String label(AppLocalizations l10n, TaskDueWindow window) => switch (window) {
    TaskDueWindow.overdue => l10n.taskOverdue,
    TaskDueWindow.thisWeek => l10n.taskGroupThisWeek,
    TaskDueWindow.later => l10n.taskGroupLater,
    TaskDueWindow.noDueDate => l10n.taskNoDueDate,
  };

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final color = window == TaskDueWindow.overdue ? colors.error : colors.onSurface;

    return Row(
      children: [
        Text(
          label(context.l10n, window),
          style: context.textTheme.titleSmall?.copyWith(color: color, fontWeight: FontWeight.bold),
        ),
        SizedBox(width: AppSpacing.xs),
        Text(
          '$count',
          style: context.textTheme.labelMedium?.copyWith(
            color: colors.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
