import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_spacing.dart';
import '../../cubit/news_search/news_search_cubit.dart';
import '../../cubit/news_search/news_search_state.dart';
import '../news_list/news_load_more_footer.dart';
import 'news_search_card.dart';

class NewsSearchResults extends StatelessWidget {
  const NewsSearchResults({super.key, required this.state});

  static const _loadMoreThreshold = 300.0;

  final NewsSearchState state;

  bool _onScroll(BuildContext context, ScrollNotification notification) {
    final metrics = notification.metrics;
    if (metrics.axis == Axis.vertical &&
        metrics.maxScrollExtent - metrics.pixels <= _loadMoreThreshold) {
      context.read<NewsSearchCubit>().loadMore();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final items = state.items;

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) => _onScroll(context, notification),
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: EdgeInsets.all(AppSpacing.screenMargin),
        itemCount: items.length + (state.hasNextPage ? 1 : 0),
        separatorBuilder: (_, _) => SizedBox(height: AppSpacing.xs),
        itemBuilder: (context, index) {
          if (index == items.length) {
            return NewsLoadMoreFooter(
              failed: state.loadMoreFailed,
              onRetry: context.read<NewsSearchCubit>().retryLoadMore,
            );
          }
          return NewsSearchCard(result: items[index]);
        },
      ),
    );
  }
}
