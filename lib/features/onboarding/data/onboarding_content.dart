import '../../../l10n/app_localizations.dart';
import '../domain/entities/onboarding_item.dart';

/// Onboarding content is static and bundled with the app - it is not
/// fetched from an API, so this is a plain localized list rather than a
/// repository/data-source abstraction.
class OnboardingContent {
  OnboardingContent._();

  static List<OnboardingItem> items(AppLocalizations l10n) => [
    OnboardingItem(
      title: l10n.onboardingTitle1,
      description: l10n.onboardingDescription1,
      imageUrl: 'assets/images/onboarding_1.png',
    ),
    OnboardingItem(
      title: l10n.onboardingTitle2,
      description: l10n.onboardingDescription2,
      imageUrl: 'assets/images/onboarding_2.png',
    ),
    OnboardingItem(
      title: l10n.onboardingTitle3,
      description: l10n.onboardingDescription3,
      imageUrl: 'assets/images/onboarding_3.png',
    ),
  ];
}
