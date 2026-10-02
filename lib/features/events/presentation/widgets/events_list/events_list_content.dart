import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../../../core/theme/app_spacing.dart';
import '../../cubit/events_list/events_list_cubit.dart';
import '../../cubit/events_list/events_list_state.dart';
import '../shared/event_load_more_footer.dart';
import 'event_card.dart';

class EventsListContent extends StatelessWidget {
  const EventsListContent({super.key, required this.state});

  static const _loadMoreThreshold = 300.0;
  static const columnCount = 2;

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
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(margin, margin, margin, 0),
            sliver: SliverMasonryGrid.count(
              crossAxisCount: columnCount,
              mainAxisSpacing: AppSpacing.md,
              crossAxisSpacing: AppSpacing.sm,
              childCount: items.length,
              itemBuilder: (context, index) =>
                  EventCard(event: items[index], isTall: EventCard.isTallAt(index)),
            ),
          ),
          if (state.hasNextPage)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: AppSpacing.sm),
                child: EventLoadMoreFooter(
                  failed: state.loadMoreFailed,
                  onRetry: context.read<EventsListCubit>().retryLoadMore,
                ),
              ),
            ),
          SliverPadding(
            padding: EdgeInsets.only(bottom: margin + MediaQuery.paddingOf(context).bottom),
          ),
        ],
      ),
    );
  }
}
