import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import 'onboarding_palette.dart';

class OnboardingPageDots extends StatelessWidget {
  const OnboardingPageDots({super.key, required this.current, required this.total});

  static const _duration = Duration(milliseconds: 300);

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    final accent = OnboardingPalette.accent(context.colorScheme);
    final dotSize = AppSizes.onboardingDotSize;

    return Semantics(
      label: context.l10n.onboardingProgressLabel(current + 1, total),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var index = 0; index < total; index++) ...[
            if (index > 0) SizedBox(width: AppSpacing.xxs),
            AnimatedContainer(
              duration: _duration,
              curve: Curves.easeOutCubic,
              width: index == current ? AppSizes.onboardingDotActiveWidth : dotSize,
              height: AppSizes.onboardingDotHeight,
              decoration: BoxDecoration(
                color: index == current ? accent : OnboardingPalette.faint,
                borderRadius: AppRadius.pillRadius,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
