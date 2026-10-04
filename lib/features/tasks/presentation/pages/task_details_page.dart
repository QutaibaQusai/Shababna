import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/shared/widgets/app_app_bar.dart';
import '../../../../core/shared/widgets/app_error_widget.dart';
import '../../../../core/shared/widgets/app_toast.dart';
import '../cubit/task_details/task_details_cubit.dart';
import '../widgets/details/task_action_bar.dart';
import '../widgets/details/task_details_content.dart';
import '../widgets/shared/task_fill_viewport.dart';

class TaskDetailsPage extends StatelessWidget {
  const TaskDetailsPage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TaskDetailsCubit>(param1: id)..load(),
      child: const _TaskDetailsView(),
    );
  }
}

class _TaskDetailsView extends StatelessWidget {
  const _TaskDetailsView();

  Future<void> _onFileFeedback(BuildContext context, TaskFileFeedback feedback) async {
    switch (feedback) {
      case TaskFileReady(:final path):
        await SharePlus.instance.share(ShareParams(files: [XFile(path)]));
      case TaskFileFailed(:final message):
        AppToast.error(context, message ?? context.l10n.taskOpenFileFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TaskDetailsCubit>().state;
    final cubit = context.read<TaskDetailsCubit>();

    return BlocListener<TaskDetailsCubit, TaskDetailsState>(
      listenWhen: (previous, current) =>
          current.fileFeedback != null && previous.fileFeedback != current.fileFeedback,
      listener: (context, state) => _onFileFeedback(context, state.fileFeedback!),
      child: Scaffold(
        appBar: AppAppBar(title: context.l10n.taskDetailsTitle, onBack: () => context.pop()),
        body: switch (state) {
          TaskDetailsState(task: _?) => TaskDetailsContent(state: state),
          TaskDetailsState(hasError: true) => TaskFillViewport(
            child: AppErrorWidget(
              message: state.errorMessage ?? context.l10n.somethingWentWrong,
              onRetry: cubit.load,
            ),
          ),
          _ => Skeletonizer(
            enabled: true,
            child: IgnorePointer(
              child: TaskDetailsContent(
                state: TaskDetailsState(task: TaskDetailsSkeletonData.placeholder),
              ),
            ),
          ),
        },
        bottomNavigationBar: const TaskActionBar(),
      ),
    );
  }
}
