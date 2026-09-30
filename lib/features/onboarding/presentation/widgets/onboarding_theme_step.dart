import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/services/theme_service.dart';
import '../../../../core/theme/app_spacing.dart';
import '../cubit/onboarding_step.dart';
import 'onboarding_choice_tile.dart';
import 'onboarding_step_layout.dart';

class OnboardingThemeStep extends StatelessWidget {
  const OnboardingThemeStep({super.key});

  @override
  Widget build(BuildContext context) {
    final selected = context.watch<ThemeService>().state;
    final service = context.read<ThemeService>();
    final l10n = context.l10n;

    final options = [
      (ThemeMode.system, LucideIcons.smartphone, l10n.themeSystem),
      (ThemeMode.light, LucideIcons.sun, l10n.themeLight),
      (ThemeMode.dark, LucideIcons.moon, l10n.themeDark),
    ];

    return OnboardingStepLayout(
      step: OnboardingStep.theme,
      child: Column(
        children: [
          for (final (index, (mode, icon, label)) in options.indexed) ...[
            if (index > 0) SizedBox(height: AppSpacing.sm),
            OnboardingChoiceTile(
              leading: Icon(icon),
              label: label,
              isSelected: selected == mode,
              onTap: () => service.setThemeMode(mode),
            ),
          ],
        ],
      ),
    );
  }
}
