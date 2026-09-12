import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import 'core/di/service_locator.dart';
import 'core/extensions/context_extensions.dart';
import 'core/services/locale_service.dart';
import 'core/routes/app_router.dart';
import 'core/services/theme_service.dart';
import 'core/theme/app_dimensions.dart';
import 'core/theme/app_text_styles.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';

class ShababnaApp extends StatelessWidget {
  const ShababnaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilPlusInit(
      designSize: AppDimensions.designSize,
      minTextAdapt: true,
      builder: (_, _) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => sl<LocaleService>()),
          BlocProvider(create: (_) => sl<ThemeService>()),
        ],
        child: Builder(
          builder: (context) {
            final locale = context.watch<LocaleService>().state;
            final themeMode = context.watch<ThemeService>().state;
            return MaterialApp.router(
              onGenerateTitle: (context) => context.l10n.appName,
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light(fontFamily: AppTextStyles.fontFamily),
              darkTheme: AppTheme.dark(fontFamily: AppTextStyles.fontFamily),
              themeMode: themeMode,
              locale: locale,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              routerConfig: AppRouter.router,
              builder: (context, child) => GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                child: child,
              ),
            );
          },
        ),
      ),
    );
  }
}
