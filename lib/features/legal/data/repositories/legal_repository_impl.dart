import 'package:dartz/dartz.dart';

import '../../../../core/data/repository_guard_mixin.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/legal_repository.dart';
import '../datasources/legal_remote_data_source.dart';

class LegalRepositoryImpl with RepositoryGuardMixin implements LegalRepository {
  LegalRepositoryImpl(this._remoteDataSource);

  final LegalRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, LegalContent>> getContent() {
    return guard(() async {
      final response = await _remoteDataSource.getContent();
      return LegalContent(
        privacyPolicyEn: response.privacyPolicyEn,
        privacyPolicyAr: response.privacyPolicyAr,
        termsAndConditionsEn: response.termsAndConditionsEn,
        termsAndConditionsAr: response.termsAndConditionsAr,
      );
    });
  }
}
