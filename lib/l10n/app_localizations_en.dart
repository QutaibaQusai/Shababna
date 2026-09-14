// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Shababna';

  @override
  String get retry => 'Retry';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get noItemsFound => 'No items found';

  @override
  String get onboardingTitle1 => 'Join the Youth Network';

  @override
  String get onboardingDescription1 =>
      'Connect with thousands of young Jordanians making a positive impact in their communities through volunteering and leadership.';

  @override
  String get onboardingTitle2 => 'Learn & Grow';

  @override
  String get onboardingDescription2 =>
      'Access high-quality educational resources on physical fitness, mental well-being, and healthy lifestyles tailored for you.';

  @override
  String get onboardingTitle3 => 'Make a Difference';

  @override
  String get onboardingDescription3 =>
      'Participate in local initiatives, track your volunteer hours, and become a certified health ambassador in your city.';
}
