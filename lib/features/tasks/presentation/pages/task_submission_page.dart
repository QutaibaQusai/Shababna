import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/shared/widgets/app_app_bar.dart';
import '../../../../core/shared/widgets/app_button.dart';
import '../../../../core/shared/widgets/app_error_widget.dart';
import '../../../../core/shared/widgets/app_loading_overlay.dart';
import '../../../../core/shared/widgets/app_toast.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../cubit/task_submission/task_submission_cubit.dart';
import '../cubit/task_submission/task_submission_state.dart';
import '../widgets/form/task_form_field.dart';

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
            _ when !isReady => const _FormSkeleton(),
            _ => ListView(
              padding: EdgeInsets.all(AppSpacing.screenMargin),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              children: [
                if (form.fields.isEmpty)
                  Text(
                    l10n.taskFormNoFields,
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                for (var i = 0; i < form.fields.length; i++) ...[
                  if (i > 0) SizedBox(height: AppSpacing.md),
                  TaskFormField(
                    key: ValueKey(form.fields[i].id),
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
                    child: AppButton.primary(
                      label: l10n.taskFormSubmit,
                      onPressed: form.canSubmit ? cubit.submit : null,
                    ),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}

class _FormSkeleton extends StatelessWidget {
  const _FormSkeleton();

  static const _placeholderCount = 3;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(AppSpacing.screenMargin),
        children: [
          for (var i = 0; i < _placeholderCount; i++) ...[
            const Bone.text(words: 2),
            SizedBox(height: AppSpacing.xs),
            Bone(height: AppSpacing.xxl, borderRadius: AppRadius.mdRadius),
            SizedBox(height: AppSpacing.md),
          ],
        ],
      ),
    );
  }
}
