import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../domain/repositories/volunteering_opportunities_repository.dart';
import 'volunteering_opportunity_key_value_row.dart';

class VolunteeringOpportunityEligibilitySection extends StatelessWidget {
  const VolunteeringOpportunityEligibilitySection({
    super.key,
    required this.volunteeringOpportunity,
  });

  final VolunteeringOpportunityDetails volunteeringOpportunity;

  String _gender(AppLocalizations l10n) => switch (volunteeringOpportunity.gender) {
        VolunteeringOpportunityGender.male => l10n.volunteeringOpportunityGenderMale,
        VolunteeringOpportunityGender.female => l10n.volunteeringOpportunityGenderFemale,
        VolunteeringOpportunityGender.both => l10n.volunteeringOpportunityGenderBoth,
      };

  String _names(BuildContext context, List<VolunteeringOpportunityReference> references) {
    if (references.isEmpty) return context.l10n.volunteeringOpportunityOpenToAll;
    final separator = context.isArabic ? '، ' : ', ';
    return references.map((reference) => reference.name).join(separator);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final rows = [
      (l10n.genderLabel, _gender(l10n)),
      (
        l10n.volunteeringOpportunityAgeLabel,
        volunteeringOpportunity.ageTo > 0
            ? l10n.volunteeringOpportunityAgeRange(
                volunteeringOpportunity.ageFrom,
                volunteeringOpportunity.ageTo,
              )
            : l10n.volunteeringOpportunityOpenToAll,
      ),
      (l10n.nationalityLabel, _names(context, volunteeringOpportunity.nationalities)),
      (l10n.cityLabel, _names(context, volunteeringOpportunity.cities)),
      (l10n.educationLabel, _names(context, volunteeringOpportunity.educations)),
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
