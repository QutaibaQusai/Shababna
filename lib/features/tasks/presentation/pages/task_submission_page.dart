import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/shared/widgets/app_app_bar.dart';
import '../../../../core/shared/widgets/app_button.dart';
import '../../../../core/shared/widgets/app_dialog.dart';
import '../../../../core/shared/widgets/app_error_widget.dart';
import '../../../../core/shared/widgets/app_loading_overlay.dart';
import '../../../../core/shared/widgets/app_toast.dart';
import '../../../../core/theme/app_spacing.dart';
import '../cubit/task_submission/task_submission_cubit.dart';
import '../cubit/task_submission/task_submission_state.dart';
import '../widgets/form/task_form_field.dart';
import '../widgets/form/task_form_progress.dart';
import '../widgets/form/task_form_skeleton.dart';

class TaskSubmissionPage extends StatelessWidget {
  const TaskSubmissionPage({super.key, required this.taskId});

  final String taskId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TaskSubmissionCubit>(param1: taskId)..load(),
      child: const _TaskSubmissionView(),
    );
  }
}

class _TaskSubmissionView extends StatelessWidget {
  const _TaskSubmissionView();

  void _onFeedback(BuildContext context, TaskSubmissionFeedback feedback) {
    final l10n = context.l10n;
    switch (feedback) {
      case TaskSubmitted():
        AppToast.success(context, l10n.taskSubmittedMessage);
        context.pop(true);
      case TaskAlreadySubmitted():
        AppToast.info(context, l10n.taskAlreadySubmittedMessage);
        context.pop(true);
      case TaskFormChanged():
        AppToast.info(context, l10n.taskFormChangedMessage);
      case TaskFormInvalid():
        AppToast.error(context, l10n.taskFormInvalidMessage);
      case TaskTooManyFiles(:final limit):
        AppToast.error(context, l10n.taskTooManyFilesMessage(limit));
      case TaskSubmitFailed(:final message):
        AppToast.error(context, message ?? l10n.somethingWentWrong);
    }
  }

  Future<void> _confirmAndSubmit(BuildContext context) async {
    final cubit = context.read<TaskSubmissionCubit>();
    if (!cubit.validate()) return;
    final l10n = context.l10n;
    final confirmed = await AppDialog.confirm(
      context,
      title: l10n.taskConfirmTitle,
      message: l10n.taskConfirmMessage,
      confirmText: l10n.taskFormSubmit,
      cancelText: l10n.cancelButton,
    );
    if (confirmed) await cubit.submit();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TaskSubmissionCubit>().state;
    final cubit = context.read<TaskSubmissionCubit>();
    final l10n = context.l10n;
    final form = state.form;
    final isReady = state.status == TaskSubmissionLoadStatus.ready && form != null;

    return BlocListener<TaskSubmissionCubit, TaskSubmissionState>(
      listenWhen: (previous, current) =>
          current.feedback != null && previous.feedback != current.feedback,
      listener: (context, state) => _onFeedback(context, state.feedback!),
      child: AppLoadingOverlay(
        isLoading: state.isSubmitting,
        child: Scaffold(
          appBar: AppAppBar(title: l10n.taskSubmitProof, onBack: () => context.pop()),
          body: switch (state.status) {
            TaskSubmissionLoadStatus.failure => AppErrorWidget(
              message: state.errorMessage ?? l10n.somethingWentWrong,
              onRetry: cubit.load,
            ),
            _ when !isReady => const TaskFormSkeleton(),
            _ => ListView(
              padding: EdgeInsets.all(AppSpacing.screenMargin),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: [
                if (form.fields.isNotEmpty) ...[
                  TaskFormProgress(answered: state.answeredCount, total: state.totalCount),
                  SizedBox(height: AppSpacing.md),
                ],
                if (form.fields.isEmpty)
                  Text(
                    l10n.taskFormNoFields,
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                for (var i = 0; i < form.fields.length; i++) ...[
                  if (i > 0) SizedBox(height: AppSpacing.lg),
                  TaskFormField(
                    key: ValueKey(form.fields[i].id),
                    number: i + 1,
                    field: form.fields[i],
                    answer: state.answers[form.fields[i].id],
                    issue: state.issues[form.fields[i].id],
                    maxFileBytes: form.maxFileBytes,
                  ),
                ],
              ],
            ),
          },
          bottomNavigationBar: isReady
              ? SafeArea(
                  top: false,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.screenMargin,
                      AppSpacing.sm,
                      AppSpacing.screenMargin,
                      AppSpacing.md,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (state.requiredLeft > 0) ...[
                          Text(
                            l10n.taskRequiredLeft(state.requiredLeft),
                            style: context.textTheme.labelMedium?.copyWith(
                              color: context.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          SizedBox(height: AppSpacing.xs),
                        ],
                        AppButton.primary(
                          label: l10n.taskSubmitProof,
                          onPressed: form.canSubmit ? () => _confirmAndSubmit(context) : null,
                        ),
                      ],
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
