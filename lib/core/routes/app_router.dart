import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/forgot_password/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login/login_page.dart';
import '../../features/auth/presentation/pages/register/register_page.dart';
import '../../features/auth/presentation/pages/forgot_password/reset_password_args.dart';
import '../../features/auth/presentation/pages/forgot_password/reset_password_page.dart';
import '../../features/auth/presentation/pages/forgot_password/verify_reset_code_page.dart';
import '../../features/contact_form/presentation/pages/contact_form_page.dart';
import '../../features/contact_info/presentation/pages/contact_info_page.dart';
import '../../features/layout/presentation/pages/main_layout_page.dart';
import '../../features/legal/presentation/pages/legal_content_page.dart';
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
          builder: (context, state) => const MainLayoutPage(),
        ),
        GoRoute(
          path: AppRoutes.legalContent,
          name: AppRoutes.legalContentName,
          redirect: (context, state) =>
              state.extra is LegalDocumentType ? null : AppRoutes.home,
          builder: (context, state) =>
              LegalContentPage(documentType: state.extra! as LegalDocumentType),
        ),
        GoRoute(
          path: AppRoutes.contactInfo,
          name: AppRoutes.contactInfoName,
          builder: (context, state) => const ContactInfoPage(),
        ),
        GoRoute(
          path: AppRoutes.contactForm,
          name: AppRoutes.contactFormName,
          builder: (context, state) => const ContactFormPage(),
        ),
      ],
    );
  }
}
