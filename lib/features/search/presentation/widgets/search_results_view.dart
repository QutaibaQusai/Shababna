import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/repositories/search_repository.dart';
import '../cubit/global_search_cubit.dart';
import '../cubit/global_search_state.dart';
import 'search_filter_bar.dart';
import 'search_result_tiles.dart';
import 'search_section_header.dart';

class SearchResultsView extends StatelessWidget {
  const SearchResultsView({super.key, required this.state});

  final GlobalSearchState state;

  List<Widget> _tiles(SearchCategory category) {
    final results = state.results;
    return switch (category) {
      SearchCategory.volunteeringOpportunities => results.volunteeringOpportunities.items
          .map((item) => SearchVolunteeringOpportunityTile(result: item))
          .toList(),
      SearchCategory.news => results.news.items.map((item) => SearchNewsTile(result: item)).toList(),
      SearchCategory.faq => results.faq.items.map((item) => SearchFaqTile(result: item)).toList(),
    };
  }

  List<Widget> _spaced(List<Widget> tiles) => [
        for (var i = 0; i < tiles.length; i++) ...[
          if (i > 0) SizedBox(height: AppSpacing.xs),
          tiles[i],
        ],
      ];

  List<Widget> _sections(BuildContext context) {
    final cubit = context.read<GlobalSearchCubit>();
    final children = <Widget>[];

    for (final category in SearchCategory.values) {
      final tiles = _tiles(category);
      if (tiles.isEmpty) continue;
      if (children.isNotEmpty) children.add(SizedBox(height: AppSpacing.md));
      children
        ..add(SearchSectionHeader(
          title: SearchFilterBar.label(context.l10n, category),
          onSeeAll: state.results.hasMore(category)
              ? () => cubit.categorySelected(category)
              : null,
        ))
        ..add(SizedBox(height: AppSpacing.xxs))
        ..addAll(_spaced(tiles));
    }
    return children;
  }

  @override
  Widget build(BuildContext context) {
    final category = state.category;

    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.all(AppSpacing.screenMargin),
      children: category == null ? _sections(context) : _spaced(_tiles(category)),
    );
  }
}
