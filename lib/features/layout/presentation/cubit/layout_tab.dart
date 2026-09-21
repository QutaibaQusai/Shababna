import 'package:flutter/cupertino.dart';

import '../../../../l10n/app_localizations.dart';

enum LayoutTab {
  home(CupertinoIcons.house, showsLogoWhenSelected: true),
  news(CupertinoIcons.news, activeIcon: CupertinoIcons.news_solid),
  events(CupertinoIcons.calendar, activeIcon: CupertinoIcons.calendar_today),
  profile(CupertinoIcons.person, activeIcon: CupertinoIcons.person_fill);

  const LayoutTab(
    this.icon, {
    this.activeIcon,
    this.showsLogoWhenSelected = false,
  });

  final IconData icon;
  final IconData? activeIcon;
  final bool showsLogoWhenSelected;

  bool get hasSearch => this != profile;

  String label(AppLocalizations l10n) => switch (this) {
    home => l10n.navHome,
    news => l10n.navNews,
    events => l10n.navEvents,
    profile => l10n.navProfile,
  };
}
