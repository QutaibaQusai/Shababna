import 'package:get_it/get_it.dart';

import '../../core/network/api_consumer.dart';
import 'data/datasources/contact_info_remote_data_source.dart';
import 'data/repositories/contact_info_repository_impl.dart';
import 'domain/repositories/contact_info_repository.dart';
import 'presentation/cubit/contact_info_cubit.dart';

void registerContactInfoFeature(GetIt sl) {
  sl.registerLazySingleton<ContactInfoRemoteDataSource>(
    () => ContactInfoRemoteDataSource(sl<ApiConsumer>()),
  );

  sl.registerLazySingleton<ContactInfoRepository>(
    () => ContactInfoRepositoryImpl(sl<ContactInfoRemoteDataSource>()),
  );

  sl.registerFactory<ContactInfoCubit>(() => ContactInfoCubit(sl<ContactInfoRepository>()));
}
