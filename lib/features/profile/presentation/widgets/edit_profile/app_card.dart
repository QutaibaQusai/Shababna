import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';

class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.value,
    this.isVerified = false,
    this.valueDirection,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final String? value;
  final bool isVerified;
  final TextDirection? valueDirection;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: AppRadius.mdRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: context.textTheme.titleSmall),
          if (subtitle != null) ...[
            SizedBox(height: AppSpacing.xxs),
            Text(
              subtitle!,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          SizedBox(height: AppSpacing.sm),
          InkWell(
            onTap: onTap,
            borderRadius: AppRadius.mdRadius,
            child: Container(
              height: AppSizes.buttonHeight,
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              decoration: BoxDecoration(
                border: Border.all(color: context.colorScheme.outlineVariant),
                borderRadius: AppRadius.mdRadius,
              ),
              child: Row(
                children: [
                  Icon(icon, size: AppSizes.iconField, color: context.colorScheme.onSurfaceVariant),
                  SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      value ?? '-',
                      textDirection: valueDirection,
                      style: context.textTheme.bodyLarge,
                    ),
                  ),
                  if (isVerified)
                    Container(
                      width: AppSizes.iconField,
                      height: AppSizes.iconField,
                      decoration: const BoxDecoration(
                        color: AppColors.successColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check, size: 14, color: Colors.white),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
