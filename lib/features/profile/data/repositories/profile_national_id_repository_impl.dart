import 'package:dartz/dartz.dart';

import '../../../../core/data/repository_guard_mixin.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/profile_national_id_repository.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_national_id_remote_data_source.dart';
import '../mappers/profile_mapper.dart';

class ProfileNationalIdRepositoryImpl
    with RepositoryGuardMixin
    implements ProfileNationalIdRepository {
  ProfileNationalIdRepositoryImpl(this._remoteDataSource);

  final ProfileNationalIdRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, Profile>> updateNationalIdPicture(String filePath) {
    return guard(() async {
      final response = await _remoteDataSource.updateNationalIdPicture(filePath);
      return response.toEntity();
    });
  }

  @override
  Future<Either<Failure, void>> deleteNationalIdPicture() {
    return guard(() => _remoteDataSource.deleteNationalIdPicture());
  }
}
