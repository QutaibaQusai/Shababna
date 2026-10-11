import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/shared/widgets/app_text_field.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/repositories/profile_lookups_repository.dart';
import '../../utils/profile_missing_field.dart';
import 'edit_profile_form_scope.dart';
import 'profile_lookup_field.dart';
import 'switch_row.dart';

class EditProfileVolunteeringSection extends StatelessWidget {
  const EditProfileVolunteeringSection({
    super.key,
    required this.scope,
    required this.weeklyHoursController,
    required this.otherSubjectsController,
  });

  static const _minWeeklyHours = 1;
  static const _maxWeeklyHours = 168;
  static const _weeklyHoursMaxDigits = 3;

  final EditProfileFormScope scope;
  final TextEditingController weeklyHoursController;
  final TextEditingController otherSubjectsController;

  String? _validateWeeklyHours(BuildContext context, String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;
    final hours = int.tryParse(text);
    if (hours == null || hours < _minWeeklyHours || hours > _maxWeeklyHours) {
      return context.l10n.weeklyHoursRangeError(_minWeeklyHours, _maxWeeklyHours);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isArabic = context.isArabic;
    final draft = scope.draft;
    final edit = scope.edit;
    final isMissing = scope.isMissing;
    final anchor = scope.anchor;

    Widget switchRow(
      ProfileMissingField field,
      String label,
      bool value,
      ValueChanged<bool> onChanged,
    ) => anchor(
      field,
      SwitchRow(label: label, hasError: isMissing(field), value: value, onChanged: onChanged),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SwitchRow(
          label: l10n.editProfilePreviousExperienceLabel,
          value: !draft.isFirstTimeVolunteer,
          onChanged: (hasExperience) =>
              edit((d) => d.copyWith(isFirstTimeVolunteer: !hasExperience)),
        ),
        switchRow(
          ProfileMissingField.volunteerAwards,
          l10n.editProfileVolunteerAwardsLabel,
          draft.volunteerAwards,
          (value) => edit((d) => d.copyWith(volunteerAwards: value)),
        ),
        switchRow(
          ProfileMissingField.isAvailableToVolunteer,
          l10n.editProfileAvailableToVolunteerLabel,
          draft.isAvailableToVolunteer,
          (value) => edit((d) => d.copyWith(isAvailableToVolunteer: value)),
        ),
        switchRow(
          ProfileMissingField.willSignVolunteerServiceAgreement,
          l10n.editProfileServiceAgreementLabel,
          draft.willSignVolunteerServiceAgreement,
          (value) => edit((d) => d.copyWith(willSignVolunteerServiceAgreement: value)),
        ),
        switchRow(
          ProfileMissingField.willProvideNcc,
          l10n.editProfileNonConvictionLabel,
          draft.willProvideNcc,
          (value) => edit((d) => d.copyWith(willProvideNcc: value)),
        ),
        SizedBox(height: AppSpacing.sm),
        anchor(
          ProfileMissingField.estimatedWeeklyHours,
          AppTextField(
            label: l10n.editProfileWeeklyHoursLabel,
            hasError: isMissing(ProfileMissingField.estimatedWeeklyHours),
            controller: weeklyHoursController,
            prefixIcon: LucideIcons.clock,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(_weeklyHoursMaxDigits),
            ],
            onChanged: (value) => edit((d) => d.copyWith(estimatedWeeklyHours: value)),
            validator: (value) => _validateWeeklyHours(context, value),
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        anchor(
          ProfileMissingField.volunteeringTypes,
          ProfileLookupMultiField<VolunteeringType>(
            label: l10n.volunteeringTypesLabel,
            hasError: isMissing(ProfileMissingField.volunteeringTypes),
            icon: LucideIcons.handHeart,
            selected: draft.volunteeringTypes,
            loader: sl<ProfileLookupsRepository>().getVolunteeringTypes,
            idOf: (item) => item.id,
            itemLabel: (item) => item.displayName(isArabic),
            onChanged: (value) => edit((d) => d.copyWith(volunteeringTypes: value)),
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        AppTextField(
          label: l10n.otherVolunteeringSubjectsLabel,
          controller: otherSubjectsController,
          textInputAction: TextInputAction.done,
          onChanged: (value) => edit((d) => d.copyWith(otherVolunteeringSubjects: value)),
        ),
      ],
    );
  }
}
