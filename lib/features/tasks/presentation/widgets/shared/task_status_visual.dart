import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../domain/repositories/tasks_repository.dart';

enum TaskStatusVisual {
  todo(LucideIcons.circleDashed),
  overdue(LucideIcons.clockAlert),
  rejected(LucideIcons.circleAlert),
  pending(LucideIcons.hourglass),
  approved(LucideIcons.circleCheck);

  const TaskStatusVisual(this.icon);

  final IconData icon;

  static TaskStatusVisual of(TaskSubmissionStatus? status, {required bool isOverdue}) =>
      switch (status) {
        TaskSubmissionStatus.rejected => rejected,
        TaskSubmissionStatus.pending => pending,
        TaskSubmissionStatus.approved => approved,
        null => isOverdue ? overdue : todo,
      };

  Color color(ColorScheme colors) => switch (this) {
    todo => colors.primary,
    overdue || rejected => colors.error,
    pending => AppColors.warningColor,
    approved => AppColors.successColor,
  };

  String label(AppLocalizations l10n) => switch (this) {
    todo => l10n.taskStatusNotSubmitted,
    overdue => l10n.taskOverdue,
    rejected => l10n.taskStatusRejected,
    pending => l10n.taskStatusPending,
    approved => l10n.taskStatusApproved,
  };
}
