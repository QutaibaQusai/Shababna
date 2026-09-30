import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';

class OnboardingProgressBar extends StatelessWidget {
  const OnboardingProgressBar({super.key, required this.current, required this.total});

  static const _duration = Duration(milliseconds: 300);

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;

    return Semantics(
      label: context.l10n.onboardingProgressLabel(current + 1, total),
      child: Row(
        children: [
          for (var index = 0; index < total; index++) ...[
            if (index > 0) SizedBox(width: AppSpacing.xxs),
            Expanded(
              child: AnimatedContainer(
                duration: _duration,
                curve: Curves.easeOutCubic,
                height: AppSizes.onboardingProgressHeight,
                decoration: BoxDecoration(
                  color: index <= current ? colors.primary : colors.surfaceContainerHighest,
                  borderRadius: AppRadius.pillRadius,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
