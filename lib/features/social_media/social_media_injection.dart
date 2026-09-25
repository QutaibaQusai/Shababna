import 'package:get_it/get_it.dart';

import '../../core/network/api_consumer.dart';
import 'data/datasources/social_media_remote_data_source.dart';
import 'data/repositories/social_media_repository_impl.dart';
import 'domain/repositories/social_media_repository.dart';
import 'presentation/cubit/social_media_cubit.dart';

void registerSocialMediaFeature(GetIt sl) {
  sl.registerLazySingleton<SocialMediaRemoteDataSource>(
    () => SocialMediaRemoteDataSource(sl<ApiConsumer>()),
  );

  sl.registerLazySingleton<SocialMediaRepository>(
    () => SocialMediaRepositoryImpl(sl<SocialMediaRemoteDataSource>()),
  );

  sl.registerFactory<SocialMediaCubit>(() => SocialMediaCubit(sl<SocialMediaRepository>()));
}
