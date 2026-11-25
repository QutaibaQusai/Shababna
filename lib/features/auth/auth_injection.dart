import 'package:get_it/get_it.dart';

import '../../core/logging/app_logger.dart';
import '../../core/network/api_consumer.dart';
import '../../core/services/device_identity_service.dart';
import '../../core/session/auth_session_cubit.dart';
import '../../core/storage/secure_storage.dart';
import 'data/datasources/auth_remote_data_source.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/login_verification.dart';
import 'domain/repositories/auth_repository.dart';
import 'presentation/cubit/forgot_password/forgot_password_cubit.dart';
import 'presentation/cubit/login/login_cubit.dart';
import 'presentation/cubit/login_verification/login_verification_cubit.dart';
import 'presentation/cubit/phone_codes/phone_codes_cubit.dart';
import 'presentation/cubit/logout/logout_cubit.dart';
import 'presentation/cubit/register/register_cubit.dart';
import 'presentation/cubit/forgot_password/reset_password_cubit.dart';
import 'presentation/cubit/register/register_verify_cubit.dart';
import 'presentation/cubit/forgot_password/verify_reset_code_cubit.dart';

void registerAuthFeature(GetIt sl) {
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(sl<ApiConsumer>()),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      sl<AuthRemoteDataSource>(),
      sl<AppSecureStorage>(),
      sl<DeviceIdentityService>(),
    ),
  );

  sl.registerFactory<LoginCubit>(
    () => LoginCubit(sl<AuthRepository>(), sl<AuthSessionCubit>()),
  );
  sl.registerFactoryParam<LoginVerificationCubit, PendingVerification, void>(
    (pending, _) => LoginVerificationCubit(sl<AuthRepository>(), pending: pending),
  );
  sl.registerLazySingleton<PhoneCodesCubit>(() => PhoneCodesCubit(sl<AuthRepository>()));
  sl.registerFactory<LogoutCubit>(
    () => LogoutCubit(sl<AuthRepository>(), sl<AuthSessionCubit>(), sl<AppLogger>()),
  );
  sl.registerFactory<RegisterCubit>(() => RegisterCubit(sl<AuthRepository>()));
  sl.registerFactory<RegisterVerifyCubit>(
    () => RegisterVerifyCubit(sl<AuthRepository>()),
  );
  sl.registerFactory<ForgotPasswordCubit>(
    () => ForgotPasswordCubit(sl<AuthRepository>()),
  );
  sl.registerFactory<VerifyResetCodeCubit>(
    () => VerifyResetCodeCubit(sl<AuthRepository>()),
  );
  sl.registerFactory<ResetPasswordCubit>(
    () => ResetPasswordCubit(sl<AuthRepository>()),
  );
}
