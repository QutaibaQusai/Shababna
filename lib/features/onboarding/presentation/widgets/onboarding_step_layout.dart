import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../cubit/onboarding_step.dart';
import 'onboarding_illustration.dart';

class OnboardingStepLayout extends StatelessWidget {
  const OnboardingStepLayout({super.key, required this.step, this.child});

  final OnboardingStep step;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final child = this.child;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.screenMargin,
        vertical: AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          OnboardingIllustration(asset: step.illustration),
          SizedBox(height: AppSpacing.lg),
          Text(
            step.title(l10n),
            textAlign: TextAlign.center,
            style: context.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            step.subtitle(l10n),
            textAlign: TextAlign.center,
            style: context.textTheme.bodyLarge?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
          if (child != null) ...[
            SizedBox(height: AppSpacing.lg),
            child,
          ],
        ],
      ),
    );
  }
}
