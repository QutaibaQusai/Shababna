import '../../../../core/config/app_assets.dart';
import '../../../../l10n/app_localizations.dart';

enum LayoutTab {
  home(AppAssets.iconHome),
  events(AppAssets.iconCalendar),
  profile(AppAssets.iconProfile);

  const LayoutTab(this.iconAsset);

  final String iconAsset;

  bool get hasSearch => this != profile;

  bool get hasActions => this != profile;

  String label(AppLocalizations l10n) => switch (this) {
    home => l10n.navHome,
    events => l10n.navEvents,
    profile => l10n.navProfile,
  };
}
