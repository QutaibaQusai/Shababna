import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:local_auth/local_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/about_us/about_us_injection.dart';
import '../../features/auth/auth_injection.dart';
import '../../features/contact_form/contact_form_injection.dart';
import '../../features/chatbot/chatbot_injection.dart';
import '../../features/contact_info/contact_info_injection.dart';
import '../../features/legal/legal_injection.dart';
import '../../features/volunteering_opportunities/volunteering_opportunities_injection.dart';
import '../../features/home/home_injection.dart';
import '../../features/news/news_injection.dart';
import '../../features/search/search_injection.dart';
import '../../features/tasks/tasks_injection.dart';
import '../../features/certificates/certificates_injection.dart';
import '../../features/onboarding/domain/repositories/onboarding_repository.dart';
import '../../features/onboarding/onboarding_injection.dart';
import '../../features/profile/profile_injection.dart';
import '../../features/social_media/social_media_injection.dart';
import '../logging/app_logger.dart';
import '../network/api_consumer.dart';
import '../network/dio_consumer.dart';
import '../notifications/notification_permission_service.dart';
import '../routes/app_router.dart';
import '../security/app_lock/app_lock_cubit.dart';
import '../security/device_authenticator.dart';
import '../services/device_identity_service.dart';
import '../services/locale_service.dart';
import '../services/theme_service.dart';
import '../session/auth_session_cubit.dart';
import '../session/auth_status.dart';
import '../storage/local_storage.dart';
import '../storage/secure_storage.dart';
import '../storage/storage_keys.dart';

final sl = GetIt.instance;

Future<void> setupServiceLocator() async {
  sl.registerLazySingleton<AppLogger>(() => AppLoggerImpl());

  final prefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(prefs);
  sl.registerLazySingleton<AppLocalStorage>(() => LocalStorageImpl(sl()));
  sl.registerLazySingleton<AppSecureStorage>(
    () => const SecureStorageImpl(
      FlutterSecureStorage(
        iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
      ),
    ),
  );

  sl.registerLazySingleton<DeviceIdentityService>(
    () => DeviceIdentityService(sl()),
  );

  final secureStorage = sl<AppSecureStorage>();
  final hasStoredSession =
      await secureStorage.read(StorageKeys.accessToken) != null;
  final isGuest = sl<AppLocalStorage>().getBool(StorageKeys.guestMode) ?? false;
  final isAppLockEnabled = await secureStorage.read(StorageKeys.appLockEnabled) != null;
  sl.registerLazySingleton<AuthSessionCubit>(
    () => AuthSessionCubit(
      sl(),
      sl(),
      initialStatus: hasStoredSession
          ? AuthStatus.authenticated
          : isGuest
              ? AuthStatus.guest
              : AuthStatus.unauthenticated,
    ),
  );

  sl.registerLazySingleton<LocaleService>(() => LocaleService(sl()));
  sl.registerLazySingleton<ThemeService>(() => ThemeService(sl()));
  sl.registerLazySingleton<DeviceAuthenticator>(
    () => LocalDeviceAuthenticator(LocalAuthentication()),
  );
  sl.registerLazySingleton<AppLockCubit>(
    () => AppLockCubit(sl(), sl(), sl(), isEnabled: isAppLockEnabled),
  );
  sl.registerLazySingleton<NotificationPermissionService>(
    () => FirebaseNotificationPermissionService(),
  );

  sl.registerLazySingleton<ApiConsumer>(
    () => DioConsumer(
      dio: Dio(),
      secureStorage: sl(),
      localeService: sl(),
      themeService: sl(),
      onSessionExpired: () => sl<AuthSessionCubit>().expireSession(),
    ),
  );

  registerOnboardingFeature(sl);
  registerAuthFeature(sl);
  registerProfileFeature(sl);
  registerLegalFeature(sl);
  registerNewsFeature(sl);
  registerVolunteeringOpportunitiesFeature(sl);
  registerHomeFeature(sl);
  registerSearchFeature(sl);
  registerTasksFeature(sl);
  registerCertificatesFeature(sl);
  registerContactInfoFeature(sl);
  registerChatbotFeature(sl);
  registerContactFormFeature(sl);
  registerAboutUsFeature(sl);
  registerSocialMediaFeature(sl);

  sl.registerLazySingleton<GoRouter>(
    () => AppRouter.build(
      authSessionCubit: sl(),
      onboardingRepository: sl<OnboardingRepository>(),
    ),
  );
}