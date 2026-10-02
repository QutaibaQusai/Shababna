import '../../../../core/config/app_assets.dart';
import '../../../../l10n/app_localizations.dart';

enum OnboardingStep {
  volunteer(AppAssets.onboardingVolunteer),
  events(AppAssets.onboardingEvents),
  certificates(AppAssets.onboardingCertificates),
  theme(AppAssets.onboardingTheme),
  notifications(AppAssets.onboardingNotifications);

  const OnboardingStep(this.image);

  final String image;

  bool get isLast => this == values.last;

  String titleLead(AppLocalizations l10n) => switch (this) {
        volunteer => l10n.onboardingVolunteerTitle,
        events => l10n.onboardingEventsTitle,
        certificates => l10n.onboardingCertificatesTitle,
        theme => l10n.onboardingThemeTitle,
        notifications => l10n.onboardingNotificationsTitle,
      };

  String highlight(AppLocalizations l10n) => switch (this) {
        volunteer => l10n.onboardingVolunteerHighlight,
        events => l10n.onboardingEventsHighlight,
        certificates => l10n.onboardingCertificatesHighlight,
        theme => l10n.onboardingThemeHighlight,
        notifications => l10n.onboardingNotificationsHighlight,
      };

  String subtitle(AppLocalizations l10n) => switch (this) {
        volunteer => l10n.onboardingVolunteerSubtitle,
        events => l10n.onboardingEventsSubtitle,
        certificates => l10n.onboardingCertificatesSubtitle,
        theme => l10n.onboardingThemeSubtitle,
        notifications => l10n.onboardingNotificationsSubtitle,
      };
}
