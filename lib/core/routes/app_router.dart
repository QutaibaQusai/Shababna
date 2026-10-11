import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/forgot_password/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login/login_page.dart';
import '../../features/auth/presentation/pages/register/register_page.dart';
import '../../features/auth/presentation/pages/forgot_password/reset_password_args.dart';
import '../../features/auth/presentation/pages/forgot_password/reset_password_page.dart';
import '../../features/auth/presentation/pages/forgot_password/verify_reset_code_page.dart';
import '../../features/about_us/presentation/pages/about_us_page.dart';
import '../../features/contact_form/presentation/pages/contact_form_page.dart';
import '../../features/contact_info/presentation/pages/contact_info_page.dart';
import '../../features/layout/presentation/pages/main_layout_page.dart';
import '../../features/legal/presentation/pages/legal_content_page.dart';
import '../../features/chatbot/presentation/pages/chatbot_page.dart';
import '../../features/volunteering_opportunities/presentation/pages/volunteering_opportunity_details_page.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/presentation/pages/slider/home_slide_details_page.dart';
import '../../features/news/presentation/pages/news_details/news_details_page.dart';
import '../../features/news/presentation/pages/news_list/news_list_page.dart';
import '../../features/news/presentation/pages/news_search/news_search_page.dart';
import '../../features/onboarding/domain/repositories/onboarding_repository.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/profile/presentation/pages/account_security/account_security_page.dart';
import '../../features/profile/presentation/pages/change_email/change_email_page.dart';
import '../../features/profile/presentation/pages/change_email/verify_email_change_page.dart';
import '../../features/profile/presentation/pages/change_password/change_password_page.dart';
import '../../features/profile/presentation/pages/delete_account/delete_account_page.dart';
import '../../features/profile/presentation/pages/change_phone_number/change_phone_number_page.dart';
import '../../features/profile/presentation/pages/edit_profile/edit_profile_page.dart';
import '../../features/search/presentation/pages/global_search_page.dart';
import '../../features/tasks/presentation/pages/task_details_page.dart';
import '../../features/tasks/presentation/pages/task_submission_page.dart';
import '../../features/tasks/presentation/pages/tasks_page.dart';
import '../../features/social_media/presentation/pages/social_media_page.dart';
import '../shared/views/app_web_view_page.dart';
import '../session/auth_session_cubit.dart';
import '../session/auth_status.dart';
import 'app_routes.dart';
import 'go_router_refresh_stream.dart';

class AppRouter {
  AppRouter._();

  static GoRouter build({
    required AuthSessionCubit authSessionCubit,
    required OnboardingRepository onboardingRepository,
  }) {
    return GoRouter(
      initialLocation: AppRoutes.home,
      debugLogDiagnostics: true,
      refreshListenable: GoRouterRefreshStream(authSessionCubit.stream),
      redirect: (context, state) {
        final location = state.matchedLocation;
        final isPublicRoute = AppRoutes.publicRoutes.contains(location);
        final isOnboarding = location == AppRoutes.onboarding;

        if (authSessionCubit.state == AuthStatus.unauthenticated) {
          if (!onboardingRepository.isCompleted) {
            return isOnboarding ? null : AppRoutes.onboarding;
          }
          if (isOnboarding) return AppRoutes.login;
        }

        return switch (authSessionCubit.state) {
          AuthStatus.authenticated => isPublicRoute ? AppRoutes.home : null,
          AuthStatus.guest =>
            AppRoutes.memberRoutes.contains(location) ? AppRoutes.login : null,
          AuthStatus.unauthenticated => isPublicRoute ? null : AppRoutes.login,
        };
      },
      routes: [
        GoRoute(
          path: AppRoutes.onboarding,
          name: AppRoutes.onboardingName,
          builder: (context, state) => const OnboardingPage(),
        ),
        GoRoute(
          path: AppRoutes.login,
          name: AppRoutes.loginName,
          pageBuilder: (context, state) {
            final isModal = state.uri.queryParameters[AppRoutes.modalQuery] == 'true';
            if (!isModal) return MaterialPage(key: state.pageKey, child: const LoginPage());
            return CustomTransitionPage(
              key: state.pageKey,
              fullscreenDialog: true,
              child: const LoginPage(isModal: true),
              transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                  SlideTransition(
                    position: Tween(begin: const Offset(0, 1), end: Offset.zero)
                        .chain(CurveTween(curve: Curves.easeOutCubic))
                        .animate(animation),
                    child: child,
                  ),
            );
          },
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
          path: AppRoutes.news,
          name: AppRoutes.newsName,
          builder: (context, state) => const NewsListPage(),
        ),
        GoRoute(
          path: AppRoutes.assistant,
          name: AppRoutes.assistantName,
          builder: (context, state) => ChatbotPage(
            topicId: state.uri.queryParameters['topicId'],
            questionId: state.uri.queryParameters['questionId'],
          ),
        ),
        GoRoute(
          path: AppRoutes.search,
          name: AppRoutes.searchName,
          builder: (context, state) => const GlobalSearchPage(),
        ),
        GoRoute(
          path: AppRoutes.newsSearch,
          name: AppRoutes.newsSearchName,
          builder: (context, state) => const NewsSearchPage(),
        ),
        GoRoute(
          path: AppRoutes.newsDetails,
          name: AppRoutes.newsDetailsName,
          builder: (context, state) => NewsDetailsPage(id: state.pathParameters['id']!),
        ),
        GoRoute(
          path: AppRoutes.volunteeringOpportunityDetails,
          name: AppRoutes.volunteeringOpportunityDetailsName,
          builder: (context, state) =>
              VolunteeringOpportunityDetailsPage(id: state.pathParameters['id']!),
        ),
        GoRoute(
          path: AppRoutes.homeSlide,
          name: AppRoutes.homeSlideName,
          redirect: (context, state) => state.extra is HomeSlide ? null : AppRoutes.home,
          builder: (context, state) => HomeSlideDetailsPage(slide: state.extra! as HomeSlide),
        ),
        GoRoute(
          path: AppRoutes.tasks,
          name: AppRoutes.tasksName,
          builder: (context, state) => TasksPage(
            volunteeringOpportunityId:
                state.uri.queryParameters[AppRoutes.volunteeringOpportunityIdQuery],
          ),
        ),
        GoRoute(
          path: AppRoutes.taskSubmit,
          name: AppRoutes.taskSubmitName,
          redirect: (context, state) =>
              authSessionCubit.state.isAuthenticated ? null : AppRoutes.login,
          builder: (context, state) => TaskSubmissionPage(taskId: state.pathParameters['id']!),
        ),
        GoRoute(
          path: AppRoutes.taskDetails,
          name: AppRoutes.taskDetailsName,
          builder: (context, state) => TaskDetailsPage(id: state.pathParameters['id']!),
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
        GoRoute(
          path: AppRoutes.aboutUs,
          name: AppRoutes.aboutUsName,
          builder: (context, state) => const AboutUsPage(),
        ),
        GoRoute(
          path: AppRoutes.socialMedia,
          name: AppRoutes.socialMediaName,
          builder: (context, state) => const SocialMediaPage(),
        ),
        GoRoute(
          path: AppRoutes.webView,
          name: AppRoutes.webViewName,
          builder: (context, state) => AppWebViewPage(
            url: state.uri.queryParameters['url'] ?? '',
            title: state.uri.queryParameters['title'] ?? '',
          ),
        ),
        GoRoute(
          path: AppRoutes.accountSecurity,
          name: AppRoutes.accountSecurityName,
          builder: (context, state) => const AccountSecurityPage(),
        ),
        GoRoute(
          path: AppRoutes.changePassword,
          name: AppRoutes.changePasswordName,
          builder: (context, state) => const ChangePasswordPage(),
        ),
        GoRoute(
          path: AppRoutes.deleteAccount,
          name: AppRoutes.deleteAccountName,
          builder: (context, state) => const DeleteAccountPage(),
        ),
        GoRoute(
          path: AppRoutes.editProfile,
          name: AppRoutes.editProfileName,
          builder: (context, state) => EditProfilePage(
            missingFields: switch (state.extra) {
              final List<String> fields => fields,
              _ => const [],
            },
          ),
        ),
        GoRoute(
          path: AppRoutes.changePhoneNumber,
          name: AppRoutes.changePhoneNumberName,
          builder: (context, state) => const ChangePhoneNumberPage(),
        ),
        GoRoute(
          path: AppRoutes.changeEmail,
          name: AppRoutes.changeEmailName,
          builder: (context, state) => const ChangeEmailPage(),
        ),
        GoRoute(
          path: AppRoutes.verifyEmailChange,
          name: AppRoutes.verifyEmailChangeName,
          redirect: (context, state) => state.extra is String ? null : AppRoutes.editProfile,
          builder: (context, state) => VerifyEmailChangePage(newEmail: state.extra! as String),
        ),
      ],
    );
  }
}
