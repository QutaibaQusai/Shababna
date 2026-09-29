import 'package:get_it/get_it.dart';

import '../../core/network/api_consumer.dart';
import 'data/datasources/news_remote_data_source.dart';
import 'data/repositories/news_repository_impl.dart';
import 'domain/repositories/news_repository.dart';
import 'presentation/cubit/news_details/news_details_cubit.dart';
import 'presentation/cubit/news_list/news_list_cubit.dart';
import 'presentation/cubit/news_search/news_search_cubit.dart';

void registerNewsFeature(GetIt sl) {
  sl.registerLazySingleton<NewsRemoteDataSource>(
    () => NewsRemoteDataSource(sl<ApiConsumer>()),
  );

  sl.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(sl<NewsRemoteDataSource>()),
  );

  sl.registerFactory<NewsListCubit>(() => NewsListCubit(sl<NewsRepository>()));

  sl.registerFactory<NewsSearchCubit>(() => NewsSearchCubit(sl<NewsRepository>()));

  sl.registerFactoryParam<NewsDetailsCubit, String, void>(
    (id, _) => NewsDetailsCubit(sl<NewsRepository>(), id: id),
  );
}
