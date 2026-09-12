import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../dev/component_showcase_page.dart';
import '../config/app_config.dart';
import '../extensions/context_extensions.dart';
import 'app_routes.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.componentShowcase,
    routes: [
      GoRoute(
        path: AppRoutes.home,
        name: AppRoutes.homeName,
        builder: (context, state) => Scaffold(
          body: Center(
            child: Text(context.l10n.appName),
          ),
        ),
      ),
      if (AppConfig.isDevelopment)
        GoRoute(
          path: AppRoutes.componentShowcase,
          name: AppRoutes.componentShowcaseName,
          builder: (context, state) => const ComponentShowcasePage(),
        ),
    ],
  );
}
