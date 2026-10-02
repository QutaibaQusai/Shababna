import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/shared/widgets/app_empty_widget.dart';
import '../../../../core/shared/widgets/app_error_widget.dart';
import '../../../../core/shared/widgets/app_refresh_indicator.dart';
import '../cubit/events_list/events_list_cubit.dart';
import '../cubit/events_list/events_list_state.dart';
import '../widgets/events_list/events_list_content.dart';
import '../widgets/events_list/events_list_skeleton.dart';
import '../widgets/shared/event_fill_viewport.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<EventsListCubit>()..loadFirstPage(),
      child: const _EventsView(),
    );
  }
}

class _EventsView extends StatelessWidget {
  const _EventsView();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<EventsListCubit>().state;
    final cubit = context.read<EventsListCubit>();

    return AppRefreshIndicator(
      onRefresh: cubit.refresh,
      child: switch (state.status) {
        EventsListStatus.initial || EventsListStatus.loading => const EventsListSkeleton(),
        EventsListStatus.failure => EventFillViewport(
            child: AppErrorWidget(
              message: state.errorMessage ?? context.l10n.somethingWentWrong,
              onRetry: cubit.loadFirstPage,
            ),
          ),
        EventsListStatus.success when state.items.isEmpty => EventFillViewport(
            child: AppEmptyWidget(message: context.l10n.eventsEmptyMessage),
          ),
        EventsListStatus.success => EventsListContent(state: state),
      },
    );
  }
}
