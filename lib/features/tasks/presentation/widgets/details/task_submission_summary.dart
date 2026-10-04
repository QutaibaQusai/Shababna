import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/repositories/tasks_repository.dart';
import '../shared/task_file_tile.dart';
import '../shared/task_formatters.dart';
import '../shared/task_section_title.dart';

class TaskSubmissionSummary extends StatelessWidget {
  const TaskSubmissionSummary({super.key, required this.submission, required this.onOpenFile});

  final TaskSubmission submission;
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
    final isArabic = context.isArabic;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TaskSectionTitle(title: l10n.taskSubmissionTitle),
        SizedBox(height: AppSpacing.xxs),
        Text(
          '${l10n.taskSubmittedOnLabel} · ${TaskFormatters.date(context, submission.submittedAt)}',
          style: context.textTheme.labelMedium?.copyWith(color: colors.onSurfaceVariant),
        ),
        for (final answer in submission.answers) ...[
          SizedBox(height: AppSpacing.sm),
          Text(
            answer.label(isArabic),
            style: context.textTheme.labelLarge?.copyWith(
              color: colors.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
          if (answer.type.isUpload)
            for (final file in answer.files) ...[
              if (file != answer.files.first) SizedBox(height: AppSpacing.xs),
              TaskFileTile(
                fileName: file.fileName,
                sizeBytes: file.sizeBytes,
                isImage: file.contentType.startsWith('image/'),
                onTap: () => onOpenFile(file),
              ),
            ]
          else
            DecoratedBox(
              decoration: BoxDecoration(color: colors.surface, borderRadius: AppRadius.mdRadius),
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.sm),
                child: Text(
                  _answerText(context, answer),
                  style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ),
        ],
      ],
    );
  }
}
