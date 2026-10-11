import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/shared/widgets/app_text_field.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../utils/profile_missing_field.dart';
import 'edit_profile_form_scope.dart';

class EditProfileAddressSection extends StatelessWidget {
  const EditProfileAddressSection({
    super.key,
    required this.scope,
    required this.nearestLandmarkController,
    required this.districtController,
    required this.neighborhoodController,
    required this.detailedAddressController,
  });

  final EditProfileFormScope scope;
  final TextEditingController nearestLandmarkController;
  final TextEditingController districtController;
  final TextEditingController neighborhoodController;
  final TextEditingController detailedAddressController;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final edit = scope.edit;
    final isMissing = scope.isMissing;
    final anchor = scope.anchor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        anchor(
          ProfileMissingField.nearestLandmark,
          AppTextField(
            label: l10n.editProfileNearestLandmarkLabel,
            hasError: isMissing(ProfileMissingField.nearestLandmark),
            controller: nearestLandmarkController,
            prefixIcon: LucideIcons.landmark,
            textInputAction: TextInputAction.next,
            onChanged: (value) => edit((d) => d.copyWith(nearestLandmark: value)),
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        anchor(
          ProfileMissingField.district,
          AppTextField(
            label: l10n.districtLabel,
            hasError: isMissing(ProfileMissingField.district),
            controller: districtController,
            prefixIcon: LucideIcons.map,
            textInputAction: TextInputAction.next,
            onChanged: (value) => edit((d) => d.copyWith(district: value)),
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        anchor(
          ProfileMissingField.neighborhood,
          AppTextField(
            label: l10n.neighborhoodLabel,
            hasError: isMissing(ProfileMissingField.neighborhood),
            controller: neighborhoodController,
            prefixIcon: LucideIcons.house,
            textInputAction: TextInputAction.next,
            onChanged: (value) => edit((d) => d.copyWith(neighborhood: value)),
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        anchor(
          ProfileMissingField.detailedAddress,
          AppTextField(
            label: l10n.detailedAddressLabel,
            hasError: isMissing(ProfileMissingField.detailedAddress),
            controller: detailedAddressController,
            onChanged: (value) => edit((d) => d.copyWith(detailedAddress: value)),
          ),
        ),
      ],
    );
  }
}
