import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/session/auth_session_cubit.dart';
import '../../../../../core/shared/widgets/app_button.dart';
import '../../../../../core/shared/widgets/guest_gate.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/repositories/tasks_repository.dart';
import '../../cubit/task_details/task_details_cubit.dart';
import '../shared/task_status_label.dart';

class TaskActionBar extends StatelessWidget {
  const TaskActionBar({super.key});

  Future<void> _openForm(BuildContext context, String taskId) async {
    final cubit = context.read<TaskDetailsCubit>();
    final submitted = await context.push<bool>(AppRoutes.taskSubmitPath(taskId));
    if (submitted == true) await cubit.load();
  }

  @override
  Widget build(BuildContext context) {
    final task = context.select((TaskDetailsCubit cubit) => cubit.state.task);
    final isAuthenticated = context.select((AuthSessionCubit cubit) => cubit.state.isAuthenticated);
    if (task == null) return const SizedBox.shrink();

    final l10n = context.l10n;

    return Material(
      color: context.colorScheme.surface,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.screenMargin,
            AppSpacing.sm,
            AppSpacing.screenMargin,
            AppSpacing.md,
          ),
          child: switch ((isAuthenticated, task.isAssignedToMe, task.canSubmit)) {
            (false, _, _) => AppButton.primary(
              label: l10n.taskSignInToSubmit,
              onPressed: () => ensureSignedIn(context),
            ),
            (true, false, _) => _StatusStrip(text: l10n.taskNotAssigned),
            (true, true, true) => AppButton.primary(
              label: task.submissionStatus == TaskSubmissionStatus.rejected
                  ? l10n.taskSubmitAgain
                  : l10n.taskSubmitProof,
              onPressed: () => _openForm(context, task.id),
            ),
            (true, true, false) => _StatusStrip(
              text: TaskStatusLabel.text(l10n, task.submissionStatus),
            ),
          },
        ),
      ),
    );
  }
}

class _StatusStrip extends StatelessWidget {
  const _StatusStrip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;

    return Container(
      height: AppSizes.buttonHeight,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(color: colors.primary, borderRadius: AppRadius.mdRadius),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.textTheme.titleSmall?.copyWith(
          color: colors.onPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
