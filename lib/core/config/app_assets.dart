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
}
