import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/repositories/tasks_repository.dart';
import '../shared/task_formatters.dart';
import '../shared/task_status_label.dart';
import '../shared/task_status_visual.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task, required this.onReturn, this.showEvent = true});

  static const _stripeWidth = 6.0;

  final TaskSummary task;
  final VoidCallback onReturn;
  final bool showEvent;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final isArabic = context.isArabic;
    final visual = TaskStatusVisual.of(task.submissionStatus, isOverdue: task.isOverdue);
    final isRejected = task.submissionStatus == TaskSubmissionStatus.rejected;

    return Material(
      color: colors.surface,
      borderRadius: AppRadius.mdRadius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () async {
          final changed = await context.push<bool>(AppRoutes.taskDetailsPath(task.id));
          if (changed == true) onReturn();
        },
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: _stripeWidth,
                child: ColoredBox(color: visual.color(colors)),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.name(isArabic),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      if (showEvent) ...[
                        SizedBox(height: AppSpacing.xxs),
                        Text(
                          task.eventTitle(isArabic),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.labelMedium?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                      SizedBox(height: AppSpacing.xs),
                      Wrap(
                        spacing: AppSpacing.sm,
                        runSpacing: AppSpacing.xxs,
                        children: [
                          _Meta(
                            icon: LucideIcons.calendarClock,
                            text: TaskFormatters.relativeDue(context, task.dueAt),
                            color: task.isOverdue ? colors.error : null,
                          ),
                          _Meta(
                            icon: LucideIcons.clock,
                            text: TaskFormatters.hours(context, task.volunteeringHours),
                          ),
                          if (task.attachmentCount > 0)
                            _Meta(icon: LucideIcons.paperclip, text: '${task.attachmentCount}'),
                        ],
                      ),
                      if (isRejected) ...[
                        SizedBox(height: AppSpacing.xs),
                        TaskStatusLabel(visual: visual),
                      ],
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.only(end: AppSpacing.xs),
                child: Icon(
                  context.isRTL ? LucideIcons.chevronLeft : LucideIcons.chevronRight,
                  size: AppSizes.iconField,
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.icon, required this.text, this.color});

  final IconData icon;
  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final color = this.color ?? context.colorScheme.onSurfaceVariant;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: AppSizes.iconSm, color: color),
        SizedBox(width: AppSpacing.xxs),
        Text(text, style: context.textTheme.labelMedium?.copyWith(color: color)),
      ],
    );
  }
}
