import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/shared/widgets/app_button.dart';
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

class TaskFormField extends StatelessWidget {
  const TaskFormField({
    super.key,
    required this.field,
    required this.answer,
    required this.issue,
    required this.maxFileBytes,
  });

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
    final l10n = context.l10n;
    final colors = context.colorScheme;
    final isArabic = context.isArabic;
    final hasError = issue != null;
    final description = field.description(isArabic)?.trim() ?? '';
    final issueText = _issueText(l10n);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: AppFieldLabel(label: field.label(isArabic), hasError: hasError),
            ),
            if (!field.isRequired)
              Text(
                l10n.taskOptional,
                style: context.textTheme.labelSmall?.copyWith(color: colors.onSurfaceVariant),
              ),
          ],
        ),
        if (description.isNotEmpty) ...[
          SizedBox(height: AppSpacing.xxs),
          Text(
            description,
            style: context.textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
          ),
        ],
        SizedBox(height: AppSpacing.xs),
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
          ),
        },
        if (issueText != null) ...[
          SizedBox(height: AppSpacing.xxs),
          Text(issueText, style: context.textTheme.bodySmall?.copyWith(color: colors.error)),
        ],
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
            isSelected: value == true,
            hasError: hasError,
            onTap: () => cubit.setYesNo(field.id, true),
          ),
        ),
        SizedBox(width: AppSpacing.xs),
        Expanded(
          child: _OptionTile(
            label: l10n.noLabel,
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
        for (var i = 0; i < field.options.length; i++) ...[
          if (i > 0) SizedBox(height: AppSpacing.xs),
          _OptionTile(
            label: field.options[i].label(context.isArabic),
            isSelected: selected.contains(field.options[i].id),
            hasError: hasError,
            icon: isMultiple
                ? (selected.contains(field.options[i].id)
                      ? LucideIcons.squareCheck
                      : LucideIcons.square)
                : (selected.contains(field.options[i].id)
                      ? LucideIcons.circleDot
                      : LucideIcons.circle),
            onTap: () => cubit.toggleOption(field, field.options[i].id),
          ),
        ],
      ],
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.label,
    required this.isSelected,
    required this.hasError,
    required this.onTap,
    this.icon,
  });

  final String label;
  final bool isSelected;
  final bool hasError;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final icon = this.icon;
    final borderColor = isSelected
        ? colors.primary
        : hasError
        ? colors.error
        : colors.outlineVariant;

    return Semantics(
      button: true,
      selected: isSelected,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.mdRadius,
        child: Container(
          constraints: BoxConstraints(minHeight: AppSizes.buttonHeight),
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
          decoration: BoxDecoration(
            color: isSelected ? colors.primaryContainer : null,
            border: Border.all(color: borderColor),
            borderRadius: AppRadius.mdRadius,
          ),
          child: Row(
            mainAxisAlignment: icon == null ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: AppSizes.iconField,
                  color: isSelected ? colors.primary : colors.onSurfaceVariant,
                ),
                SizedBox(width: AppSpacing.xs),
              ],
              Flexible(
                child: Text(
                  label,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: isSelected ? colors.onPrimaryContainer : colors.onSurface,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilesInput extends StatelessWidget {
  const _FilesInput({required this.field, required this.files});

  static const _picker = TaskFilePicker();
  static const _imageExtensions = ['jpg', 'jpeg', 'png', 'webp'];

  final VerificationField field;
  final List<PickedTaskFile> files;

  Future<void> _addPhotos(BuildContext context) async {
    final cubit = context.read<TaskSubmissionCubit>();
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(LucideIcons.camera),
              title: Text(context.l10n.taskTakePhoto),
              onTap: () => Navigator.of(sheetContext).pop(ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(LucideIcons.images),
              title: Text(context.l10n.taskChooseFromGallery),
              onTap: () => Navigator.of(sheetContext).pop(ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;
    cubit.addFiles(field.id, await _picker.pickImages(source));
  }

  Future<void> _addDocuments(BuildContext context) async {
    final cubit = context.read<TaskSubmissionCubit>();
    cubit.addFiles(field.id, await _picker.pickDocuments(field.acceptedExtensions));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<TaskSubmissionCubit>();
    final maxFiles = field.maxFiles;
    final canAdd = maxFiles == null || files.length < maxFiles;
    final isFileField = field.type == VerificationFieldType.file;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final file in files) ...[
          TaskFileTile(
            fileName: file.name,
            sizeBytes: file.sizeBytes,
            isImage: !isFileField || _imageExtensions.contains(file.extension),
            onRemove: () => cubit.removeFile(field.id, file),
          ),
          SizedBox(height: AppSpacing.xs),
        ],
        if (canAdd)
          Row(
            children: [
              Expanded(
                child: AppButton.secondary(
                  label: l10n.taskAddPhoto,
                  onPressed: () => _addPhotos(context),
                ),
              ),
              if (isFileField) ...[
                SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: AppButton.secondary(
                    label: l10n.taskAddFile,
                    onPressed: () => _addDocuments(context),
                  ),
                ),
              ],
            ],
          ),
        if (maxFiles != null) ...[
          SizedBox(height: AppSpacing.xxs),
          Text(
            l10n.taskFilesCount(files.length, maxFiles),
            style: context.textTheme.labelSmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}
