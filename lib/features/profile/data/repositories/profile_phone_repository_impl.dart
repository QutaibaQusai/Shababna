import 'package:dartz/dartz.dart';

import '../../../../core/data/repository_guard_mixin.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/profile_phone_repository.dart';
import '../datasources/profile_phone_remote_data_source.dart';

class ProfilePhoneRepositoryImpl with RepositoryGuardMixin implements ProfilePhoneRepository {
  ProfilePhoneRepositoryImpl(this._remoteDataSource);

  final ProfilePhoneRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, void>> updatePhoneNumber(String phoneNumber) {
    return guard(() => _remoteDataSource.updatePhoneNumber(phoneNumber));
  }
}
