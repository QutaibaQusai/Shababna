import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/repositories/tasks_repository.dart';
import '../shared/task_formatters.dart';

class TaskInfoSection extends StatelessWidget {
  const TaskInfoSection({super.key, required this.task});

  final TaskDetails task;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final rows = [
      (
        l10n.taskDueLabel,
        TaskFormatters.relativeDue(context, task.dueAt),
        task.isOverdue ? context.colorScheme.error : null,
      ),
      (l10n.taskHoursLabel, TaskFormatters.hours(context, task.volunteeringHours), null),
      (l10n.taskFilesLabel, '${task.attachments.length}', null),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < rows.length; i++) ...[
          if (i > 0) SizedBox(height: AppSpacing.sm),
          _InfoRow(label: rows[i].$1, value: rows[i].$2, valueColor: rows[i].$3),
        ],
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value, this.valueColor});

  static const _labelFlex = 2;
  static const _valueFlex = 3;

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: _labelFlex,
          child: Text(
            label,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Expanded(
          flex: _valueFlex,
          child: Text(
            value,
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
        ),
      ],
    );
  }
}
