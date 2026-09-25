import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';

class GenderOption extends StatelessWidget {
  const GenderOption({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppRadius.mdRadius,
      onTap: onTap,
      child: Container(
        height: AppSizes.buttonHeight,
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
        decoration: BoxDecoration(
          color: selected ? context.colorScheme.primaryContainer : null,
          border: Border.all(
            color: selected ? context.colorScheme.primary : context.colorScheme.outlineVariant,
          ),
          borderRadius: AppRadius.mdRadius,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: AppSizes.iconMd,
              color: selected
                  ? context.colorScheme.onPrimaryContainer
                  : context.colorScheme.onSurfaceVariant,
            ),
            SizedBox(width: AppSpacing.xxs),
            Text(
              label,
              style: context.textTheme.bodyMedium?.copyWith(
                color: selected ? context.colorScheme.onPrimaryContainer : context.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
