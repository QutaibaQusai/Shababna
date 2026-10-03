import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/repositories/events_repository.dart';
import '../shared/event_date_range.dart';
import 'event_key_value_row.dart';

class EventInfoSection extends StatelessWidget {
  const EventInfoSection({super.key, required this.event});

  final EventDetails event;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final rows = [
      (l10n.eventDateLabel, eventDateRange(context, event.from, event.to)),
      if (event.address.isNotEmpty) (l10n.eventPlaceLabel, event.address),
      (l10n.eventHoursLabel, l10n.eventHours(event.hours)),
      if (event.volunteersCount > 0)
        (l10n.eventVolunteersLabel, l10n.eventVolunteers(event.volunteersCount)),
      if (event.activitiesCount > 0)
        (l10n.eventActivitiesLabel, l10n.eventActivities(event.activitiesCount)),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < rows.length; i++) ...[
          if (i > 0) SizedBox(height: AppSpacing.sm),
          EventKeyValueRow(label: rows[i].$1, value: rows[i].$2),
        ],
      ],
    );
  }
}
