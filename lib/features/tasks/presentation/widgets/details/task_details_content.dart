import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/repositories/tasks_repository.dart';
import '../../cubit/task_details/task_details_cubit.dart';
import '../shared/task_file_tile.dart';
import '../shared/task_formatters.dart';
import '../shared/task_key_value_row.dart';
import '../shared/task_section_title.dart';
import 'task_description.dart';
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
    final rows = [
      (l10n.taskEventLabel, task.eventTitle(isArabic), null),
      (
        l10n.taskDueLabel,
        TaskFormatters.dueDate(context, task.dueAt),
        task.isOverdue ? context.colorScheme.error : null,
      ),
      (l10n.taskHoursLabel, TaskFormatters.hours(context, task.volunteeringHours), null),
    ];

    return ListView(
      padding: EdgeInsets.all(AppSpacing.screenMargin),
      children: [
        Text(
          task.name(isArabic),
          style: context.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        if (description.isNotEmpty) ...[
          SizedBox(height: AppSpacing.md),
          TaskSectionTitle(title: l10n.taskAboutTitle),
          SizedBox(height: AppSpacing.xs),
          TaskDescription(html: description),
        ],
        SizedBox(height: AppSpacing.md),
        TaskSectionTitle(title: l10n.taskInfoTitle),
        for (final (label, value, color) in rows) ...[
          SizedBox(height: AppSpacing.sm),
          TaskKeyValueRow(label: label, value: value, valueColor: color),
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
              isBusy: state.busyFileId == attachment.id,
              onTap: () => cubit.openAttachment(attachment),
            ),
          ],
        ],
        if (submission != null) ...[
          SizedBox(height: AppSpacing.md),
          TaskSubmissionSummary(
            submission: submission,
            busyFileId: state.busyFileId,
            onOpenFile: cubit.openSubmissionFile,
          ),
        ],
      ],
    );
  }
}

class TaskDetailsSkeletonData {
  TaskDetailsSkeletonData._();

  static final placeholder = TaskDetails(
    id: 'placeholder',
    eventId: 'placeholder',
    eventTitleEn: 'Community health awareness day',
    eventTitleAr: 'يوم التوعية الصحية المجتمعية',
    nameEn: 'Share photos from the awareness booth',
    nameAr: 'شارك صوراً من ركن التوعية',
    descriptionEn: '',
    descriptionAr: '',
    dueAt: DateTime(2026, 10, 20),
    volunteeringHours: 2,
    isAssignedToMe: true,
    attachments: const [],
    submissionStatus: null,
  );
}
