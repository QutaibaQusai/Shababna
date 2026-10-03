import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../domain/repositories/events_repository.dart';
import 'event_section_title.dart';

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
        EventSectionTitle(title: l10n.eventEligibilityTitle),
        for (final (label, value) in rows) ...[
          SizedBox(height: AppSpacing.sm),
          _EligibilityRow(label: label, value: value),
        ],
      ],
    );
  }
}

class _EligibilityRow extends StatelessWidget {
  const _EligibilityRow({required this.label, required this.value});

  static const _labelFlex = 2;
  static const _valueFlex = 3;

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: _labelFlex,
          child: Text(
            label,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Expanded(
          flex: _valueFlex,
          child: Text(
            value,
            style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
