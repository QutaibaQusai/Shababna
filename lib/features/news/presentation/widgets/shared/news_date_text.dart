import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';

class NewsDateText extends StatelessWidget {
  const NewsDateText({super.key, required this.date});

  final DateTime? date;

  @override
  Widget build(BuildContext context) {
    final value = date;
    if (value == null) return const SizedBox.shrink();

    final locale = Localizations.localeOf(context).toLanguageTag();
    final color = context.colorScheme.onSurfaceVariant;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(LucideIcons.calendar, size: AppSizes.iconSm, color: color),
        SizedBox(width: AppSpacing.xxs),
        Text(
          DateFormat.yMMMMd(locale).format(value),
          style: context.textTheme.labelMedium?.copyWith(color: color),
        ),
      ],
    );
  }
}
