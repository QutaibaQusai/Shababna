import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/services/locale_service.dart';
import '../../../../../core/services/theme_service.dart';
import '../../../../../core/session/auth_session_cubit.dart';
import '../../../../../core/session/auth_status.dart';
import '../../../../../core/shared/widgets/app_error_widget.dart';
import '../../../../../core/shared/widgets/app_menu_tile.dart';
import '../../../../../core/shared/widgets/app_refresh_indicator.dart';
import '../../../../../core/shared/widgets/guest_gate.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../legal/presentation/pages/legal_content_page.dart';
import '../../cubit/profile/profile_cubit.dart';
import '../../../../auth/presentation/cubit/logout/logout_cubit.dart';
import '../../widgets/profile/guest_profile_header.dart';
import '../../widgets/profile/language_sheet.dart';
import '../../widgets/profile/logout_sheet.dart';
import '../../widgets/profile/profile_company_watermark.dart';
import '../../widgets/profile/profile_header_skeleton.dart';
import '../../widgets/profile/profile_header_tile.dart';
import '../../widgets/profile/theme_sheet.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(value: sl<ProfileCubit>(), child: const _ProfileView());
  }
}

class _ProfileView extends StatefulWidget {
  const _ProfileView();

  @override
  State<_ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<_ProfileView> {
  @override
  void initState() {
    super.initState();
    _loadIfMember(context.read<AuthSessionCubit>().state);
  }

  void _loadIfMember(AuthStatus status) {
    if (status.isAuthenticated) context.read<ProfileCubit>().ensureLoaded();
  }

  Future<void> _refreshIfMember() async {
    if (context.read<AuthSessionCubit>().state.isAuthenticated) {
      await context.read<ProfileCubit>().refresh(silent: true);
    }
  }

  Future<void> _openContactForm(BuildContext context) async {
    if (!await ensureSignedIn(context) || !context.mounted) return;
    context.push(AppRoutes.contactForm);
  }

  String _themeLabel(BuildContext context, ThemeMode mode) => switch (mode) {
    ThemeMode.system => context.l10n.themeSystem,
    ThemeMode.light => context.l10n.themeLight,
    ThemeMode.dark => context.l10n.themeDark,
  };

  void _openLanguageSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const LanguageSheet(),
    );
  }

  void _openThemeSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const ThemeSheet(),
    );
  }

  void _openLogoutSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => BlocProvider(create: (_) => sl<LogoutCubit>(), child: const LogoutSheet()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ProfileCubit>().state;
    final isGuest = !context.watch<AuthSessionCubit>().state.isAuthenticated;
    final themeMode = context.watch<ThemeService>().state;
    final languageCode = context.watch<LocaleService>().languageCode;

    final profile = state.profile;

    return MultiBlocListener(
      listeners: [
        BlocListener<AuthSessionCubit, AuthStatus>(
          listener: (context, status) => _loadIfMember(status),
        ),
        BlocListener<LocaleService, Locale?>(
          listenWhen: (previous, current) => previous != current,
          listener: (context, _) => _refreshIfMember(),
        ),
      ],
      child: AppRefreshIndicator(
        onRefresh: _refreshIfMember,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isGuest)
                const GuestProfileHeader()
              else if (profile != null)
                ProfileHeaderTile(profile: profile, pictureCacheKey: state.pictureCacheKey)
              else if (state.hasError)
                AppErrorWidget(
                  message: state.errorMessage ?? context.l10n.somethingWentWrong,
                  onRetry: () => context.read<ProfileCubit>().refresh(),
                )
              else
                const ProfileHeaderSkeleton(),
              SizedBox(height: AppSpacing.xs),
              const Divider(height: 1),
              if (!isGuest)
                AppMenuTile(
                  icon: LucideIcons.listTodo,
                  title: context.l10n.tasksMyTitle,
                  onTap: () => context.push(AppRoutes.tasks),
                ),
              if (!isGuest)
                AppMenuTile(
                  icon: LucideIcons.award,
                  title: context.l10n.certificatesMyTitle,
                  onTap: () => context.push(AppRoutes.certificates),
                ),
              AppMenuTile(
                icon: LucideIcons.newspaper,
                title: context.l10n.navNews,
                onTap: () => context.push(AppRoutes.news),
              ),
              AppMenuTile(
                icon: LucideIcons.languages,
                title: context.l10n.profileMenuLanguage,
                value: languageCode == 'ar'
                    ? context.l10n.languageArabic
                    : context.l10n.languageEnglish,
                onTap: () => _openLanguageSheet(context),
              ),
              AppMenuTile(
                icon: LucideIcons.palette,
                title: context.l10n.profileMenuTheme,
                value: _themeLabel(context, themeMode),
                onTap: () => _openThemeSheet(context),
              ),
              if (!isGuest)
                AppMenuTile(
                  icon: LucideIcons.bell,
                  title: context.l10n.profileMenuNotifications,
                  onTap: () => context.push(AppRoutes.notificationSettings),
                ),
              if (!isGuest)
                AppMenuTile(
                  icon: LucideIcons.shieldCheck,
                  title: context.l10n.profileMenuAccountSecurity,
                  onTap: () => context.push(AppRoutes.accountSecurity),
                ),
              AppMenuTile(
                icon: LucideIcons.info,
                title: context.l10n.profileMenuContactInfo,
                onTap: () => context.push(AppRoutes.contactInfo),
              ),
              AppMenuTile(
                icon: LucideIcons.messageCircle,
                title: context.l10n.profileMenuContactUs,
                onTap: () => _openContactForm(context),
              ),
              AppMenuTile(
                icon: LucideIcons.users,
                title: context.l10n.profileMenuAboutUs,
                onTap: () => context.push(AppRoutes.aboutUs),
              ),
              AppMenuTile(
                icon: LucideIcons.share2,
                title: context.l10n.profileMenuSocialMedia,
                onTap: () => context.push(AppRoutes.socialMedia),
              ),
              AppMenuTile(
                icon: LucideIcons.shield,
                title: context.l10n.profileMenuPrivacyPolicy,
                onTap: () =>
                    context.push(AppRoutes.legalContent, extra: LegalDocumentType.privacyPolicy),
              ),
              AppMenuTile(
                icon: LucideIcons.fileText,
                title: context.l10n.profileMenuTermsAndConditions,
                onTap: () => context.push(
                  AppRoutes.legalContent,
                  extra: LegalDocumentType.termsAndConditions,
                ),
              ),
              if (!isGuest)
                AppMenuTile(
                  icon: LucideIcons.power,
                  title: context.l10n.profileMenuLogout,
                  isDestructive: true,
                  onTap: () => _openLogoutSheet(context),
                ),
              const ProfileCompanyWatermark(),
            ],
          ),
        ),
      ),
    );
  }
}
