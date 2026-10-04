import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/shared/widgets/app_app_bar.dart';
import '../../../../core/shared/widgets/app_empty_widget.dart';
import '../../../../core/shared/widgets/app_error_widget.dart';
import '../../../../core/shared/widgets/app_refresh_indicator.dart';
import '../../../../core/theme/app_spacing.dart';
import '../cubit/tasks_list/tasks_list_cubit.dart';
import '../cubit/tasks_list/tasks_list_state.dart';
import '../widgets/list/task_card.dart';
import '../widgets/list/task_list_skeleton.dart';
import '../widgets/shared/task_fill_viewport.dart';
import '../widgets/shared/task_load_more_footer.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key, this.eventId});

  final String? eventId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TasksListCubit>(param1: eventId)..loadFirstPage(),
      child: Scaffold(
        appBar: AppAppBar(
          title: eventId == null ? context.l10n.tasksMyTitle : context.l10n.tasksEventTitle,
          onBack: () => context.pop(),
        ),
        body: const SafeArea(top: false, child: _TasksView()),
      ),
    );
  }
}

class _TasksView extends StatelessWidget {
  const _TasksView();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TasksListCubit>().state;
    final cubit = context.read<TasksListCubit>();

    return AppRefreshIndicator(
      onRefresh: cubit.refresh,
      child: switch (state.status) {
        TasksListStatus.initial || TasksListStatus.loading => const TaskListSkeleton(),
        TasksListStatus.failure => TaskFillViewport(
          child: AppErrorWidget(
            message: state.errorMessage ?? context.l10n.somethingWentWrong,
            onRetry: cubit.loadFirstPage,
          ),
        ),
        TasksListStatus.success when state.items.isEmpty => TaskFillViewport(
          child: AppEmptyWidget(message: context.l10n.tasksEmptyMessage),
        ),
        TasksListStatus.success => _TasksList(state: state),
      },
    );
  }
}

class _TasksList extends StatelessWidget {
  const _TasksList({required this.state});

  static const _loadMoreThreshold = 300.0;

  final TasksListState state;

  bool _onScroll(BuildContext context, ScrollNotification notification) {
    final metrics = notification.metrics;
    if (metrics.axis == Axis.vertical &&
        metrics.maxScrollExtent - metrics.pixels <= _loadMoreThreshold) {
      context.read<TasksListCubit>().loadMore();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final items = state.items;
    final cubit = context.read<TasksListCubit>();

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) => _onScroll(context, notification),
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(AppSpacing.screenMargin),
        itemCount: items.length + (state.hasNextPage ? 1 : 0),
        separatorBuilder: (_, _) => SizedBox(height: AppSpacing.sm),
        itemBuilder: (context, index) {
          if (index == items.length) {
            return TaskLoadMoreFooter(failed: state.loadMoreFailed, onRetry: cubit.retryLoadMore);
          }
          return TaskCard(task: items[index], onReturn: cubit.refresh);
        },
      ),
    );
  }
}
