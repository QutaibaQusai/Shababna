import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/shared/widgets/app_button.dart';
import '../../../../../core/shared/widgets/app_page_header.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../l10n/app_localizations.dart';

Future<void> showProfileIncompleteSheet(BuildContext context, List<String> missingFields) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) => _ProfileIncompleteSheet(
      missingFields: missingFields,
      onCompleteProfile: () {
        Navigator.of(sheetContext).pop();
        context.push(AppRoutes.editProfile, extra: missingFields);
      },
    ),
  );
}

class _ProfileIncompleteSheet extends StatelessWidget {
  const _ProfileIncompleteSheet({required this.missingFields, required this.onCompleteProfile});

  final List<String> missingFields;
  final VoidCallback onCompleteProfile;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final labels = missingFields.map((field) => _fieldLabel(l10n, field)).toSet().toList();

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.screenMargin,
          0,
          AppSpacing.screenMargin,
          AppSpacing.md,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppPageHeader(
              title: l10n.eventProfileIncompleteTitle,
              subtitle: l10n.eventProfileIncompleteMessage,
            ),
            SizedBox(height: AppSpacing.sm),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final label in labels)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: AppSpacing.xxs),
                        child: Row(
                          children: [
                            Icon(
                              LucideIcons.circleAlert,
                              size: AppSizes.iconSm,
                              color: context.colorScheme.primary,
                            ),
                            SizedBox(width: AppSpacing.xs),
                            Expanded(child: Text(label, style: context.textTheme.bodyMedium)),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(height: AppSpacing.md),
            AppButton.primary(label: l10n.completeYourProfileLabel, onPressed: onCompleteProfile),
          ],
        ),
      ),
    );
  }

  String _fieldLabel(AppLocalizations l10n, String field) => switch (field) {
        'nationality' => l10n.nationalityLabel,
        'gender' => l10n.genderLabel,
        'education' => l10n.educationLabel,
        'major' => l10n.majorLabel,
        'city' => l10n.cityLabel,
        'dateOfBirth' => l10n.dateOfBirthLabel,
        'nationalIdPicture' => l10n.nationalIdPictureLabel,
        'district' => l10n.districtLabel,
        'neighborhood' => l10n.neighborhoodLabel,
        'nearestLandmark' => l10n.nearestLandmarkLabel,
        'detailedAddress' => l10n.detailedAddressLabel,
        'volunteerAwards' => l10n.volunteerAwardsLabel,
        'isAvailableToVolunteer' => l10n.isAvailableToVolunteerLabel,
        'estimatedWeeklyHours' => l10n.estimatedWeeklyHoursLabel,
        'willSignVolunteerServiceAgreement' => l10n.willSignVolunteerServiceAgreementLabel,
        'willProvideNcc' => l10n.willProvideNccLabel,
        'volunteeringTypeIds' => l10n.volunteeringTypesLabel,
        _ => field,
      };
}
