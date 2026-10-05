import 'package:get_it/get_it.dart';

import '../../core/network/api_consumer.dart';
import 'data/datasources/home_remote_data_source.dart';
import 'data/repositories/home_repository_impl.dart';
import 'domain/repositories/home_repository.dart';
import 'presentation/cubit/home_cubit.dart';

void registerHomeFeature(GetIt sl) {
  sl.registerLazySingleton<HomeRemoteDataSource>(() => HomeRemoteDataSource(sl<ApiConsumer>()));

  sl.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(sl<HomeRemoteDataSource>()));

  sl.registerFactory<HomeCubit>(() => HomeCubit(sl<HomeRepository>()));
}
