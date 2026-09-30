import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../cubit/onboarding_cubit.dart';
import '../cubit/onboarding_state.dart';
import '../cubit/onboarding_step.dart';
import 'onboarding_step_layout.dart';

class OnboardingNotificationsStep extends StatelessWidget {
  const OnboardingNotificationsStep({super.key});

  static const _switchDuration = Duration(milliseconds: 250);

  @override
  Widget build(BuildContext context) {
    return OnboardingStepLayout(
      step: OnboardingStep.notifications,
      child: BlocSelector<OnboardingCubit, OnboardingState, NotificationPromptState>(
        selector: (state) => state.notificationPrompt,
        builder: (context, prompt) => AnimatedSwitcher(
          duration: _switchDuration,
          child: switch (prompt) {
            NotificationPromptState.enabled => const _EnabledBadge(key: ValueKey('enabled')),
            NotificationPromptState.declined => const _DeniedHint(key: ValueKey('declined')),
            NotificationPromptState.ask ||
            NotificationPromptState.requesting =>
              _EnableButton(
                key: const ValueKey('ask'),
                isBusy: prompt == NotificationPromptState.requesting,
              ),
          },
        ),
      ),
    );
  }
}

class _EnableButton extends StatelessWidget {
  const _EnableButton({super.key, required this.isBusy});

  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: isBusy ? null : context.read<OnboardingCubit>().requestNotifications,
        icon: Icon(LucideIcons.bellRing, size: AppSizes.iconField),
        label: Text(context.l10n.onboardingNotificationsEnable),
      ),
    );
  }
}

class _EnabledBadge extends StatelessWidget {
  const _EnabledBadge({super.key});

  static const _backgroundOpacity = 0.12;

  @override
  Widget build(BuildContext context) {
    const color = AppColors.successColor;

    return Center(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color.withValues(alpha: _backgroundOpacity),
          borderRadius: AppRadius.pillRadius,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(LucideIcons.circleCheck, size: AppSizes.iconField, color: color),
              SizedBox(width: AppSpacing.xs),
              Text(
                context.l10n.onboardingNotificationsEnabled,
                style: context.textTheme.titleSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DeniedHint extends StatelessWidget {
  const _DeniedHint({super.key});

  @override
  Widget build(BuildContext context) {
    final color = context.colorScheme.onSurfaceVariant;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(LucideIcons.bellOff, size: AppSizes.iconField, color: color),
        SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            context.l10n.onboardingNotificationsDenied,
            style: context.textTheme.bodyMedium?.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}
