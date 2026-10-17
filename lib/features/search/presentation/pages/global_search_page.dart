import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/config/app_assets.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/shared/widgets/app_app_bar.dart';
import '../../../../core/shared/widgets/app_empty_widget.dart';
import '../../../../core/shared/widgets/app_error_widget.dart';
import '../../../../core/shared/widgets/app_search_field.dart';
import '../../../../core/theme/app_spacing.dart';
import '../cubit/global_search_cubit.dart';
import '../cubit/global_search_state.dart';
import '../widgets/search_filter_bar.dart';
import '../widgets/search_results_skeleton.dart';
import '../widgets/search_results_view.dart';
import '../../../../core/shared/widgets/app_bottom_safe_area.dart';

class GlobalSearchPage extends StatelessWidget {
  const GlobalSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<GlobalSearchCubit>(),
      child: Scaffold(
        appBar: AppAppBar(title: context.l10n.searchTitle, onBack: () => context.pop()),
        body: const AppBottomSafeArea(child: _GlobalSearchView()),
      ),
    );
  }
}

class _GlobalSearchView extends StatelessWidget {
  const _GlobalSearchView();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<GlobalSearchCubit>().state;
    final cubit = context.read<GlobalSearchCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.screenMargin,
            AppSpacing.xs,
            AppSpacing.screenMargin,
            AppSpacing.sm,
          ),
          child: AppSearchField(
            hint: context.l10n.searchHint,
            autofocus: true,
            onChanged: cubit.queryChanged,
          ),
        ),
        SearchFilterBar(selected: state.category, onSelected: cubit.categorySelected),
        Expanded(
          child: switch (state.status) {
            GlobalSearchStatus.idle => AppEmptyWidget(
              asset: AppAssets.illustrationSearch,
              message: context.l10n.searchIdleMessage,
            ),
            GlobalSearchStatus.loading => const SearchResultsSkeleton(),
            GlobalSearchStatus.failure => AppErrorWidget(
              message: state.errorMessage ?? context.l10n.somethingWentWrong,
              onRetry: cubit.retry,
            ),
            GlobalSearchStatus.success when state.results.isEmpty => AppEmptyWidget(
              asset: AppAssets.illustrationSearch,
              message: context.l10n.searchEmptyMessage(state.query),
            ),
            GlobalSearchStatus.success => SearchResultsView(state: state),
          },
        ),
      ],
    );
  }
}
