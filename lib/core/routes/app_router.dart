import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../extensions/context_extensions.dart';
import '../session/auth_session_cubit.dart';
import '../session/auth_status.dart';
import 'app_routes.dart';
import 'go_router_refresh_stream.dart';

class AppRouter {
  AppRouter._();

  static GoRouter build({required AuthSessionCubit authSessionCubit}) {
    return GoRouter(
      initialLocation: AppRoutes.home,
      refreshListenable: GoRouterRefreshStream(authSessionCubit.stream),
      redirect: (context, state) {
        final isAuthenticated =
            authSessionCubit.state == AuthStatus.authenticated;
        final isLoggingIn = state.matchedLocation == AppRoutes.login;

        if (!isAuthenticated && !isLoggingIn) return AppRoutes.login;
        if (isAuthenticated && isLoggingIn) return AppRoutes.home;
        return null;
      },
      routes: [
        GoRoute(
          path: AppRoutes.login,
          name: AppRoutes.loginName,
          builder: (context, state) => Scaffold(
            body: Center(child: Text('Login (placeholder)')),
          ),
        ),
        GoRoute(
          path: AppRoutes.home,
          name: AppRoutes.homeName,
          builder: (context, state) => Scaffold(
            body: Center(
              child: Text(context.l10n.appName),
            ),
          ),
        ),
      ],
    );
  }
}
