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

class TaskCard extends StatelessWidget {
  const TaskCard({super.key, required this.task, required this.onReturn});

  final TaskSummary task;
  final VoidCallback onReturn;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final isArabic = context.isArabic;
    final muted = context.textTheme.labelMedium?.copyWith(color: colors.onSurfaceVariant);

    return Material(
      color: colors.surface,
      borderRadius: AppRadius.mdRadius,
      child: InkWell(
        borderRadius: AppRadius.mdRadius,
        onTap: () async {
          await context.push(AppRoutes.taskDetailsPath(task.id));
          onReturn();
        },
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      task.eventTitle(isArabic),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: muted,
                    ),
                  ),
                  SizedBox(width: AppSpacing.xs),
                  TaskStatusLabel(status: task.submissionStatus, isOverdue: task.isOverdue),
                ],
              ),
              SizedBox(height: AppSpacing.xxs),
              Text(
                task.name(isArabic),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: AppSpacing.xs),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.xxs,
                children: [
                  _Meta(
                    icon: LucideIcons.calendarClock,
                    text: TaskFormatters.dueDate(context, task.dueAt),
                  ),
                  _Meta(
                    icon: LucideIcons.clock,
                    text: TaskFormatters.hours(context, task.volunteeringHours),
                  ),
                  if (task.attachmentCount > 0)
                    _Meta(icon: LucideIcons.paperclip, text: '${task.attachmentCount}'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme.onSurfaceVariant;

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
