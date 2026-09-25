import 'package:get_it/get_it.dart';

import '../../core/network/api_consumer.dart';
import 'data/datasources/about_us_remote_data_source.dart';
import 'data/repositories/about_us_repository_impl.dart';
import 'domain/repositories/about_us_repository.dart';
import 'presentation/cubit/about_us_cubit.dart';

void registerAboutUsFeature(GetIt sl) {
  sl.registerLazySingleton<AboutUsRemoteDataSource>(
    () => AboutUsRemoteDataSource(sl<ApiConsumer>()),
  );

  sl.registerLazySingleton<AboutUsRepository>(
    () => AboutUsRepositoryImpl(sl<AboutUsRemoteDataSource>()),
  );

  sl.registerFactory<AboutUsCubit>(() => AboutUsCubit(sl<AboutUsRepository>()));
}
