import 'package:dartz/dartz.dart';

import '../../../../core/data/repository_guard_mixin.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';

class ProfileRepositoryImpl with RepositoryGuardMixin implements ProfileRepository {
  ProfileRepositoryImpl(this._remoteDataSource);

  final ProfileRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, Profile>> getProfile() {
    return guard(() async {
      final response = await _remoteDataSource.getProfile();
      return Profile(
        fullNameEn: response.fullNameEn,
        fullNameAr: response.fullNameAr,
        email: response.email,
        emailConfirmed: response.emailConfirmed,
        phoneNumber: response.phoneNumber,
        profilePictureUrl: response.profilePictureUrl,
        hasProfilePicture: response.hasProfilePicture,
      );
    });
  }
}
