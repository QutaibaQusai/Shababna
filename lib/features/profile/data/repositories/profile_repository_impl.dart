import 'package:dartz/dartz.dart';

import '../../../../core/data/repository_guard_mixin.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';
import '../mappers/profile_mapper.dart';

class ProfileRepositoryImpl with RepositoryGuardMixin implements ProfileRepository {
  ProfileRepositoryImpl(this._remoteDataSource);

  final ProfileRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, Profile>> getProfile() {
    return guard(() async {
      final response = await _remoteDataSource.getProfile();
      return response.toEntity();
    });
  }

  @override
  Future<Either<Failure, Profile>> updateDetails(ProfileDetails details) {
    return guard(() async {
      final response = await _remoteDataSource.updateDetails(details.toRequest());
      return response.toEntity();
    });
  }

  @override
  Future<Either<Failure, void>> updatePhoneNumber(String phoneNumber) {
    return guard(() => _remoteDataSource.updatePhoneNumber(phoneNumber));
  }

  @override
  Future<Either<Failure, Profile>> uploadAttachment(ProfileAttachment attachment, String filePath) {
    return guard(() async {
      final response = await _remoteDataSource.uploadAttachment(attachment, filePath);
      return response.toEntity();
    });
  }

  @override
  Future<Either<Failure, void>> deleteAttachment(ProfileAttachment attachment) {
    return guard(() => _remoteDataSource.deleteAttachment(attachment));
  }
}
