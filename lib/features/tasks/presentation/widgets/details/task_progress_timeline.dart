import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/repositories/tasks_repository.dart';
import '../shared/task_formatters.dart';
import '../shared/task_status_visual.dart';

enum _StepState { done, current, upcoming }

class TaskProgressTimeline extends StatelessWidget {
  const TaskProgressTimeline({super.key, required this.status, required this.submission});

  final TaskSubmissionStatus? status;
  final TaskSubmission? submission;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colorScheme;
    final submission = this.submission;
    final reviewedAt = submission?.reviewedAt;
    final isSubmitted = status != null;
    final isReviewed =
        status == TaskSubmissionStatus.approved || status == TaskSubmissionStatus.rejected;
    final reviewVisual = TaskStatusVisual.of(status, isOverdue: false);

    return Column(
      children: [
        _Step(state: _StepState.done, title: l10n.taskTimelineAssigned, color: colors.primary),
        _Step(
          state: isSubmitted ? _StepState.done : _StepState.current,
          title: l10n.taskTimelineSubmitted,
          subtitle: submission == null
              ? l10n.taskTimelineWaiting
              : TaskFormatters.date(context, submission.submittedAt),
          color: colors.primary,
        ),
        _Step(
          state: isReviewed
              ? _StepState.done
              : isSubmitted
              ? _StepState.current
              : _StepState.upcoming,
          title: isReviewed ? reviewVisual.label(l10n) : l10n.taskTimelineReviewed,
          subtitle: switch ((isReviewed, isSubmitted)) {
            (true, _) when reviewedAt != null => TaskFormatters.date(context, reviewedAt),
            (true, _) => null,
            (false, true) => l10n.taskStatusPending,
            (false, false) => l10n.taskTimelineWaiting,
          },
          color: isReviewed ? reviewVisual.color(colors) : colors.primary,
          icon: status == TaskSubmissionStatus.rejected ? LucideIcons.x : LucideIcons.check,
          isLast: true,
        ),
      ],
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({
    required this.state,
    required this.title,
    required this.color,
    this.subtitle,
    this.icon = LucideIcons.check,
    this.isLast = false,
  });

  static const _lineWidth = 2.0;
  static const _ringWidth = 2.0;

  final _StepState state;
  final String title;
  final String? subtitle;
  final Color color;
  final IconData icon;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final subtitle = this.subtitle;
    final isUpcoming = state == _StepState.upcoming;
    final dotSize = AppSizes.iconMd;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(
                width: dotSize,
                height: dotSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: state == _StepState.done ? color : null,
                  border: state == _StepState.done
                      ? null
                      : Border.all(
                          color: isUpcoming ? colors.outlineVariant : color,
                          width: _ringWidth,
                        ),
                ),
                child: state == _StepState.done
                    ? Icon(icon, size: AppSizes.iconSm, color: colors.onPrimary)
                    : null,
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: _lineWidth,
                    color: state == _StepState.done ? color : colors.outlineVariant,
                  ),
                ),
            ],
          ),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isUpcoming ? colors.onSurfaceVariant : colors.onSurface,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: context.textTheme.labelMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
