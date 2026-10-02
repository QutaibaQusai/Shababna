import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/services/locale_service.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import 'onboarding_palette.dart';

class OnboardingLanguagePill extends StatelessWidget {
  const OnboardingLanguagePill({super.key});

  static const _arabic = Locale('ar');
  static const _english = Locale('en');
  static const _switchToEnglish = '?English';
  static const _switchToArabic = 'عربي؟';

  @override
  Widget build(BuildContext context) {
    context.watch<LocaleService>();
    final service = context.read<LocaleService>();
    final isArabic = service.languageCode == _arabic.languageCode;

    return Semantics(
      button: true,
      child: InkWell(
        borderRadius: AppRadius.pillRadius,
        onTap: () {
          HapticFeedback.selectionClick();
          service.setLocale(isArabic ? _english : _arabic);
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.xxs, vertical: AppSpacing.xs),
          child: Text(
            isArabic ? _switchToEnglish : _switchToArabic,
            style: context.textTheme.titleMedium?.copyWith(
              color: OnboardingPalette.foreground,
              fontWeight: FontWeight.w700,
              fontFamily: isArabic
                  ? AppTypography.fontFamilyLatin
                  : AppTypography.fontFamilyArabic,
            ),
          ),
        ),
      ),
    );
  }
}
