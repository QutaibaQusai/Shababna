import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/shared/widgets/app_button.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';

class EditProfileBottomBar extends StatelessWidget {
  const EditProfileBottomBar({super.key, required this.percentage, required this.onSave});

  final int percentage;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.screenMargin),
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          border: Border(top: BorderSide(color: context.colorScheme.outlineVariant)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n.completeYourProfileLabel,
                  style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: AppSpacing.xxs),
                  decoration: BoxDecoration(
                    color: context.colorScheme.primaryContainer,
                    borderRadius: AppRadius.pillRadius,
                  ),
                  child: Text(
                    '$percentage%',
                    style: context.textTheme.labelMedium?.copyWith(
                      color: context.colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.sm),
            AppButton.primary(label: context.l10n.saveButton, onPressed: onSave),
          ],
        ),
      ),
    );
  }
}
