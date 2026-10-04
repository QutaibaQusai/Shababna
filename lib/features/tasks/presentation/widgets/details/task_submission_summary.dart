import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/repositories/tasks_repository.dart';
import '../shared/task_file_tile.dart';
import '../shared/task_formatters.dart';
import '../shared/task_key_value_row.dart';
import '../shared/task_section_title.dart';
import '../shared/task_status_label.dart';

class TaskSubmissionSummary extends StatelessWidget {
  const TaskSubmissionSummary({
    super.key,
    required this.submission,
    required this.busyFileId,
    required this.onOpenFile,
  });

  final TaskSubmission submission;
  final String? busyFileId;
  final ValueChanged<SubmittedFile> onOpenFile;

  String _answerText(BuildContext context, SubmittedAnswer answer) {
    final l10n = context.l10n;
    final isArabic = context.isArabic;
    final separator = isArabic ? '، ' : ', ';
    final yesNo = answer.yesNo;
    return switch (answer.type) {
      VerificationFieldType.yesNo => yesNo == null ? '' : (yesNo ? l10n.yesLabel : l10n.noLabel),
      VerificationFieldType.singleChoice || VerificationFieldType.multipleChoice =>
        answer.options.map((option) => option.label(isArabic)).join(separator),
      _ => answer.text ?? '',
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colorScheme;
    final creditedHours = submission.creditedHours;
    final reason = submission.rejectionReason?.trim() ?? '';
    final rows = [
      (l10n.taskSubmittedOnLabel, TaskFormatters.date(context, submission.submittedAt), null),
      if (creditedHours != null)
        (l10n.taskCreditedHoursLabel, TaskFormatters.hours(context, creditedHours), null),
      if (submission.status == TaskSubmissionStatus.rejected && reason.isNotEmpty)
        (l10n.taskRejectionReasonLabel, reason, colors.error),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: TaskSectionTitle(title: l10n.taskSubmissionTitle)),
            TaskStatusLabel(status: submission.status),
          ],
        ),
        for (final (label, value, color) in rows) ...[
          SizedBox(height: AppSpacing.sm),
          TaskKeyValueRow(label: label, value: value, valueColor: color),
        ],
        for (final answer in submission.answers) ...[
          SizedBox(height: AppSpacing.sm),
          if (answer.type.isUpload) ...[
            Text(
              answer.label(context.isArabic),
              style: context.textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
            ),
            for (final file in answer.files) ...[
              SizedBox(height: AppSpacing.xs),
              TaskFileTile(
                fileName: file.fileName,
                sizeBytes: file.sizeBytes,
                isImage: file.contentType.startsWith('image/'),
                isBusy: busyFileId == file.id,
                onTap: () => onOpenFile(file),
              ),
            ],
          ] else
            TaskKeyValueRow(
              label: answer.label(context.isArabic),
              value: _answerText(context, answer),
            ),
        ],
      ],
    );
  }
}
