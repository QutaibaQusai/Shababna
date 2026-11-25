import 'package:get_it/get_it.dart';

import '../../core/network/api_consumer.dart';
import '../../core/notifications/push_device_registrar.dart';
import '../../core/session/auth_session_cubit.dart';
import '../auth/domain/verification_channel.dart';
import 'data/datasources/change_password_remote_data_source.dart';
import 'data/datasources/contact_verification_remote_data_source.dart';
import 'data/datasources/profile_email_remote_data_source.dart';
import 'data/datasources/profile_lookups_remote_data_source.dart';
import 'data/datasources/profile_remote_data_source.dart';
import 'data/repositories/change_password_repository_impl.dart';
import 'data/repositories/contact_verification_repository_impl.dart';
import 'data/repositories/profile_email_repository_impl.dart';
import 'data/repositories/profile_lookups_repository_impl.dart';
import 'data/repositories/profile_repository_impl.dart';
import 'domain/repositories/change_password_repository.dart';
import 'domain/repositories/contact_verification_repository.dart';
import 'domain/repositories/profile_email_repository.dart';
import 'domain/repositories/profile_lookups_repository.dart';
import 'domain/repositories/profile_repository.dart';
import 'presentation/cubit/change_email/change_email_cubit.dart';
import 'presentation/cubit/change_email/verify_email_change_cubit.dart';
import 'presentation/cubit/change_password/change_password_cubit.dart';
import 'presentation/cubit/change_phone_number/change_phone_number_cubit.dart';
import 'presentation/cubit/delete_account/delete_account_cubit.dart';
import 'presentation/cubit/edit_profile/edit_profile_cubit.dart';
import 'presentation/cubit/profile/profile_cubit.dart';
import 'presentation/cubit/profile_attachment/profile_attachment_cubit.dart';
import 'presentation/cubit/verify_contact/verify_contact_cubit.dart';

void registerProfileFeature(GetIt sl) {
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSource(sl<ApiConsumer>()),
  );

  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(sl<ProfileRemoteDataSource>()),
  );

  sl.registerLazySingleton<ProfileLookupsRemoteDataSource>(
    () => ProfileLookupsRemoteDataSource(sl<ApiConsumer>()),
  );

  sl.registerLazySingleton<ProfileLookupsRepository>(
    () => ProfileLookupsRepositoryImpl(sl<ProfileLookupsRemoteDataSource>()),
  );

  sl.registerLazySingleton<ProfileEmailRemoteDataSource>(
    () => ProfileEmailRemoteDataSource(sl<ApiConsumer>()),
  );

  sl.registerLazySingleton<ProfileEmailRepository>(
    () => ProfileEmailRepositoryImpl(sl<ProfileEmailRemoteDataSource>()),
  );

  sl.registerLazySingleton<ChangePasswordRemoteDataSource>(
    () => ChangePasswordRemoteDataSource(sl<ApiConsumer>()),
  );

  sl.registerLazySingleton<ChangePasswordRepository>(
    () => ChangePasswordRepositoryImpl(sl<ChangePasswordRemoteDataSource>()),
  );

  sl.registerLazySingleton<ProfileCubit>(
    () => ProfileCubit(sl<ProfileRepository>(), sl<AuthSessionCubit>()),
  );

  sl.registerFactoryParam<EditProfileCubit, Profile, void>(
    (profile, _) => EditProfileCubit(sl<ProfileRepository>(), sl<ProfileCubit>(), profile),
  );

  sl.registerFactory<ProfileAttachmentCubit>(
    () => ProfileAttachmentCubit(sl<ProfileRepository>(), sl<ProfileCubit>()),
  );

  sl.registerFactory<ChangePhoneNumberCubit>(
    () => ChangePhoneNumberCubit(
      sl<ProfileRepository>(),
      sl<ProfileLookupsRepository>(),
      sl<ProfileCubit>(),
    ),
  );

  sl.registerFactory<ChangeEmailCubit>(
    () => ChangeEmailCubit(sl<ProfileEmailRepository>(), sl<ProfileCubit>()),
  );

  sl.registerFactoryParam<VerifyEmailChangeCubit, String, void>(
    (newEmail, _) => VerifyEmailChangeCubit(
      sl<ProfileEmailRepository>(),
      sl<ProfileCubit>(),
      sl<PushDeviceRegistrar>(),
      newEmail: newEmail,
    ),
  );

  sl.registerFactory<ChangePasswordCubit>(
    () => ChangePasswordCubit(sl<ChangePasswordRepository>(), sl<PushDeviceRegistrar>()),
  );

  sl.registerFactory<DeleteAccountCubit>(
    () => DeleteAccountCubit(sl<ProfileRepository>(), sl<AuthSessionCubit>()),
  );

  sl.registerLazySingleton<ContactVerificationRemoteDataSource>(
    () => ContactVerificationRemoteDataSource(sl<ApiConsumer>()),
  );
  sl.registerLazySingleton<ContactVerificationRepository>(
    () => ContactVerificationRepositoryImpl(sl<ContactVerificationRemoteDataSource>()),
  );
  sl.registerFactoryParam<VerifyContactCubit, VerificationChannel, void>(
    (channel, _) => VerifyContactCubit(
      sl<ContactVerificationRepository>(),
      sl<ProfileCubit>(),
      channel: channel,
    ),
  );
}
