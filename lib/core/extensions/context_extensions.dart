import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

extension BuildContextLocaleX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
  Locale get locale => Localizations.localeOf(this);
  bool get isArabic => Localizations.localeOf(this).languageCode == 'ar';
  bool get isRTL => Directionality.of(this) == TextDirection.rtl;
}

extension BuildContextThemeX on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}