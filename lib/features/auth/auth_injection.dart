import 'package:get_it/get_it.dart';

import '../../core/network/api_consumer.dart';
import '../../core/services/device_identity_service.dart';
import '../../core/session/auth_session_cubit.dart';
import '../../core/storage/secure_storage.dart';
import 'data/datasources/auth_remote_data_source.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'presentation/cubit/forgot_password/forgot_password_cubit.dart';
import 'presentation/cubit/login/login_cubit.dart';
import 'presentation/cubit/register/register_cubit.dart';
import 'presentation/cubit/reset_password/reset_password_cubit.dart';
import 'presentation/cubit/verify_email/verify_email_cubit.dart';
import 'presentation/cubit/verify_reset_code/verify_reset_code_cubit.dart';

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
  sl.registerFactory<RegisterCubit>(() => RegisterCubit(sl<AuthRepository>()));
  sl.registerFactory<VerifyEmailCubit>(
    () => VerifyEmailCubit(sl<AuthRepository>()),
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
