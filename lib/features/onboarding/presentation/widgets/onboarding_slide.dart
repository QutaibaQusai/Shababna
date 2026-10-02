import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../cubit/onboarding_step.dart';
import 'onboarding_palette.dart';

class OnboardingSlide extends StatelessWidget {
  const OnboardingSlide({super.key, required this.step, this.child});

  static const _topScrimEnd = 0.2;
  static const _scrimStart = 0.35;
  static const _scrimMiddle = 0.65;

  final OnboardingStep step;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final child = this.child;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(step.image, fit: BoxFit.cover),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0, _topScrimEnd],
              colors: [OnboardingPalette.glass, Colors.transparent],
            ),
          ),
        ),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [_scrimStart, _scrimMiddle, 1],
              colors: [Colors.transparent, OnboardingPalette.shade, OnboardingPalette.scrim],
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.screenMargin,
              0,
              AppSpacing.screenMargin,
              AppSizes.onboardingControlsHeight + bottomInset,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    text: '${step.titleLead(l10n)} ',
                    children: [
                      TextSpan(
                        text: step.highlight(l10n),
                        style: TextStyle(color: OnboardingPalette.accent(context.colorScheme)),
                      ),
                    ],
                  ),
                  style: context.textTheme.headlineLarge?.copyWith(
                    color: OnboardingPalette.foreground,
                    fontWeight: FontWeight.w800,
                    height: 1.25,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  step.subtitle(l10n),
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w400,
                    color: OnboardingPalette.muted,
                    height: 1.5,
                  ),
                ),
                if (child != null) ...[
                  SizedBox(height: AppSpacing.md),
                  child,
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
