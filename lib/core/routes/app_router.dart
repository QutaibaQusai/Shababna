import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/reset_password_page.dart';
import '../../features/auth/presentation/pages/verify_email_page.dart';
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
      debugLogDiagnostics: true,
      refreshListenable: GoRouterRefreshStream(authSessionCubit.stream),
      redirect: (context, state) {
        final isAuthenticated =
            authSessionCubit.state == AuthStatus.authenticated;
        final isPublicRoute =
            AppRoutes.publicRoutes.contains(state.matchedLocation);

        if (!isAuthenticated && !isPublicRoute) return AppRoutes.login;
        if (isAuthenticated && isPublicRoute) return AppRoutes.home;
        return null;
      },
      routes: [
        GoRoute(
          path: AppRoutes.login,
          name: AppRoutes.loginName,
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: AppRoutes.register,
          name: AppRoutes.registerName,
          builder: (context, state) => const RegisterPage(),
        ),
        GoRoute(
          path: AppRoutes.verifyEmail,
          name: AppRoutes.verifyEmailName,
          builder: (context, state) =>
              VerifyEmailPage(email: state.extra as String? ?? ''),
        ),
        GoRoute(
          path: AppRoutes.forgotPassword,
          name: AppRoutes.forgotPasswordName,
          builder: (context, state) => const ForgotPasswordPage(),
        ),
        GoRoute(
          path: AppRoutes.resetPassword,
          name: AppRoutes.resetPasswordName,
          builder: (context, state) =>
              ResetPasswordPage(email: state.extra as String? ?? ''),
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
