import 'package:get_it/get_it.dart';

import '../../core/network/api_consumer.dart';
import 'data/datasources/legal_remote_data_source.dart';
import 'data/repositories/legal_repository_impl.dart';
import 'domain/repositories/legal_repository.dart';
import 'presentation/cubit/legal_cubit.dart';

void registerLegalFeature(GetIt sl) {
  sl.registerLazySingleton<LegalRemoteDataSource>(
    () => LegalRemoteDataSource(sl<ApiConsumer>()),
  );

  sl.registerLazySingleton<LegalRepository>(
    () => LegalRepositoryImpl(sl<LegalRemoteDataSource>()),
  );

  sl.registerFactory<LegalCubit>(() => LegalCubit(sl<LegalRepository>()));
}
