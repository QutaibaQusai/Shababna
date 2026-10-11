import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/config/app_assets.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/shared/widgets/app_empty_widget.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/repositories/tasks_repository.dart';
import '../../../domain/task_grouping.dart';
import '../../cubit/tasks_list/tasks_list_cubit.dart';
import '../../cubit/tasks_list/tasks_list_state.dart';
import 'task_card.dart';
import 'task_group_header.dart';
import 'task_tabs.dart';
import 'tasks_summary_header.dart';

class TasksListBody extends StatelessWidget {
  const TasksListBody({super.key, required this.state, required this.showVolunteeringOpportunity});

  final TasksListState state;
  final bool showVolunteeringOpportunity;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TasksListCubit>();
    final visible = state.visible;
    final margin = AppSpacing.screenMargin;

    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(margin, margin, margin, 0),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TasksSummaryHeader(
                  completed: state.completedCount,
                  total: state.items.length,
                  earnedHours: state.earnedHours,
                  waitingReview: state.countOf(TaskTab.inReview),
                ),
                SizedBox(height: AppSpacing.sm),
                TaskTabs(selected: state.tab, countOf: state.countOf, onSelected: cubit.selectTab),
              ],
            ),
          ),
        ),
        if (visible.isEmpty)
          SliverFillRemaining(hasScrollBody: false, child: _EmptyState(tab: state.tab))
        else
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              margin,
              margin,
              margin,
              margin + MediaQuery.paddingOf(context).bottom,
            ),
            sliver: SliverList.list(
              children: state.tab == TaskTab.todo
                  ? _grouped(visible, cubit)
                  : _flat(visible, cubit),
            ),
          ),
      ],
    );
  }

  List<Widget> _flat(List<TaskSummary> tasks, TasksListCubit cubit) => [
    for (var i = 0; i < tasks.length; i++) ...[
      if (i > 0) SizedBox(height: AppSpacing.xs),
      TaskCard(
        key: ValueKey(tasks[i].id),
        task: tasks[i],
        onReturn: cubit.reload,
        showVolunteeringOpportunity: showVolunteeringOpportunity,
      ),
    ],
  ];

  List<Widget> _grouped(List<TaskSummary> tasks, TasksListCubit cubit) {
    final now = DateTime.now();
    final groups = <TaskDueWindow, List<TaskSummary>>{};
    for (final task in tasks) {
      groups.putIfAbsent(TaskDueWindow.of(task.dueAt, now), () => []).add(task);
    }

    final windows = TaskDueWindow.values.where(groups.containsKey).toList();

    return [
      for (var i = 0; i < windows.length; i++) ...[
        if (i > 0) SizedBox(height: AppSpacing.md),
        TaskGroupHeader(window: windows[i], count: groups[windows[i]]!.length),
        SizedBox(height: AppSpacing.xs),
        ..._flat(groups[windows[i]]!, cubit),
      ],
    ];
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.tab});

  final TaskTab tab;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final (asset, message) = switch (tab) {
      TaskTab.all => (AppAssets.illustrationTasks, l10n.tasksEmptyMessage),
      TaskTab.todo => (AppAssets.illustrationTasksDone, l10n.tasksEmptyTodo),
      TaskTab.inReview => (AppAssets.illustrationTasksReview, l10n.tasksEmptyInReview),
      TaskTab.completed => (AppAssets.illustrationTasksCompleted, l10n.tasksEmptyCompleted),
    };

    return AppEmptyWidget(asset: asset, message: message);
  }
}
