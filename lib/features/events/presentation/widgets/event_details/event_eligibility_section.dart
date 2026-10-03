import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../domain/repositories/events_repository.dart';
import 'event_key_value_row.dart';

class EventEligibilitySection extends StatelessWidget {
  const EventEligibilitySection({super.key, required this.event});

  final EventDetails event;

  String _gender(AppLocalizations l10n) => switch (event.gender) {
        EventGender.male => l10n.eventGenderMale,
        EventGender.female => l10n.eventGenderFemale,
        EventGender.both => l10n.eventGenderBoth,
      };

  String _names(BuildContext context, List<EventReference> references) {
    if (references.isEmpty) return context.l10n.eventOpenToAll;
    final separator = context.isArabic ? '، ' : ', ';
    return references.map((reference) => reference.name).join(separator);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final rows = [
      (l10n.genderLabel, _gender(l10n)),
      (
        l10n.eventAgeLabel,
        event.ageTo > 0 ? l10n.eventAgeRange(event.ageFrom, event.ageTo) : l10n.eventOpenToAll,
      ),
      (l10n.nationalityLabel, _names(context, event.nationalities)),
      (l10n.cityLabel, _names(context, event.cities)),
      (l10n.educationLabel, _names(context, event.educations)),
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
