import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import '../cubit/onboarding_cubit.dart';
import '../cubit/onboarding_state.dart';
import 'onboarding_glass_pill.dart';
import 'onboarding_palette.dart';

class OnboardingNotificationsAction extends StatelessWidget {
  const OnboardingNotificationsAction({super.key});

  static const _switchDuration = Duration(milliseconds: 250);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocSelector<OnboardingCubit, OnboardingState, NotificationPromptState>(
      selector: (state) => state.notificationPrompt,
      builder: (context, prompt) => AnimatedSwitcher(
        duration: _switchDuration,
        child: switch (prompt) {
          NotificationPromptState.enabled => _StatusLine(
              key: const ValueKey('enabled'),
              icon: LucideIcons.circleCheck,
              text: l10n.onboardingNotificationsEnabled,
              color: AppColors.successColor,
            ),
          NotificationPromptState.declined => _StatusLine(
              key: const ValueKey('declined'),
              icon: LucideIcons.bellOff,
              text: l10n.onboardingNotificationsDenied,
              color: OnboardingPalette.muted,
            ),
          NotificationPromptState.ask || NotificationPromptState.requesting => OnboardingGlassPill(
              key: const ValueKey('ask'),
              icon: LucideIcons.bellRing,
              label: l10n.onboardingNotificationsEnable,
              onTap: prompt == NotificationPromptState.requesting
                  ? null
                  : context.read<OnboardingCubit>().requestNotifications,
            ),
        },
      ),
    );
  }
}

class _StatusLine extends StatelessWidget {
  const _StatusLine({super.key, required this.icon, required this.text, required this.color});

  final IconData icon;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: AppSizes.iconField, color: color),
        SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            text,
            style: context.textTheme.bodyMedium?.copyWith(color: color, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
