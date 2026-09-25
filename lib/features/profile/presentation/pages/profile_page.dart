import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/locale_service.dart';
import '../../../../core/services/theme_service.dart';
import '../../../../core/shared/widgets/app_error_widget.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../legal/presentation/pages/legal_content_page.dart';
import '../cubit/profile_cubit.dart';
import '../../../auth/presentation/cubit/logout/logout_cubit.dart';
import '../widgets/language_sheet.dart';
import '../widgets/logout_sheet.dart';
import '../widgets/profile_header_skeleton.dart';
import '../widgets/profile_header_tile.dart';
import '../widgets/profile_menu_tile.dart';
import '../widgets/profile_toggle_tile.dart';
import '../widgets/theme_sheet.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProfileCubit>()..loadProfile(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  String _themeLabel(BuildContext context, ThemeMode mode) => switch (mode) {
        ThemeMode.system => context.l10n.themeSystem,
        ThemeMode.light => context.l10n.themeLight,
        ThemeMode.dark => context.l10n.themeDark,
      };

  void _openLanguageSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(
        value: context.read<LocaleService>(),
        child: const LanguageSheet(),
      ),
    );
  }

  void _openThemeSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(
        value: context.read<ThemeService>(),
        child: const ThemeSheet(),
      ),
    );
  }

  void _openLogoutSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => BlocProvider(
        create: (_) => sl<LogoutCubit>(),
        child: const LogoutSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ProfileCubit>().state;
    final themeMode = context.watch<ThemeService>().state;
    final languageCode = context.watch<LocaleService>().languageCode;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (state.errorMessage != null && !state.isLoading)
            AppErrorWidget(
              message: state.errorMessage!,
              onRetry: () => context.read<ProfileCubit>().loadProfile(),
            )
          else if (state.isLoading || state.profile == null)
            const ProfileHeaderSkeleton()
          else
            ProfileHeaderTile(profile: state.profile!),
          SizedBox(height: AppSpacing.xs),
          const Divider(height: 1),
          ProfileMenuTile(
            icon: LucideIcons.calendar,
            title: context.l10n.navEvents,
          ),
          ProfileMenuTile(
            icon: LucideIcons.newspaper,
            title: context.l10n.navNews,
          ),
          ProfileMenuTile(
            icon: LucideIcons.languages,
            title: context.l10n.profileMenuLanguage,
            value: languageCode == 'ar'
                ? context.l10n.languageArabic
                : context.l10n.languageEnglish,
            onTap: () => _openLanguageSheet(context),
          ),
          ProfileMenuTile(
            icon: LucideIcons.palette,
            title: context.l10n.profileMenuTheme,
            value: _themeLabel(context, themeMode),
            onTap: () => _openThemeSheet(context),
          ),
          const _NotificationsToggleTile(),
          ProfileMenuTile(
            icon: LucideIcons.info,
            title: context.l10n.profileMenuContactInfo,
            onTap: () => context.push(AppRoutes.contactInfo),
          ),
          ProfileMenuTile(
            icon: LucideIcons.messageCircle,
            title: context.l10n.profileMenuContactUs,
            onTap: () => context.push(AppRoutes.contactForm),
          ),
          ProfileMenuTile(
            icon: LucideIcons.users,
            title: context.l10n.profileMenuAboutUs,
            onTap: () => context.push(AppRoutes.aboutUs),
          ),
          ProfileMenuTile(
            icon: LucideIcons.share2,
            title: context.l10n.profileMenuSocialMedia,
            onTap: () => context.push(AppRoutes.socialMedia),
          ),
          ProfileMenuTile(
            icon: LucideIcons.shield,
            title: context.l10n.profileMenuPrivacyPolicy,
            onTap: () => context.push(
              AppRoutes.legalContent,
              extra: LegalDocumentType.privacyPolicy,
            ),
          ),
          ProfileMenuTile(
            icon: LucideIcons.fileText,
            title: context.l10n.profileMenuTermsAndConditions,
            onTap: () => context.push(
              AppRoutes.legalContent,
              extra: LegalDocumentType.termsAndConditions,
            ),
          ),
          ProfileMenuTile(
            icon: LucideIcons.power,
            title: context.l10n.profileMenuLogout,
            isDestructive: true,
            onTap: () => _openLogoutSheet(context),
          ),
        ],
      ),
    );
  }
}

class _NotificationsToggleTile extends StatefulWidget {
  const _NotificationsToggleTile();

  @override
  State<_NotificationsToggleTile> createState() => _NotificationsToggleTileState();
}

class _NotificationsToggleTileState extends State<_NotificationsToggleTile> {
  bool _enabled = true;

  @override
  Widget build(BuildContext context) {
    return ProfileToggleTile(
      icon: LucideIcons.bell,
      title: context.l10n.profileMenuNotifications,
      subtitle: context.l10n.profileMenuNotificationsSubtitle,
      value: _enabled,
      onChanged: (value) => setState(() => _enabled = value),
    );
  }
}
