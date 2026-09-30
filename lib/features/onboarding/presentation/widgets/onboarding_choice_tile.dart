import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_borders.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';

class OnboardingChoiceTile extends StatelessWidget {
  const OnboardingChoiceTile({
    super.key,
    required this.leading,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.caption,
  });

  static const _duration = Duration(milliseconds: 200);
  static const _leadingBackgroundOpacity = 0.12;

  final Widget leading;
  final String label;
  final String? caption;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final caption = this.caption;
    final leadingSize = AppSizes.iconButtonSize;

    return Semantics(
      button: true,
      selected: isSelected,
      child: AnimatedContainer(
        duration: _duration,
        curve: Curves.easeOut,
        decoration: BoxDecoration(
          color: isSelected ? colors.primary.withValues(alpha: _leadingBackgroundOpacity / 2) : colors.surface,
          borderRadius: AppRadius.lgRadius,
          border: Border.all(
            color: isSelected ? colors.primary : colors.outlineVariant,
            width: isSelected ? AppBorders.thick : AppBorders.hairline,
          ),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: AppRadius.lgRadius,
            onTap: () {
              HapticFeedback.selectionClick();
              onTap();
            },
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.sm),
              child: Row(
                children: [
                  Container(
                    width: leadingSize,
                    height: leadingSize,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: _leadingBackgroundOpacity),
                      shape: BoxShape.circle,
                    ),
                    child: IconTheme.merge(
                      data: IconThemeData(color: colors.primary, size: AppSizes.iconField),
                      child: DefaultTextStyle.merge(
                        style: context.textTheme.titleSmall?.copyWith(
                          color: colors.primary,
                          fontWeight: FontWeight.w800,
                        ),
                        child: leading,
                      ),
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          label,
                          style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        if (caption != null)
                          Text(
                            caption,
                            style: context.textTheme.bodySmall?.copyWith(
                              color: colors.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                  ),
                  AnimatedSwitcher(
                    duration: _duration,
                    child: Icon(
                      isSelected ? LucideIcons.circleCheck : LucideIcons.circle,
                      key: ValueKey(isSelected),
                      size: AppSizes.iconMd,
                      color: isSelected ? colors.primary : colors.outlineVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
