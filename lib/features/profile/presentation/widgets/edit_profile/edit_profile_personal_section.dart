import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/shared/widgets/app_text_field.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/validators/app_validators.dart';
import '../../../domain/repositories/profile_lookups_repository.dart';
import '../../../domain/repositories/profile_repository.dart';
import '../../utils/profile_missing_field.dart';
import 'edit_profile_form_scope.dart';
import 'gender_option.dart';
import 'profile_birth_date_field.dart';
import 'profile_lookup_field.dart';

class EditProfilePersonalSection extends StatelessWidget {
  const EditProfilePersonalSection({
    super.key,
    required this.scope,
    required this.majorController,
    required this.universityNameController,
  });

  final EditProfileFormScope scope;
  final TextEditingController majorController;
  final TextEditingController universityNameController;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final isArabic = context.isArabic;
    final lookups = sl<ProfileLookupsRepository>();
    final draft = scope.draft;
    final edit = scope.edit;
    final isMissing = scope.isMissing;
    final anchor = scope.anchor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        anchor(
          ProfileMissingField.gender,
          Row(
            children: [
              Expanded(
                child: GenderOption(
                  label: l10n.genderMale,
                  hasError: isMissing(ProfileMissingField.gender),
                  icon: Icons.male,
                  selected: draft.gender == ProfileGender.male,
                  onTap: () => edit((d) => d.copyWith(gender: ProfileGender.male)),
                ),
              ),
              SizedBox(width: AppSpacing.xs),
              Expanded(
                child: GenderOption(
                  label: l10n.genderFemale,
                  hasError: isMissing(ProfileMissingField.gender),
                  icon: Icons.female,
                  selected: draft.gender == ProfileGender.female,
                  onTap: () => edit((d) => d.copyWith(gender: ProfileGender.female)),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        anchor(
          ProfileMissingField.dateOfBirth,
          ProfileBirthDateField(
            label: l10n.dateOfBirthLabel,
            hasError: isMissing(ProfileMissingField.dateOfBirth),
            value: draft.dateOfBirth,
            onChanged: (value) => edit((d) => d.copyWith(dateOfBirth: value)),
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        anchor(
          ProfileMissingField.nationality,
          ProfileLookupField<Country>(
            label: l10n.nationalityLabel,
            hasError: isMissing(ProfileMissingField.nationality),
            icon: LucideIcons.flag,
            selectedId: draft.nationality?.id,
            selectedLabel: draft.nationality?.name,
            loader: lookups.getCountries,
            idOf: (item) => item.id,
            itemLabel: (item) => item.displayName(isArabic),
            onSelected: (item) => edit(
              (d) => d.copyWith(
                nationality: ProfileReference(id: item.id, name: item.displayName(isArabic)),
              ),
            ),
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        anchor(
          ProfileMissingField.city,
          ProfileLookupField<City>(
            label: l10n.governorateLabel,
            hasError: isMissing(ProfileMissingField.city),
            icon: LucideIcons.mapPin,
            selectedId: draft.city?.id,
            selectedLabel: draft.city?.name,
            loader: lookups.getCities,
            idOf: (item) => item.id,
            itemLabel: (item) => item.displayName(isArabic),
            onSelected: (item) => edit(
              (d) => d.copyWith(
                city: ProfileReference(id: item.id, name: item.displayName(isArabic)),
              ),
            ),
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        anchor(
          ProfileMissingField.education,
          ProfileLookupField<Education>(
            label: l10n.highestEducationLabel,
            hasError: isMissing(ProfileMissingField.education),
            icon: LucideIcons.graduationCap,
            selectedId: draft.education?.id,
            selectedLabel: draft.education?.name,
            loader: lookups.getEducations,
            idOf: (item) => item.id,
            itemLabel: (item) => item.displayName(isArabic),
            onSelected: (item) => edit(
              (d) => d.copyWith(
                education: ProfileEducation(
                  id: item.id,
                  name: item.displayName(isArabic),
                  isMajorRequired: item.isMajorRequired,
                ),
              ),
            ),
          ),
        ),
        if (draft.isMajorRequired) ...[
          SizedBox(height: AppSpacing.sm),
          anchor(
            ProfileMissingField.major,
            AppTextField(
              label: l10n.majorLabel,
              hasError: isMissing(ProfileMissingField.major),
              controller: majorController,
              prefixIcon: LucideIcons.bookOpen,
              textInputAction: TextInputAction.next,
              onChanged: (value) => edit((d) => d.copyWith(major: value)),
              validator: AppValidators.required(l10n.majorRequiredError),
            ),
          ),
        ],
        SizedBox(height: AppSpacing.sm),
        AppTextField(
          label: l10n.universityNameLabel,
          controller: universityNameController,
          prefixIcon: LucideIcons.school,
          textInputAction: TextInputAction.next,
          onChanged: (value) => edit((d) => d.copyWith(universityName: value)),
        ),
      ],
    );
  }
}
