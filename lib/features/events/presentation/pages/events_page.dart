import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/shared/widgets/app_empty_widget.dart';
import '../../../../core/shared/widgets/app_error_widget.dart';
import '../../../../core/shared/widgets/app_refresh_indicator.dart';
import '../cubit/event_types/event_types_cubit.dart';
import '../cubit/event_types/event_types_state.dart';
import '../cubit/events_list/events_list_cubit.dart';
import '../cubit/events_list/events_list_state.dart';
import '../widgets/events_list/event_type_tabs.dart';
import '../widgets/events_list/events_list_content.dart';
import '../widgets/events_list/events_list_skeleton.dart';
import '../widgets/shared/event_fill_viewport.dart';

class EventsPage extends StatelessWidget {
  const EventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<EventsListCubit>()..loadFirstPage()),
        BlocProvider(create: (_) => sl<EventTypesCubit>()..load()),
      ],
      child: const _EventsView(),
    );
  }
}

class _EventsView extends StatelessWidget {
  const _EventsView();

  void _resetHiddenType(BuildContext context, EventTypesState typesState) {
    final cubit = context.read<EventsListCubit>();
    final typeId = cubit.state.typeId;
    if (typeId == null) return;
    final isVisible = typesState.visibleTypes.any((type) => type.id == typeId);
    if (!isVisible) cubit.selectType(null);
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<EventsListCubit>().state;
    final cubit = context.read<EventsListCubit>();
    final typesCubit = context.read<EventTypesCubit>();

    return BlocListener<EventTypesCubit, EventTypesState>(
      listenWhen: (previous, current) =>
          previous.types != current.types && current.status == EventTypesStatus.success,
      listener: _resetHiddenType,
      child: Column(
        children: [
          const EventTypeTabs(),
          Expanded(
            child: AppRefreshIndicator(
              onRefresh: () => Future.wait([cubit.refresh(), typesCubit.load()]),
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
            ),
          ),
        ],
      ),
    );
  }
}
