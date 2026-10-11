import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../../../core/theme/app_spacing.dart';
import '../../cubit/volunteering_opportunities_list/volunteering_opportunities_list_cubit.dart';
import '../../cubit/volunteering_opportunities_list/volunteering_opportunities_list_state.dart';
import '../shared/volunteering_opportunity_load_more_footer.dart';
import 'volunteering_opportunity_card.dart';

class VolunteeringOpportunitiesListContent extends StatelessWidget {
  const VolunteeringOpportunitiesListContent({super.key, required this.state});

  static const _loadMoreThreshold = 300.0;
  static const columnCount = 2;

  final VolunteeringOpportunitiesListState state;

  bool _onScroll(BuildContext context, ScrollNotification notification) {
    final metrics = notification.metrics;
    if (metrics.axis == Axis.vertical &&
        metrics.maxScrollExtent - metrics.pixels <= _loadMoreThreshold) {
      context.read<VolunteeringOpportunitiesListCubit>().loadMore();
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
              mainAxisSpacing: AppSpacing.sm,
              crossAxisSpacing: AppSpacing.sm,
              childCount: items.length,
              itemBuilder: (context, index) => VolunteeringOpportunityCard(
                volunteeringOpportunity: items[index],
                isTall: VolunteeringOpportunityCard.isTallAt(index),
              ),
            ),
          ),
          if (state.hasNextPage)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: AppSpacing.sm),
                child: VolunteeringOpportunityLoadMoreFooter(
                  failed: state.loadMoreFailed,
                  onRetry: context.read<VolunteeringOpportunitiesListCubit>().retryLoadMore,
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
