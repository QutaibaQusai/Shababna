import 'package:flutter/widgets.dart';

class AppAssets {
  AppAssets._();

  static const String logo = 'assets/images/logo.png';
  static const String logoLight = 'assets/images/logo_splash.png';
  static const String logoIcon = 'assets/images/logo_icon.png';
  static const String logoPlaceholder = 'assets/images/logo_placeholder.png';

  static String logoFor(Brightness brightness) =>
      brightness == Brightness.dark ? logoLight : logo;

  static const String iconHome = 'assets/images/icon_home.svg';
  static const String iconNews = 'assets/images/icon_news.svg';
  static const String iconCalendar = 'assets/images/icon_calendar.svg';
  static const String iconProfile = 'assets/images/icon_profile.svg';
  static const String iconNotification =
      'assets/images/icon_notification_2.svg';

  static const String illustrationSearch = 'assets/images/illustration_search.svg';

  static const String onboardingLanguage = 'assets/images/onboarding_language.svg';
  static const String onboardingVolunteer = 'assets/images/onboarding_volunteer.svg';
  static const String onboardingEvents = 'assets/images/onboarding_events.svg';
  static const String onboardingCertificates = 'assets/images/onboarding_certificates.svg';
  static const String onboardingTheme = 'assets/images/onboarding_theme.svg';
  static const String onboardingNotifications = 'assets/images/onboarding_notifications.svg';

  static const String assistantAnimation = 'assets/animations/assistant_robot.json';
}
