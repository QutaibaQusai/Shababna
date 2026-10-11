import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/extensions/context_extensions.dart';

String volunteeringOpportunityDateRange(BuildContext context, DateTime from, DateTime to) {
  final locale = context.locale.toLanguageTag();
  final full = DateFormat.yMMMd(locale);
  if (DateUtils.isSameDay(from, to)) return full.format(from);
  final start = from.year == to.year ? DateFormat.MMMd(locale) : full;
  return '${start.format(from)} – ${full.format(to)}';
}
