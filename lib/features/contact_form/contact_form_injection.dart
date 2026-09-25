import 'package:get_it/get_it.dart';

import '../../core/network/api_consumer.dart';
import 'data/datasources/contact_form_remote_data_source.dart';
import 'data/repositories/contact_form_repository_impl.dart';
import 'domain/repositories/contact_form_repository.dart';
import 'presentation/cubit/contact_form_cubit.dart';

void registerContactFormFeature(GetIt sl) {
  sl.registerLazySingleton<ContactFormRemoteDataSource>(
    () => ContactFormRemoteDataSource(sl<ApiConsumer>()),
  );

  sl.registerLazySingleton<ContactFormRepository>(
    () => ContactFormRepositoryImpl(sl<ContactFormRemoteDataSource>()),
  );

  sl.registerFactory<ContactFormCubit>(() => ContactFormCubit(sl<ContactFormRepository>()));
}
