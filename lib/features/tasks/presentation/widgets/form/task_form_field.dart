import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/shared/widgets/app_text_field.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../domain/repositories/tasks_repository.dart';
import '../../cubit/task_submission/task_submission_cubit.dart';
import '../../cubit/task_submission/task_submission_state.dart';
import '../shared/task_file_tile.dart';
import '../shared/task_formatters.dart';
import 'task_file_picker.dart';
import 'task_image_thumbnail.dart';
import 'task_pick_source_sheet.dart';
import 'task_upload_zone.dart';

class TaskFormField extends StatelessWidget {
  const TaskFormField({
    super.key,
    required this.number,
    required this.field,
    required this.answer,
    required this.issue,
    required this.maxFileBytes,
  });

  final int number;
  final VerificationField field;
  final TaskAnswer? answer;
  final TaskFieldIssue? issue;
  final int maxFileBytes;

  String? _issueText(AppLocalizations l10n) {
    final issue = this.issue;
    if (issue == null) return null;
    return switch (issue.kind) {
      TaskFieldIssueKind.required => l10n.fieldRequiredError,
      TaskFieldIssueKind.tooLong => l10n.taskIssueTooLong,
      TaskFieldIssueKind.tooManyFiles => l10n.taskIssueTooManyFiles,
      TaskFieldIssueKind.fileTooLarge => l10n.taskIssueFileTooLarge(
        TaskFormatters.megabytes(maxFileBytes),
      ),
      TaskFieldIssueKind.unsupportedFile => l10n.taskIssueUnsupportedFile,
      TaskFieldIssueKind.server => issue.message ?? l10n.fieldRequiredError,
    };
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final isArabic = context.isArabic;
    final hasError = issue != null;
    final description = field.description(isArabic)?.trim() ?? '';
    final issueText = _issueText(context.l10n);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _QuestionHeader(
          number: number,
          label: field.label(isArabic),
          isRequired: field.isRequired,
          hasError: hasError,
        ),
        if (description.isNotEmpty) ...[
          SizedBox(height: AppSpacing.xxs),
          Padding(
            padding: EdgeInsetsDirectional.only(start: AppSizes.iconMd + AppSpacing.xs),
            child: Text(
              description,
              style: context.textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
            ),
          ),
        ],
        SizedBox(height: AppSpacing.sm),
        switch (field.type) {
          VerificationFieldType.text || VerificationFieldType.longText => _TextInput(
            field: field,
            initialText: switch (answer) {
              TextAnswer(:final text) => text,
              _ => '',
            },
            hasError: hasError,
          ),
          VerificationFieldType.yesNo => _YesNoInput(
            field: field,
            value: switch (answer) {
              YesNoAnswer(:final value) => value,
              _ => null,
            },
            hasError: hasError,
          ),
          VerificationFieldType.singleChoice ||
          VerificationFieldType.multipleChoice => _ChoiceInput(
            field: field,
            selected: switch (answer) {
              ChoiceAnswer(:final optionIds) => optionIds,
              _ => const {},
            },
            hasError: hasError,
          ),
          VerificationFieldType.image || VerificationFieldType.file => _FilesInput(
            field: field,
            files: switch (answer) {
              FilesAnswer(:final files) => files,
              _ => const [],
            },
            maxFileBytes: maxFileBytes,
            hasError: hasError,
          ),
        },
        if (issueText != null) ...[
          SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Icon(LucideIcons.circleAlert, size: AppSizes.iconSm, color: colors.error),
              SizedBox(width: AppSpacing.xxs),
              Expanded(
                child: Text(
                  issueText,
                  style: context.textTheme.bodySmall?.copyWith(color: colors.error),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _QuestionHeader extends StatelessWidget {
  const _QuestionHeader({
    required this.number,
    required this.label,
    required this.isRequired,
    required this.hasError,
  });

  final int number;
  final String label;
  final bool isRequired;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final color = hasError ? colors.error : colors.primary;
    final labelStyle = context.textTheme.titleSmall?.copyWith(
      fontWeight: FontWeight.bold,
      color: hasError ? colors.error : colors.onSurface,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: SizedBox.square(
            dimension: AppSizes.iconMd,
            child: Center(
              child: Text(
                '$number',
                style: context.textTheme.labelMedium?.copyWith(
                  color: hasError ? colors.onError : colors.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text.rich(
            TextSpan(
              text: label,
              children: [
                if (isRequired)
                  TextSpan(
                    text: ' *',
                    style: TextStyle(color: colors.error),
                  ),
              ],
            ),
            style: labelStyle,
          ),
        ),
      ],
    );
  }
}

class _TextInput extends StatefulWidget {
  const _TextInput({required this.field, required this.initialText, required this.hasError});

  final VerificationField field;
  final String initialText;
  final bool hasError;

  @override
  State<_TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<_TextInput> {
  static const _longTextLines = 4;

  late final _controller = TextEditingController(text: widget.initialText);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLong = widget.field.type == VerificationFieldType.longText;

    return AppTextField(
      label: '',
      controller: _controller,
      hasError: widget.hasError,
      maxLines: isLong ? _longTextLines : 1,
      minLines: isLong ? _longTextLines : null,
      maxLength: widget.field.maxLength,
      textInputAction: isLong ? TextInputAction.newline : TextInputAction.next,
      keyboardType: isLong ? TextInputType.multiline : TextInputType.text,
      onChanged: (value) => context.read<TaskSubmissionCubit>().setText(widget.field.id, value),
    );
  }
}

class _YesNoInput extends StatelessWidget {
  const _YesNoInput({required this.field, required this.value, required this.hasError});

  final VerificationField field;
  final bool? value;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<TaskSubmissionCubit>();

    return Row(
      children: [
        Expanded(
          child: _OptionTile(
            label: l10n.yesLabel,
            icon: LucideIcons.thumbsUp,
            isSelected: value == true,
            hasError: hasError,
            onTap: () => cubit.setYesNo(field.id, true),
          ),
        ),
        SizedBox(width: AppSpacing.xs),
        Expanded(
          child: _OptionTile(
            label: l10n.noLabel,
            icon: LucideIcons.thumbsDown,
            isSelected: value == false,
            hasError: hasError,
            onTap: () => cubit.setYesNo(field.id, false),
          ),
        ),
      ],
    );
  }
}

class _ChoiceInput extends StatelessWidget {
  const _ChoiceInput({required this.field, required this.selected, required this.hasError});

  final VerificationField field;
  final Set<String> selected;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TaskSubmissionCubit>();
    final isMultiple = field.type == VerificationFieldType.multipleChoice;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final option in field.options) ...[
          if (option != field.options.first) SizedBox(height: AppSpacing.xs),
          Builder(
            builder: (context) {
              final isSelected = selected.contains(option.id);
              return _OptionTile(
                label: option.label(context.isArabic),
                isSelected: isSelected,
                hasError: hasError,
                isLeading: true,
                icon: switch ((isMultiple, isSelected)) {
                  (true, true) => LucideIcons.squareCheck,
                  (true, false) => LucideIcons.square,
                  (false, true) => LucideIcons.circleDot,
                  (false, false) => LucideIcons.circle,
                },
                onTap: () => cubit.toggleOption(field, option.id),
              );
            },
          ),
        ],
      ],
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.hasError,
    required this.onTap,
    this.isLeading = false,
  });

  static const _duration = Duration(milliseconds: 150);

  final String label;
  final IconData icon;
  final bool isSelected;
  final bool hasError;
  final bool isLeading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final borderColor = isSelected
        ? colors.primary
        : hasError
        ? colors.error
        : Colors.transparent;
    final contentColor = isSelected ? colors.onPrimary : colors.onSurface;

    return Semantics(
      button: true,
      selected: isSelected,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.mdRadius,
          child: AnimatedContainer(
            duration: _duration,
            constraints: BoxConstraints(minHeight: AppSizes.buttonHeight),
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
            decoration: BoxDecoration(
              color: isSelected ? colors.primary : colors.surface,
              border: Border.all(color: borderColor),
              borderRadius: AppRadius.mdRadius,
            ),
            child: Row(
              mainAxisAlignment: isLeading ? MainAxisAlignment.start : MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: AppSizes.iconField,
                  color: isSelected ? colors.onPrimary : colors.onSurfaceVariant,
                ),
                SizedBox(width: AppSpacing.xs),
                Flexible(
                  child: Text(
                    label,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: contentColor,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FilesInput extends StatelessWidget {
  const _FilesInput({
    required this.field,
    required this.files,
    required this.maxFileBytes,
    required this.hasError,
  });

  static const _picker = TaskFilePicker();
  static const _imageExtensions = ['jpg', 'jpeg', 'png', 'webp'];
  static const _gridColumns = 3;

  final VerificationField field;
  final List<PickedTaskFile> files;
  final int maxFileBytes;
  final bool hasError;

  bool get _isFileField => field.type == VerificationFieldType.file;

  Future<void> _add(BuildContext context) async {
    final cubit = context.read<TaskSubmissionCubit>();
    final source = await TaskPickSourceSheet.show(context, allowDocuments: _isFileField);
    final picked = switch (source) {
      null => const <PickedTaskFile>[],
      TaskPickSource.camera => await _picker.pickImages(ImageSource.camera),
      TaskPickSource.gallery => await _picker.pickImages(ImageSource.gallery),
      TaskPickSource.document => await _picker.pickDocuments(field.acceptedExtensions),
    };
    cubit.addFiles(field.id, picked);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<TaskSubmissionCubit>();
    final maxFiles = field.maxFiles;
    final canAdd = maxFiles == null || files.length < maxFiles;
    final images = files.where((file) => _imageExtensions.contains(file.extension)).toList();
    final documents = files.where((file) => !images.contains(file)).toList();
    final types = field.acceptedExtensions.map((extension) => extension.toUpperCase()).join(', ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (images.isNotEmpty) ...[
          GridView.count(
            crossAxisCount: _gridColumns,
            mainAxisSpacing: AppSpacing.xs,
            crossAxisSpacing: AppSpacing.xs,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              for (final image in images)
                TaskImageThumbnail(
                  key: ValueKey(image.path),
                  path: image.path,
                  onRemove: () => cubit.removeFile(field.id, image),
                ),
            ],
          ),
          SizedBox(height: AppSpacing.xs),
        ],
        for (final document in documents) ...[
          TaskFileTile(
            fileName: document.name,
            sizeBytes: document.sizeBytes,
            isImage: false,
            onRemove: () => cubit.removeFile(field.id, document),
          ),
          SizedBox(height: AppSpacing.xs),
        ],
        if (canAdd)
          TaskUploadZone(
            icon: _isFileField ? LucideIcons.filePlus : LucideIcons.imagePlus,
            title: _isFileField ? l10n.taskUploadFiles : l10n.taskUploadPhotos,
            hint: l10n.taskUploadHint(types, TaskFormatters.megabytes(maxFileBytes)),
            hasError: hasError,
            onTap: () => _add(context),
          ),
        if (maxFiles != null) ...[
          SizedBox(height: AppSpacing.xxs),
          Text(
            l10n.taskFilesCount(files.length, maxFiles),
            textAlign: TextAlign.end,
            style: context.textTheme.labelSmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}
