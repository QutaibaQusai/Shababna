import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../l10n/app_localizations.dart';

enum LayoutTab {
  home(LucideIcons.house),
  news(LucideIcons.newspaper),
  events(LucideIcons.calendar),
  profile(LucideIcons.user);

  const LayoutTab(this.icon);

  final IconData icon;

  bool get hasSearch => this != profile;

  String label(AppLocalizations l10n) => switch (this) {
    home => l10n.navHome,
    news => l10n.navNews,
    events => l10n.navEvents,
    profile => l10n.navProfile,
  };
}
