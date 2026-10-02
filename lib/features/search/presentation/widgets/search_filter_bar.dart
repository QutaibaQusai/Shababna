import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/repositories/search_repository.dart';

class SearchFilterBar extends StatelessWidget {
  const SearchFilterBar({super.key, required this.selected, required this.onSelected});

  final SearchCategory? selected;
  final ValueChanged<SearchCategory?> onSelected;

  static String label(AppLocalizations l10n, SearchCategory? category) => switch (category) {
        null => l10n.searchFilterAll,
        SearchCategory.events => l10n.searchFilterEvents,
        SearchCategory.news => l10n.searchFilterNews,
        SearchCategory.faq => l10n.searchFilterFaq,
      };

  @override
  Widget build(BuildContext context) {
    final options = <SearchCategory?>[null, ...SearchCategory.values];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin),
      child: Row(
        children: [
          for (var i = 0; i < options.length; i++) ...[
            if (i > 0) SizedBox(width: AppSpacing.xs),
            _FilterPill(
              label: label(context.l10n, options[i]),
              isSelected: options[i] == selected,
              onTap: () => onSelected(options[i]),
            ),
          ],
        ],
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({required this.label, required this.isSelected, required this.onTap});

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Material(
      color: isSelected ? colorScheme.primary : colorScheme.surface,
      borderRadius: AppRadius.pillRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.pillRadius,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
          child: Text(
            label,
            style: context.textTheme.labelLarge?.copyWith(
              color: isSelected ? colorScheme.onPrimary : colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
