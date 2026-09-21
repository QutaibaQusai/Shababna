import '../../../../core/config/app_assets.dart';
import '../../../../l10n/app_localizations.dart';

enum LayoutTab {
  home(AppAssets.iconHome),
  news(AppAssets.iconNews),
  events(AppAssets.iconCalendar),
  profile(AppAssets.iconProfile);

  const LayoutTab(this.iconAsset);

  final String iconAsset;

  bool get hasSearch => this != profile;

  String label(AppLocalizations l10n) => switch (this) {
    home => l10n.navHome,
    news => l10n.navNews,
    events => l10n.navEvents,
    profile => l10n.navProfile,
  };
}
