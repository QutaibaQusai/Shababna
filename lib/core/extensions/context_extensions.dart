import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

extension BuildContextLocaleX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
  Locale get locale => Localizations.localeOf(this);
  bool get isArabic => Localizations.localeOf(this).languageCode == 'ar';
  bool get isRTL => Directionality.of(this) == TextDirection.rtl;
}