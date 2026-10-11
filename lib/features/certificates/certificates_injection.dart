import 'package:get_it/get_it.dart';

import '../../core/network/api_consumer.dart';
import 'data/datasources/certificates_remote_data_source.dart';
import 'data/repositories/certificates_repository_impl.dart';
import 'domain/repositories/certificates_repository.dart';
import 'presentation/cubit/certificate_details/certificate_details_cubit.dart';
import 'presentation/cubit/certificates_list/certificates_list_cubit.dart';

void registerCertificatesFeature(GetIt sl) {
  sl.registerLazySingleton<CertificatesRemoteDataSource>(
    () => CertificatesRemoteDataSource(sl<ApiConsumer>()),
  );

  sl.registerLazySingleton<CertificatesRepository>(
    () => CertificatesRepositoryImpl(sl<CertificatesRemoteDataSource>()),
  );

  sl.registerFactory<CertificatesListCubit>(
    () => CertificatesListCubit(sl<CertificatesRepository>()),
  );

  sl.registerFactoryParam<CertificateDetailsCubit, String, void>(
    (id, _) => CertificateDetailsCubit(sl<CertificatesRepository>(), id: id),
  );
}
