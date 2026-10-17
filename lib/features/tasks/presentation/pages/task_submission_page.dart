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
import '../../../../l10n/app_localizations.dart';
import '../../domain/repositories/tasks_repository.dart';
import '../cubit/task_submission/task_submission_cubit.dart';
import '../cubit/task_submission/task_submission_state.dart';
import '../widgets/form/task_form_field.dart';
import '../widgets/form/task_form_progress.dart';
import '../widgets/form/task_form_skeleton.dart';
import '../widgets/shared/task_status_visual.dart';
import '../../../../core/shared/widgets/app_bottom_safe_area.dart';

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

  Future<void> _confirmDiscard(BuildContext context) async {
    final l10n = context.l10n;
    final navigator = Navigator.of(context);
    final discard = await AppDialog.confirm(
      context,
      title: l10n.discardChangesTitle,
      message: l10n.discardChangesMessage,
      confirmText: l10n.discardButton,
      cancelText: l10n.cancelButton,
      isDestructive: true,
    );
    if (discard) navigator.pop();
  }

  String? _blockedReason(AppLocalizations l10n, VerificationForm form) {
    if (form.canSubmit) return null;
    final status = form.submissionStatus;
    if (status == null) return l10n.taskNotAssigned;
    return TaskStatusVisual.of(status, isOverdue: false).label(l10n);
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
    final hint = form == null
        ? null
        : _blockedReason(l10n, form) ??
              (state.requiredLeft > 0 ? l10n.taskRequiredLeft(state.requiredLeft) : null);

    return BlocListener<TaskSubmissionCubit, TaskSubmissionState>(
      listenWhen: (previous, current) =>
          current.feedback != null && previous.feedback != current.feedback,
      listener: (context, state) => _onFeedback(context, state.feedback!),
      child: PopScope(
        canPop: !state.hasAnswers && !state.isSubmitting,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop && !state.isSubmitting) _confirmDiscard(context);
        },
        child: AppLoadingOverlay(
          isLoading: state.isSubmitting,
          child: Scaffold(
            appBar: AppAppBar(
              title: l10n.taskSubmitProof,
              onBack: () => Navigator.of(context).maybePop(),
            ),
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
                ? AppBottomSafeArea(
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
                          if (hint != null) ...[
                            Text(
                              hint,
                              textAlign: TextAlign.center,
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
      ),
    );
  }
}
