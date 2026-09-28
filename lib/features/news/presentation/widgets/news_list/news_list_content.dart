import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/shared/widgets/app_page_header.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../cubit/news_list/news_list_cubit.dart';
import '../../cubit/news_list/news_list_state.dart';
import 'news_card.dart';
import 'news_load_more_footer.dart';

class NewsListContent extends StatelessWidget {
  const NewsListContent({super.key, required this.state});

  static const _loadMoreThreshold = 300.0;

  final NewsListState state;

  bool _onScroll(BuildContext context, ScrollNotification notification) {
    final metrics = notification.metrics;
    if (metrics.axis == Axis.vertical &&
        metrics.maxScrollExtent - metrics.pixels <= _loadMoreThreshold) {
      context.read<NewsListCubit>().loadMore();
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
        padding: EdgeInsets.all(AppSpacing.screenMargin),
        itemCount: items.length + 1 + (state.hasNextPage ? 1 : 0),
        separatorBuilder: (context, index) =>
            SizedBox(height: index == 0 ? AppSpacing.md : AppSpacing.sm),
        itemBuilder: (context, index) {
          if (index == 0) {
            return AppPageHeader(
              title: context.l10n.newsHeaderTitle,
              subtitle: context.l10n.newsHeaderSubtitle,
            );
          }
          final itemIndex = index - 1;
          if (itemIndex == items.length) {
            return NewsLoadMoreFooter(
              failed: state.loadMoreFailed,
              onRetry: context.read<NewsListCubit>().retryLoadMore,
            );
          }
          return NewsCard(article: items[itemIndex]);
        },
      ),
    );
  }
}
