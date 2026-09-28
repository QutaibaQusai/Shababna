import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/extensions/context_extensions.dart';

class NewsDateText extends StatelessWidget {
  const NewsDateText({super.key, required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Text(
      DateFormat.yMMMMd(context.locale.toLanguageTag()).format(date),
      style: context.textTheme.labelMedium?.copyWith(
        color: context.colorScheme.onSurfaceVariant,
      ),
    );
  }
}
