import 'package:get_it/get_it.dart';

import '../../core/network/api_consumer.dart';
import 'data/datasources/change_password_remote_data_source.dart';
import 'data/datasources/profile_cv_remote_data_source.dart';
import 'data/datasources/profile_email_remote_data_source.dart';
import 'data/datasources/profile_lookups_remote_data_source.dart';
import 'data/datasources/profile_national_id_remote_data_source.dart';
import 'data/datasources/profile_phone_remote_data_source.dart';
import 'data/datasources/profile_picture_remote_data_source.dart';
import 'data/datasources/profile_remote_data_source.dart';
import 'data/repositories/change_password_repository_impl.dart';
import 'data/repositories/profile_cv_repository_impl.dart';
import 'data/repositories/profile_email_repository_impl.dart';
import 'data/repositories/profile_lookups_repository_impl.dart';
import 'data/repositories/profile_national_id_repository_impl.dart';
import 'data/repositories/profile_phone_repository_impl.dart';
import 'data/repositories/profile_picture_repository_impl.dart';
import 'data/repositories/profile_repository_impl.dart';
import 'domain/repositories/change_password_repository.dart';
import 'domain/repositories/profile_cv_repository.dart';
import 'domain/repositories/profile_email_repository.dart';
import 'domain/repositories/profile_lookups_repository.dart';
import 'domain/repositories/profile_national_id_repository.dart';
import 'domain/repositories/profile_phone_repository.dart';
import 'domain/repositories/profile_picture_repository.dart';
import 'domain/repositories/profile_repository.dart';
import 'presentation/cubit/change_email/change_email_cubit.dart';
import 'presentation/cubit/change_email/verify_email_change_cubit.dart';
import 'presentation/cubit/change_password/change_password_cubit.dart';
import 'presentation/cubit/change_phone_number/change_phone_number_cubit.dart';
import 'presentation/cubit/edit_cv/edit_cv_cubit.dart';
import 'presentation/cubit/edit_national_id/edit_national_id_cubit.dart';
import 'presentation/cubit/edit_profile/edit_profile_cubit.dart';
import 'presentation/cubit/edit_profile_picture/edit_profile_picture_cubit.dart';
import 'presentation/cubit/profile/profile_cubit.dart';

void registerProfileFeature(GetIt sl) {
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSource(sl<ApiConsumer>()),
  );

  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(sl<ProfileRemoteDataSource>()),
  );

  sl.registerFactory<ProfileCubit>(() => ProfileCubit(sl<ProfileRepository>()));

  sl.registerLazySingleton<ChangePasswordRemoteDataSource>(
    () => ChangePasswordRemoteDataSource(sl<ApiConsumer>()),
  );

  sl.registerLazySingleton<ChangePasswordRepository>(
    () => ChangePasswordRepositoryImpl(sl<ChangePasswordRemoteDataSource>()),
  );

  sl.registerFactory<ChangePasswordCubit>(() => ChangePasswordCubit(sl<ChangePasswordRepository>()));

  sl.registerLazySingleton<ProfileLookupsRemoteDataSource>(
    () => ProfileLookupsRemoteDataSource(sl<ApiConsumer>()),
  );

  sl.registerLazySingleton<ProfileLookupsRepository>(
    () => ProfileLookupsRepositoryImpl(sl<ProfileLookupsRemoteDataSource>()),
  );

  sl.registerFactory<EditProfileCubit>(
    () => EditProfileCubit(sl<ProfileRepository>(), sl<ProfileLookupsRepository>()),
  );

  sl.registerLazySingleton<ProfilePhoneRemoteDataSource>(
    () => ProfilePhoneRemoteDataSource(sl<ApiConsumer>()),
  );

  sl.registerLazySingleton<ProfilePhoneRepository>(
    () => ProfilePhoneRepositoryImpl(sl<ProfilePhoneRemoteDataSource>()),
  );

  sl.registerFactory<ChangePhoneNumberCubit>(
    () => ChangePhoneNumberCubit(sl<ProfilePhoneRepository>()),
  );

  sl.registerLazySingleton<ProfileEmailRemoteDataSource>(
    () => ProfileEmailRemoteDataSource(sl<ApiConsumer>()),
  );

  sl.registerLazySingleton<ProfileEmailRepository>(
    () => ProfileEmailRepositoryImpl(sl<ProfileEmailRemoteDataSource>()),
  );

  sl.registerFactory<ChangeEmailCubit>(() => ChangeEmailCubit(sl<ProfileEmailRepository>()));

  sl.registerFactory<VerifyEmailChangeCubit>(
    () => VerifyEmailChangeCubit(sl<ProfileEmailRepository>()),
  );

  sl.registerLazySingleton<ProfilePictureRemoteDataSource>(
    () => ProfilePictureRemoteDataSource(sl<ApiConsumer>()),
  );

  sl.registerLazySingleton<ProfilePictureRepository>(
    () => ProfilePictureRepositoryImpl(sl<ProfilePictureRemoteDataSource>()),
  );

  sl.registerFactory<EditProfilePictureCubit>(
    () => EditProfilePictureCubit(sl<ProfilePictureRepository>()),
  );

  sl.registerLazySingleton<ProfileCvRemoteDataSource>(
    () => ProfileCvRemoteDataSource(sl<ApiConsumer>()),
  );

  sl.registerLazySingleton<ProfileCvRepository>(
    () => ProfileCvRepositoryImpl(sl<ProfileCvRemoteDataSource>()),
  );

  sl.registerFactory<EditCvCubit>(() => EditCvCubit(sl<ProfileCvRepository>()));

  sl.registerLazySingleton<ProfileNationalIdRemoteDataSource>(
    () => ProfileNationalIdRemoteDataSource(sl<ApiConsumer>()),
  );

  sl.registerLazySingleton<ProfileNationalIdRepository>(
    () => ProfileNationalIdRepositoryImpl(sl<ProfileNationalIdRemoteDataSource>()),
  );

  sl.registerFactory<EditNationalIdCubit>(
    () => EditNationalIdCubit(sl<ProfileNationalIdRepository>()),
  );
}
