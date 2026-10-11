import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/repositories/volunteering_opportunities_repository.dart';
import '../shared/volunteering_opportunity_date_range.dart';
import 'volunteering_opportunity_key_value_row.dart';

class VolunteeringOpportunityInfoSection extends StatelessWidget {
  const VolunteeringOpportunityInfoSection({super.key, required this.volunteeringOpportunity});

  final VolunteeringOpportunityDetails volunteeringOpportunity;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final rows = [
      (
        l10n.volunteeringOpportunityDateLabel,
        volunteeringOpportunityDateRange(
          context,
          volunteeringOpportunity.from,
          volunteeringOpportunity.to,
        ),
      ),
      if (volunteeringOpportunity.address.isNotEmpty)
        (l10n.volunteeringOpportunityPlaceLabel, volunteeringOpportunity.address),
      (
        l10n.volunteeringOpportunityHoursLabel,
        l10n.volunteeringOpportunityHours(volunteeringOpportunity.hours),
      ),
      if (volunteeringOpportunity.volunteersCount > 0)
        (
          l10n.volunteeringOpportunityVolunteersLabel,
          l10n.volunteeringOpportunityVolunteers(volunteeringOpportunity.volunteersCount),
        ),
      if (volunteeringOpportunity.activitiesCount > 0)
        (
          l10n.volunteeringOpportunityActivitiesLabel,
          l10n.volunteeringOpportunityActivities(volunteeringOpportunity.activitiesCount),
        ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < rows.length; i++) ...[
          if (i > 0) SizedBox(height: AppSpacing.sm),
          VolunteeringOpportunityKeyValueRow(label: rows[i].$1, value: rows[i].$2),
        ],
      ],
    );
  }
}
