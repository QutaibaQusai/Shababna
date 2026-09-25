import 'package:dartz/dartz.dart';

import '../../../../core/data/repository_guard_mixin.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/profile_picture_repository.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_picture_remote_data_source.dart';
import '../mappers/profile_mapper.dart';

class ProfilePictureRepositoryImpl with RepositoryGuardMixin implements ProfilePictureRepository {
  ProfilePictureRepositoryImpl(this._remoteDataSource);

  final ProfilePictureRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, Profile>> updatePicture(String filePath) {
    return guard(() async {
      final response = await _remoteDataSource.updatePicture(filePath);
      return response.toEntity();
    });
  }

  @override
  Future<Either<Failure, void>> deletePicture() {
    return guard(() => _remoteDataSource.deletePicture());
  }
}
