import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/locale_service.dart';
import '../../../../core/theme/app_spacing.dart';
import '../cubit/onboarding_step.dart';
import 'onboarding_choice_tile.dart';
import 'onboarding_step_layout.dart';

class OnboardingLanguageStep extends StatelessWidget {
  const OnboardingLanguageStep({super.key});

  static const _arabic = Locale('ar');
  static const _english = Locale('en');
  static const _arabicName = 'العربية';
  static const _englishName = 'English';

  @override
  Widget build(BuildContext context) {
    context.watch<LocaleService>();
    final service = context.read<LocaleService>();
    final selectedCode = service.languageCode;

    return OnboardingStepLayout(
      step: OnboardingStep.language,
      child: Column(
        children: [
          OnboardingChoiceTile(
            label: _arabicName,
            isSelected: selectedCode == _arabic.languageCode,
            onTap: () => service.setLocale(_arabic),
          ),
          SizedBox(height: AppSpacing.sm),
          OnboardingChoiceTile(
            label: _englishName,
            isSelected: selectedCode == _english.languageCode,
            onTap: () => service.setLocale(_english),
          ),
        ],
      ),
    );
  }
}
