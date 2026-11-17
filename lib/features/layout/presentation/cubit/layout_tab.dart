import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../l10n/app_localizations.dart';

enum LayoutNavAction { assistant, filter }

enum LayoutTab {
  home(LucideIcons.house),
  volunteeringOpportunities(LucideIcons.calendarDays),
  contactInfo(LucideIcons.phone),
  contactForm(LucideIcons.messageCircle);

  const LayoutTab(this.icon);

  final IconData icon;

  bool get hasSearch => hasActions;

  bool get hasActions => this == home || this == volunteeringOpportunities;

  LayoutNavAction? get navAction => switch (this) {
    home => LayoutNavAction.assistant,
    volunteeringOpportunities => LayoutNavAction.filter,
    contactInfo || contactForm => null,
  };

  String label(AppLocalizations l10n) => switch (this) {
    home => l10n.navHome,
    volunteeringOpportunities => l10n.navVolunteeringOpportunities,
    contactInfo => l10n.profileMenuContactInfo,
    contactForm => l10n.profileMenuContactUs,
  };

  String navLabel(AppLocalizations l10n) => switch (this) {
    home => l10n.navHome,
    volunteeringOpportunities => l10n.navVolunteerShort,
    contactInfo => l10n.navInfoShort,
    contactForm => l10n.navContactShort,
  };
}
