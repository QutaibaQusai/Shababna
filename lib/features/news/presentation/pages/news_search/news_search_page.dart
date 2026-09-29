import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/shared/widgets/app_app_bar.dart';
import '../../../../../core/shared/widgets/app_error_widget.dart';
import '../../../../../core/shared/widgets/app_search_field.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../cubit/news_search/news_search_cubit.dart';
import '../../cubit/news_search/news_search_state.dart';
import '../../widgets/news_search/news_search_list_skeleton.dart';
import '../../widgets/news_search/news_search_message.dart';
import '../../widgets/news_search/news_search_results.dart';

class NewsSearchPage extends StatelessWidget {
  const NewsSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<NewsSearchCubit>(),
      child: Scaffold(
        appBar: AppAppBar(title: context.l10n.newsSearchTitle, onBack: () => context.pop()),
        body: const SafeArea(top: false, child: _NewsSearchView()),
      ),
    );
  }
}

class _NewsSearchView extends StatelessWidget {
  const _NewsSearchView();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<NewsSearchCubit>().state;
    final cubit = context.read<NewsSearchCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.screenMargin,
            AppSpacing.xs,
            AppSpacing.screenMargin,
            0,
          ),
          child: AppSearchField(
            hint: context.l10n.newsSearchHint,
            autofocus: true,
            onChanged: cubit.queryChanged,
          ),
        ),
        Expanded(
          child: switch (state.status) {
            NewsSearchStatus.idle => NewsSearchMessage(message: context.l10n.newsSearchIdleMessage),
            NewsSearchStatus.loading => const NewsSearchListSkeleton(),
            NewsSearchStatus.failure => AppErrorWidget(
                message: state.errorMessage ?? context.l10n.somethingWentWrong,
                onRetry: cubit.retry,
              ),
            NewsSearchStatus.success when state.items.isEmpty => NewsSearchMessage(
                message: context.l10n.newsSearchEmptyMessage(state.query),
              ),
            NewsSearchStatus.success => NewsSearchResults(state: state),
          },
        ),
      ],
    );
  }
}
