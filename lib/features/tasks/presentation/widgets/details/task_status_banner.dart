import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/repositories/tasks_repository.dart';
import '../shared/task_formatters.dart';
import '../shared/task_status_visual.dart';

class TaskStatusBanner extends StatelessWidget {
  const TaskStatusBanner({super.key, required this.task, required this.submission});

  static const _tintAlpha = 0.1;

  final TaskDetails task;
  final TaskSubmission? submission;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final l10n = context.l10n;

    if (!task.isAssignedToMe && task.submissionStatus == null) {
      return _Banner(color: colors.onSurfaceVariant, title: l10n.taskNotAssigned);
    }

    final visual = TaskStatusVisual.of(task.submissionStatus, isOverdue: task.isOverdue);
    final dueAt = task.dueAt;
    final reason = submission?.rejectionReason?.trim() ?? '';
    final creditedHours = submission?.creditedHours;

    return _Banner(
      color: visual.color(colors),
      title: visual.label(l10n),
      message: switch (visual) {
        TaskStatusVisual.todo when dueAt != null => l10n.taskBannerTodo(
          TaskFormatters.dueDate(context, dueAt),
        ),
        TaskStatusVisual.todo => l10n.taskBannerTodoNoDue,
        TaskStatusVisual.overdue => l10n.taskBannerOverdue,
        TaskStatusVisual.pending => l10n.taskBannerPending,
        TaskStatusVisual.approved when creditedHours != null && creditedHours > 0 =>
          l10n.taskBannerApproved(TaskFormatters.hours(context, creditedHours)),
        TaskStatusVisual.approved => l10n.taskBannerApprovedNoHours,
        TaskStatusVisual.rejected when reason.isNotEmpty => reason,
        TaskStatusVisual.rejected => l10n.taskBannerRejected,
      },
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({required this.color, required this.title, this.message});

  final Color color;
  final String title;
  final String? message;

  @override
  Widget build(BuildContext context) {
    final message = this.message;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: TaskStatusBanner._tintAlpha),
        borderRadius: AppRadius.mdRadius,
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: context.textTheme.titleSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (message != null) ...[
              SizedBox(height: AppSpacing.xxs),
              Text(message, style: context.textTheme.bodySmall),
            ],
          ],
        ),
      ),
    );
  }
}
