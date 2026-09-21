import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

enum LayoutTab {
  home(Icons.home_outlined, Icons.home),
  news(Icons.newspaper_outlined, Icons.newspaper),
  events(Icons.event_outlined, Icons.event),
  profile(Icons.person_outline, Icons.person);

  const LayoutTab(this.icon, this.activeIcon);

  final IconData icon;
  final IconData activeIcon;

  bool get hasSearch => this != profile;

  String label(AppLocalizations l10n) => switch (this) {
    home => l10n.navHome,
    news => l10n.navNews,
    events => l10n.navEvents,
    profile => l10n.navProfile,
  };
}
