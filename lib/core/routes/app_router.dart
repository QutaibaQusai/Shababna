import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/forgot_password/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login/login_page.dart';
import '../../features/auth/presentation/pages/register/register_page.dart';
import '../../features/auth/presentation/pages/reset_password/reset_password_args.dart';
import '../../features/auth/presentation/pages/reset_password/reset_password_page.dart';
import '../../features/auth/presentation/pages/verify_email/verify_email_page.dart';
import '../../features/auth/presentation/pages/verify_reset_code/verify_reset_code_page.dart';
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
          path: AppRoutes.verifyResetCode,
          name: AppRoutes.verifyResetCodeName,
          redirect: (context, state) =>
              state.extra is String ? null : AppRoutes.forgotPassword,
          builder: (context, state) =>
              VerifyResetCodePage(email: state.extra! as String),
        ),
        GoRoute(
          path: AppRoutes.resetPassword,
          name: AppRoutes.resetPasswordName,
          redirect: (context, state) =>
              state.extra is ResetPasswordArgs ? null : AppRoutes.forgotPassword,
          builder: (context, state) =>
              ResetPasswordPage(args: state.extra! as ResetPasswordArgs),
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
