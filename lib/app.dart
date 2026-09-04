import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/service_locator.dart';
import 'core/extensions/context_extensions.dart';
import 'core/services/locale_service.dart';
import 'l10n/app_localizations.dart';

class ShababnaApp extends StatelessWidget {
  const ShababnaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LocaleService>(),
      child: Builder(
        builder: (context) {
          final locale = context.watch<LocaleService>().state;
          return MaterialApp(
            onGenerateTitle: (context) => context.l10n.appName,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            locale: locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (context) => Scaffold(
                body: Center(
                  child: Text(context.l10n.appName),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
