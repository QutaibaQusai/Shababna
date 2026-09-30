import '../../../../core/config/app_assets.dart';
import '../../../../l10n/app_localizations.dart';

enum OnboardingStep {
  language(AppAssets.onboardingLanguage),
  volunteer(AppAssets.onboardingVolunteer),
  events(AppAssets.onboardingEvents),
  certificates(AppAssets.onboardingCertificates),
  theme(AppAssets.onboardingTheme),
  notifications(AppAssets.onboardingNotifications);

  const OnboardingStep(this.illustration);

  final String illustration;

  bool get isLast => this == values.last;

  String title(AppLocalizations l10n) => switch (this) {
        language => l10n.onboardingLanguageTitle,
        volunteer => l10n.onboardingVolunteerTitle,
        events => l10n.onboardingEventsTitle,
        certificates => l10n.onboardingCertificatesTitle,
        theme => l10n.onboardingThemeTitle,
        notifications => l10n.onboardingNotificationsTitle,
      };

  String subtitle(AppLocalizations l10n) => switch (this) {
        language => l10n.onboardingLanguageSubtitle,
        volunteer => l10n.onboardingVolunteerSubtitle,
        events => l10n.onboardingEventsSubtitle,
        certificates => l10n.onboardingCertificatesSubtitle,
        theme => l10n.onboardingThemeSubtitle,
        notifications => l10n.onboardingNotificationsSubtitle,
      };
}
