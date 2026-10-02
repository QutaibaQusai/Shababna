import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/services/theme_service.dart';
import '../../../../core/theme/app_spacing.dart';
import 'onboarding_glass_pill.dart';

class OnboardingThemeOptions extends StatelessWidget {
  const OnboardingThemeOptions({super.key});

  @override
  Widget build(BuildContext context) {
    final selected = context.watch<ThemeService>().state;
    final service = context.read<ThemeService>();
    final l10n = context.l10n;

    final options = [
      (ThemeMode.system, l10n.themeSystem, LucideIcons.smartphone),
      (ThemeMode.light, l10n.themeLight, LucideIcons.sun),
      (ThemeMode.dark, l10n.themeDark, LucideIcons.moon),
    ];

    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: [
        for (final (mode, label, icon) in options)
          OnboardingGlassPill(
            label: label,
            icon: icon,
            isSelected: selected == mode,
            onTap: () => service.setThemeMode(mode),
          ),
      ],
    );
  }
}
