import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_assets.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/shared/widgets/app_app_bar.dart';
import '../../../../core/shared/widgets/app_empty_widget.dart';
import '../../../../core/shared/widgets/app_error_widget.dart';
import '../../../../core/shared/widgets/app_refresh_indicator.dart';
import '../cubit/tasks_list/tasks_list_cubit.dart';
import '../cubit/tasks_list/tasks_list_state.dart';
import '../widgets/list/task_list_skeleton.dart';
import '../widgets/list/tasks_list_body.dart';
import '../widgets/shared/task_fill_viewport.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key, this.eventId});

  final String? eventId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TasksListCubit>(param1: eventId)..load(),
      child: _TasksView(isEventTasks: eventId != null),
    );
  }
}

class _TasksView extends StatelessWidget {
  const _TasksView({required this.isEventTasks});

  final bool isEventTasks;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TasksListCubit>().state;
    final cubit = context.read<TasksListCubit>();
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppAppBar(
        title: isEventTasks ? l10n.tasksEventTitle : l10n.tasksMyTitle,
        onBack: () => context.pop(),
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: AppRefreshIndicator(
          onRefresh: cubit.refresh,
          child: switch (state.status) {
            TasksListStatus.initial || TasksListStatus.loading => const TaskListSkeleton(),
            TasksListStatus.failure => TaskFillViewport(
              child: AppErrorWidget(
                message: state.errorMessage ?? l10n.somethingWentWrong,
                onRetry: cubit.load,
              ),
            ),
            TasksListStatus.success when state.items.isEmpty => TaskFillViewport(
              child: AppEmptyWidget(
                asset: AppAssets.illustrationTasks,
                message: l10n.tasksEmptyMessage,
              ),
            ),
            TasksListStatus.success => TasksListBody(state: state, showEvent: !isEventTasks),
          },
        ),
      ),
    );
  }
}
