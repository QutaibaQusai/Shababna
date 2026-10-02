import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/shared/widgets/app_page_header.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../cubit/events_list/events_list_cubit.dart';
import '../../cubit/events_list/events_list_state.dart';
import '../shared/event_load_more_footer.dart';
import 'event_card.dart';

class EventsListContent extends StatelessWidget {
  const EventsListContent({super.key, required this.state});

  static const _loadMoreThreshold = 300.0;

  final EventsListState state;

  bool _onScroll(BuildContext context, ScrollNotification notification) {
    final metrics = notification.metrics;
    if (metrics.axis == Axis.vertical &&
        metrics.maxScrollExtent - metrics.pixels <= _loadMoreThreshold) {
      context.read<EventsListCubit>().loadMore();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final items = state.items;
    final margin = AppSpacing.screenMargin;

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) => _onScroll(context, notification),
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          margin,
          margin,
          margin,
          margin + MediaQuery.paddingOf(context).bottom,
        ),
        itemCount: items.length + 1 + (state.hasNextPage ? 1 : 0),
        separatorBuilder: (context, index) => SizedBox(height: AppSpacing.md),
        itemBuilder: (context, index) {
          if (index == 0) {
            return AppPageHeader(
              title: context.l10n.eventsHeaderTitle,
              subtitle: context.l10n.eventsHeaderSubtitle,
            );
          }
          final itemIndex = index - 1;
          if (itemIndex == items.length) {
            return EventLoadMoreFooter(
              failed: state.loadMoreFailed,
              onRetry: context.read<EventsListCubit>().retryLoadMore,
            );
          }
          return EventCard(event: items[itemIndex]);
        },
      ),
    );
  }
}
