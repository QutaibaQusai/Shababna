import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../cubit/task_details/task_details_cubit.dart';
import '../shared/task_file_tile.dart';
import '../shared/task_section_title.dart';
import 'task_description.dart';
import 'task_progress_timeline.dart';
import 'task_info_section.dart';
import 'task_status_banner.dart';
import 'task_submission_summary.dart';

class TaskDetailsContent extends StatelessWidget {
  const TaskDetailsContent({super.key, required this.state});

  final TaskDetailsState state;

  @override
  Widget build(BuildContext context) {
    final task = state.task!;
    final submission = state.submission;
    final cubit = context.read<TaskDetailsCubit>();
    final l10n = context.l10n;
    final isArabic = context.isArabic;
    final description = task.description(isArabic).trim();
    final showProgress = task.isAssignedToMe || task.submissionStatus != null;

    return ListView(
      padding: EdgeInsets.all(AppSpacing.screenMargin),
      children: [
        Text(
          task.name(isArabic),
          style: context.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: AppSpacing.xxs),
        _EventLink(
          title: task.eventTitle(isArabic),
          onTap: () => context.push(AppRoutes.eventDetailsPath(task.eventId)),
        ),
        if (description.isNotEmpty) ...[
          SizedBox(height: AppSpacing.md),
          TaskSectionTitle(title: l10n.taskAboutTitle),
          SizedBox(height: AppSpacing.xs),
          TaskDescription(html: description),
        ],
        SizedBox(height: AppSpacing.md),
        TaskSectionTitle(title: l10n.taskInfoTitle),
        SizedBox(height: AppSpacing.sm),
        TaskInfoSection(task: task),
        SizedBox(height: AppSpacing.md),
        if (showProgress) ...[
          TaskSectionTitle(title: l10n.taskProgressTitle),
          SizedBox(height: AppSpacing.sm),
        ],
        TaskStatusBanner(task: task, submission: submission),
        if (showProgress) ...[
          SizedBox(height: AppSpacing.md),
          TaskProgressTimeline(status: task.submissionStatus, submission: submission),
        ],
        if (task.attachments.isNotEmpty) ...[
          SizedBox(height: AppSpacing.md),
          TaskSectionTitle(title: l10n.taskAttachmentsTitle),
          for (final attachment in task.attachments) ...[
            SizedBox(height: AppSpacing.xs),
            TaskFileTile(
              fileName: attachment.fileName,
              sizeBytes: attachment.sizeBytes,
              isImage: attachment.isImage,
              onTap: () => cubit.openAttachment(attachment),
            ),
          ],
        ],
        if (submission != null) ...[
          SizedBox(height: AppSpacing.md),
          TaskSubmissionSummary(submission: submission, onOpenFile: cubit.openSubmissionFile),
        ],
      ],
    );
  }
}

class _EventLink extends StatelessWidget {
  const _EventLink({required this.title, required this.onTap});

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme.primary;

    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.smRadius,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.xxs),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.labelLarge?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(
                context.isRTL ? LucideIcons.chevronLeft : LucideIcons.chevronRight,
                size: AppSizes.iconSm,
                color: color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
