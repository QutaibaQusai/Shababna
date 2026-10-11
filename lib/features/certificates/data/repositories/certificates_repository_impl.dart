import 'package:dartz/dartz.dart';

import '../../../../core/data/repository_guard_mixin.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/paged_result.dart';
import '../../domain/repositories/certificates_repository.dart';
import '../datasources/certificates_remote_data_source.dart';
import '../mappers/certificates_mapper.dart';

class CertificatesRepositoryImpl with RepositoryGuardMixin implements CertificatesRepository {
  CertificatesRepositoryImpl(this._remoteDataSource);

  final CertificatesRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, PagedResult<Certificate>>> getCertificates({
    required int page,
    required int pageSize,
  }) {
    return guard(() async {
      final response = await _remoteDataSource.getCertificates(page: page, pageSize: pageSize);
      return PagedResult(
        items: response.items.map((item) => item.toEntity()).toList(),
        page: response.page,
        pageSize: response.pageSize,
        totalCount: response.totalCount,
        hasNextPage: response.hasNextPage,
      );
    });
  }

  @override
  Future<Either<Failure, Certificate>> getCertificate(String id) {
    return guard(() async {
      final response = await _remoteDataSource.getCertificate(id);
      return response.toEntity();
    });
  }

  @override
  Future<Either<Failure, String>> downloadDocument(
    Certificate certificate,
    CertificateLanguage language,
  ) {
    return guard(
      () => _remoteDataSource.downloadDocument(
        documentUrl: certificate.documentUrl(language),
        certificateNumber: certificate.certificateNumber,
        languageCode: switch (language) {
          CertificateLanguage.arabic => 'ar',
          CertificateLanguage.english => 'en',
        },
      ),
    );
  }
}
