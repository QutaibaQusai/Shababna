import 'package:get_it/get_it.dart';

import '../../core/network/api_consumer.dart';
import 'data/datasources/change_password_remote_data_source.dart';
import 'data/datasources/profile_remote_data_source.dart';
import 'data/repositories/change_password_repository_impl.dart';
import 'data/repositories/profile_repository_impl.dart';
import 'domain/repositories/change_password_repository.dart';
import 'domain/repositories/profile_repository.dart';
import 'presentation/cubit/change_password_cubit.dart';
import 'presentation/cubit/profile_cubit.dart';

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
}
