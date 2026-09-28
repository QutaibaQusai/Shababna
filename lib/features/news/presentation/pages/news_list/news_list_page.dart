import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/shared/widgets/app_app_bar.dart';
import '../../../../../core/shared/widgets/app_empty_widget.dart';
import '../../../../../core/shared/widgets/app_error_widget.dart';
import '../../../../../core/shared/widgets/app_refresh_indicator.dart';
import '../../cubit/news_list/news_list_cubit.dart';
import '../../cubit/news_list/news_list_state.dart';
import '../../widgets/news_list/news_list_content.dart';
import '../../widgets/news_list/news_list_skeleton.dart';
import '../../widgets/shared/news_fill_viewport.dart';

class NewsListPage extends StatelessWidget {
  const NewsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NewsListCubit>()..loadFirstPage(),
      child: Scaffold(
        appBar: AppAppBar(title: context.l10n.navNews, onBack: () => context.pop()),
        body: const SafeArea(top: false, child: _NewsListView()),
      ),
    );
  }
}

class _NewsListView extends StatelessWidget {
  const _NewsListView();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<NewsListCubit>().state;
    final cubit = context.read<NewsListCubit>();

    return AppRefreshIndicator(
      onRefresh: cubit.refresh,
      child: switch (state.status) {
        NewsListStatus.initial || NewsListStatus.loading => const NewsListSkeleton(),
        NewsListStatus.failure => NewsFillViewport(
            child: AppErrorWidget(
              message: state.errorMessage ?? context.l10n.somethingWentWrong,
              onRetry: cubit.loadFirstPage,
            ),
          ),
        NewsListStatus.success when state.items.isEmpty => NewsFillViewport(
            child: AppEmptyWidget(message: context.l10n.newsEmptyMessage),
          ),
        NewsListStatus.success => NewsListContent(state: state),
      },
    );
  }
}
