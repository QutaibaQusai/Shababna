import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'core/di/service_locator.dart';
import 'core/extensions/context_extensions.dart';
import 'core/security/app_lock/app_lock_cubit.dart';
import 'core/security/app_lock/app_lock_gate.dart';
import 'core/services/locale_service.dart';
import 'core/services/theme_service.dart';
import 'core/session/auth_session_cubit.dart';
import 'core/theme/app_sizes.dart';
import 'core/theme/app_typography.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/cubit/logout/logout_cubit.dart';
import 'l10n/app_localizations.dart';

class ShababnaApp extends StatelessWidget {
  const ShababnaApp({super.key});

  static Future<void> _signOut() async {
    final logout = sl<LogoutCubit>();
    await logout.logout();
    await logout.close();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilPlusInit(
      designSize: AppSizes.designSize,
      minTextAdapt: true,
      builder: (_, _) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => sl<LocaleService>()),
          BlocProvider(create: (_) => sl<ThemeService>()),
          BlocProvider(create: (_) => sl<AuthSessionCubit>()),
          BlocProvider(create: (_) => sl<AppLockCubit>()),
        ],
        child: Builder(
          builder: (context) {
            final locale = context.watch<LocaleService>().state;
            final themeMode = context.watch<ThemeService>().state;
            final effectiveLocale =
                locale ?? WidgetsBinding.instance.platformDispatcher.locale;
            final fontFamily = effectiveLocale.languageCode == 'ar'
                ? AppTypography.fontFamilyArabic
                : AppTypography.fontFamilyLatin;
            return MaterialApp.router(
              onGenerateTitle: (context) => context.l10n.appName,
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light(fontFamily: fontFamily),
              darkTheme: AppTheme.dark(fontFamily: fontFamily),
              themeMode: themeMode,
              locale: locale,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              routerConfig: sl<GoRouter>(),
              builder: (context, child) => SkeletonizerConfig(
                data: SkeletonizerConfigData(brightness: Theme.of(context).brightness),
                child: AppLockGate(
                  onSignOut: _signOut,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                    child: child,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
