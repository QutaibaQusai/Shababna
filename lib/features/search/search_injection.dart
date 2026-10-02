import 'package:get_it/get_it.dart';

import '../../core/network/api_consumer.dart';
import 'data/datasources/search_remote_data_source.dart';
import 'data/repositories/search_repository_impl.dart';
import 'domain/repositories/search_repository.dart';
import 'presentation/cubit/global_search_cubit.dart';

void registerSearchFeature(GetIt sl) {
  sl.registerLazySingleton<SearchRemoteDataSource>(
    () => SearchRemoteDataSource(sl<ApiConsumer>()),
  );

  sl.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(sl<SearchRemoteDataSource>()),
  );

  sl.registerFactory<GlobalSearchCubit>(() => GlobalSearchCubit(sl<SearchRepository>()));
}
