import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../core/logging/app_logger.dart';
import '../../core/network/api_consumer.dart';
import '../../core/notifications/notification_permission_service.dart';
import '../../core/notifications/push_device_registrar.dart';
import '../../core/notifications/push_notification_service.dart';
import '../../core/services/device_identity_service.dart';
import '../../core/services/locale_service.dart';
import '../../core/session/auth_session_cubit.dart';
import 'data/datasources/notifications_remote_data_source.dart';
import 'data/repositories/notifications_repository_impl.dart';
import 'domain/repositories/notifications_repository.dart';
import 'domain/services/push_registration_coordinator.dart';
import 'presentation/cubit/notification_details/notification_details_cubit.dart';
import 'presentation/cubit/notification_settings/notification_settings_cubit.dart';
import 'presentation/cubit/notifications_list/notifications_list_cubit.dart';
import 'presentation/cubit/unread_count/unread_count_cubit.dart';
import 'presentation/navigation/notification_navigator.dart';
import 'presentation/navigation/push_tap_handler.dart';

void registerNotificationsFeature(GetIt sl) {
  sl.registerLazySingleton<NotificationsRemoteDataSource>(
    () => NotificationsRemoteDataSource(sl<ApiConsumer>()),
  );

  sl.registerLazySingleton<NotificationsRepository>(
    () => NotificationsRepositoryImpl(sl<NotificationsRemoteDataSource>()),
  );

  sl.registerLazySingleton<PushRegistrationCoordinator>(
    () => PushRegistrationCoordinator(
      sl<NotificationsRepository>(),
      sl<PushNotificationService>(),
      sl<NotificationPermissionService>(),
      sl<DeviceIdentityService>(),
      sl<AuthSessionCubit>(),
      sl<LocaleService>(),
      sl<AppLogger>(),
    ),
  );
  sl.registerLazySingleton<PushDeviceRegistrar>(
    () => sl<PushRegistrationCoordinator>(),
  );

  sl.registerLazySingleton<UnreadCountCubit>(
    () => UnreadCountCubit(
      sl<NotificationsRepository>(),
      sl<AuthSessionCubit>(),
      sl<PushNotificationService>(),
    ),
  );

  sl.registerLazySingleton<NotificationNavigator>(
    () => NotificationNavigator(
      sl<GoRouter>(),
      sl<NotificationsRepository>(),
      sl<UnreadCountCubit>(),
      sl<AuthSessionCubit>(),
    ),
  );

  sl.registerLazySingleton<PushTapHandler>(
    () => PushTapHandler(
      sl<PushNotificationService>(),
      sl<NotificationNavigator>(),
    ),
  );

  sl.registerFactory<NotificationsListCubit>(
    () => NotificationsListCubit(sl<NotificationsRepository>()),
  );

  sl.registerFactoryParam<NotificationDetailsCubit, String, void>(
    (id, _) => NotificationDetailsCubit(
      sl<NotificationsRepository>(),
      sl<UnreadCountCubit>(),
      id: id,
    ),
  );

  sl.registerFactory<NotificationSettingsCubit>(
    () => NotificationSettingsCubit(
      sl<NotificationsRepository>(),
      sl<NotificationPermissionService>(),
      sl<PushDeviceRegistrar>(),
    ),
  );
}
