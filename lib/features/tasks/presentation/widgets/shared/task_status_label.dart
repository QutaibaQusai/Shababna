import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../domain/repositories/tasks_repository.dart';

class TaskStatusLabel extends StatelessWidget {
  const TaskStatusLabel({super.key, required this.status, this.isOverdue = false});

  final TaskSubmissionStatus? status;
  final bool isOverdue;

  static String text(AppLocalizations l10n, TaskSubmissionStatus? status) => switch (status) {
    null => l10n.taskStatusNotSubmitted,
    TaskSubmissionStatus.pending => l10n.taskStatusPending,
    TaskSubmissionStatus.approved => l10n.taskStatusApproved,
    TaskSubmissionStatus.rejected => l10n.taskStatusRejected,
  };

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final l10n = context.l10n;

    return Text(
      isOverdue ? l10n.taskOverdue : text(l10n, status),
      style: context.textTheme.labelMedium?.copyWith(
        color: isOverdue ? colors.error : colors.primary,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
