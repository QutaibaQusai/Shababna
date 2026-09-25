import 'package:dartz/dartz.dart';

import '../../../../core/data/repository_guard_mixin.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/profile_cv_repository.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_cv_remote_data_source.dart';
import '../mappers/profile_mapper.dart';

class ProfileCvRepositoryImpl with RepositoryGuardMixin implements ProfileCvRepository {
  ProfileCvRepositoryImpl(this._remoteDataSource);

  final ProfileCvRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, Profile>> updateCv(String filePath) {
    return guard(() async {
      final response = await _remoteDataSource.updateCv(filePath);
      return response.toEntity();
    });
  }

  @override
  Future<Either<Failure, void>> deleteCv() {
    return guard(() => _remoteDataSource.deleteCv());
  }
}
