import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/shared/widgets/app_button.dart';

class SearchSectionHeader extends StatelessWidget {
  const SearchSectionHeader({super.key, required this.title, this.onSeeAll});

  final String title;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    final onSeeAll = this.onSeeAll;

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        if (onSeeAll != null) AppButton.text(label: context.l10n.searchSeeAll, onPressed: onSeeAll),
      ],
    );
  }
}
