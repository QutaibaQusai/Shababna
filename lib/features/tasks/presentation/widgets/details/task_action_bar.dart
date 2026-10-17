import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/session/auth_session_cubit.dart';
import '../../../../../core/shared/widgets/app_button.dart';
import '../../../../../core/shared/widgets/guest_gate.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/repositories/tasks_repository.dart';
import '../../cubit/task_details/task_details_cubit.dart';
import '../../../../../core/shared/widgets/app_bottom_safe_area.dart';

class TaskActionBar extends StatelessWidget {
  const TaskActionBar({super.key});

  Future<void> _openForm(BuildContext context, String taskId) async {
    final cubit = context.read<TaskDetailsCubit>();
    final submitted = await context.push<bool>(AppRoutes.taskSubmitPath(taskId));
    if (submitted == true) await cubit.reloadAfterSubmit();
  }

  @override
  Widget build(BuildContext context) {
    final task = context.select((TaskDetailsCubit cubit) => cubit.state.task);
    final isAuthenticated = context.select((AuthSessionCubit cubit) => cubit.state.isAuthenticated);
    final l10n = context.l10n;

    final button = switch ((task, isAuthenticated)) {
      (null, _) => null,
      (_, false) => AppButton.primary(
        label: l10n.taskSignInToSubmit,
        onPressed: () => ensureSignedIn(context),
      ),
      (final task?, true) when task.canSubmit => AppButton.primary(
        label: task.submissionStatus == TaskSubmissionStatus.rejected
            ? l10n.taskSubmitAgain
            : l10n.taskSubmitProof,
        onPressed: () => _openForm(context, task.id),
      ),
      _ => null,
    };
    if (button == null) return const SizedBox.shrink();

    return Material(
      color: context.colorScheme.surface,
      child: AppBottomSafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.screenMargin,
            AppSpacing.sm,
            AppSpacing.screenMargin,
            AppSpacing.md,
          ),
          child: button,
        ),
      ),
    );
  }
}
