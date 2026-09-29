import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../l10n/app_localizations.dart';

enum LayoutTab {
  home(LucideIcons.house),
  events(LucideIcons.calendarDays),
  profile(LucideIcons.userRound);

  const LayoutTab(this.icon);

  final IconData icon;

  bool get hasSearch => this != profile;

  bool get hasActions => this != profile;

  String label(AppLocalizations l10n) => switch (this) {
    home => l10n.navHome,
    events => l10n.navEvents,
    profile => l10n.navProfile,
  };
}
