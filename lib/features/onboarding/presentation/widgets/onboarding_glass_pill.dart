import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import 'onboarding_palette.dart';

class OnboardingGlassPill extends StatelessWidget {
  const OnboardingGlassPill({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.isSelected = false,
  });

  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final icon = this.icon;
    final foreground = isSelected ? Colors.black : OnboardingPalette.foreground;
    final onTap = this.onTap;

    return Semantics(
      button: true,
      selected: isSelected,
      child: Material(
        color: isSelected ? OnboardingPalette.foreground : OnboardingPalette.glass,
        borderRadius: AppRadius.pillRadius,
        child: InkWell(
          borderRadius: AppRadius.pillRadius,
          onTap: onTap == null
              ? null
              : () {
                  HapticFeedback.selectionClick();
                  onTap();
                },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: AppSizes.iconSm, color: foreground),
                  SizedBox(width: AppSpacing.xxs),
                ],
                Text(
                  label,
                  style: context.textTheme.labelLarge?.copyWith(
                    color: foreground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
