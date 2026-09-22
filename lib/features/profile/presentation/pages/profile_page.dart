import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/services/locale_service.dart';
import '../../../../core/services/theme_service.dart';
import '../../../../core/shared/widgets/app_error_widget.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/repositories/profile_repository.dart';
import '../cubit/profile_cubit.dart';
import '../widgets/profile_header_tile.dart';
import '../widgets/profile_menu_tile.dart';
import '../widgets/profile_toggle_tile.dart';

const _placeholderProfile = Profile(
  fullNameEn: 'Loading Name',
  fullNameAr: 'الاسم قيد التحميل',
  email: 'loading@example.com',
  emailConfirmed: true,
  phoneNumber: null,
  profilePictureUrl: null,
  hasProfilePicture: false,
);

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
          else
            Skeletonizer(
              enabled: state.isLoading,
              child: ProfileHeaderTile(profile: state.profile ?? _placeholderProfile),
            ),
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
          ),
          ProfileMenuTile(
            icon: LucideIcons.palette,
            title: context.l10n.profileMenuTheme,
            value: _themeLabel(context, themeMode),
          ),
          const _NotificationsToggleTile(),
          ProfileMenuTile(
            icon: LucideIcons.messageCircle,
            title: context.l10n.profileMenuContactUs,
          ),
          ProfileMenuTile(
            icon: LucideIcons.shield,
            title: context.l10n.profileMenuPrivacyPolicy,
          ),
          ProfileMenuTile(
            icon: LucideIcons.logOut,
            title: context.l10n.profileMenuLogout,
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
