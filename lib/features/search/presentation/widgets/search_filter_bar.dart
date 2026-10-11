import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/repositories/search_repository.dart';

class SearchFilterBar extends StatelessWidget {
  const SearchFilterBar({super.key, required this.selected, required this.onSelected});

  final SearchCategory? selected;
  final ValueChanged<SearchCategory?> onSelected;

  static String label(AppLocalizations l10n, SearchCategory? category) => switch (category) {
        null => l10n.searchFilterAll,
        SearchCategory.volunteeringOpportunities => l10n.searchFilterVolunteeringOpportunities,
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

  static const _duration = Duration(milliseconds: 200);

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Semantics(
      button: true,
      selected: isSelected,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.smRadius,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: AppSpacing.xxs),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedDefaultTextStyle(
                duration: _duration,
                style: (context.textTheme.labelLarge ?? const TextStyle()).copyWith(
                  color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
                child: Text(label),
              ),
              SizedBox(height: AppSpacing.xxs),
              AnimatedContainer(
                duration: _duration,
                width: AppSizes.tabIndicatorDotSize,
                height: AppSizes.tabIndicatorDotSize,
                decoration: BoxDecoration(
                  color: isSelected ? colorScheme.primary : Colors.transparent,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
