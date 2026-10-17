import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/shared/widgets/app_button.dart';
import '../../../../../core/shared/widgets/app_page_header.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../utils/profile_missing_field.dart';
import '../../../../../core/shared/widgets/app_bottom_safe_area.dart';

Future<void> showProfileIncompleteSheet(BuildContext context, List<String> missingFields) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) => _ProfileIncompleteSheet(
      fields: ProfileMissingField.values
          .where(ProfileMissingField.parse(missingFields).contains)
          .toList(),
      onCompleteProfile: () {
        Navigator.of(sheetContext).pop();
        context.push(AppRoutes.editProfile, extra: missingFields);
      },
    ),
  );
}

class _ProfileIncompleteSheet extends StatelessWidget {
  const _ProfileIncompleteSheet({required this.fields, required this.onCompleteProfile});

  final List<ProfileMissingField> fields;
  final VoidCallback onCompleteProfile;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AppBottomSafeArea(
      top: true,
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
              title: l10n.profileIncompleteTitle,
              subtitle: l10n.profileIncompleteMessage,
            ),
            SizedBox(height: AppSpacing.sm),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final field in fields)
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
                            Expanded(
                              child: Text(field.label(l10n), style: context.textTheme.bodyMedium),
                            ),
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
}
