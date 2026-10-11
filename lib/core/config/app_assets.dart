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
  static const String iconTrophy = 'assets/images/icon_trophy.png';
  static const String iconHourglass = 'assets/images/icon_hourglass.png';
  static const String iconCertificate = 'assets/images/icon_certificate.svg';
  static const String iconAssociationHeart = 'assets/images/icon_about_association.svg';

  static const String illustrationSearch = 'assets/images/illustration_search.svg';
  static const String illustrationEmpty = 'assets/images/illustration_empty.svg';
  static const String illustrationWarning = 'assets/images/illustration_warning.svg';
  static const String illustrationSecureLogin = 'assets/images/illustration_secure_login.svg';
  static const String illustrationAppLock = 'assets/images/illustration_app_lock.svg';
  static const String illustrationCertificates = 'assets/images/illustration_certificates.svg';
  static const String illustrationTasks = 'assets/images/illustration_tasks.svg';
  static const String illustrationTasksDone = 'assets/images/illustration_tasks_done.svg';
  static const String illustrationTasksReview = 'assets/images/illustration_tasks_review.svg';
  static const String illustrationTasksCompleted =
      'assets/images/illustration_tasks_completed.svg';

  static const String onboardingVolunteer = 'assets/images/onboarding_volunteer.jpg';
  static const String onboardingVolunteeringOpportunities =
      'assets/images/onboarding_volunteering_opportunities.jpg';
  static const String onboardingCertificates = 'assets/images/onboarding_certificates.jpg';
  static const String onboardingTheme = 'assets/images/onboarding_theme.jpg';
  static const String onboardingNotifications = 'assets/images/onboarding_notifications.jpg';

  static const String assistantAnimation = 'assets/animations/assistant_robot.json';
}
