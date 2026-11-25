import 'package:dartz/dartz.dart';

import '../../../../core/data/repository_guard_mixin.dart';
import '../../../../core/error/failures.dart';
import '../../../auth/domain/verification_channel.dart';
import '../../domain/repositories/contact_verification_repository.dart';
import '../datasources/contact_verification_remote_data_source.dart';

class ContactVerificationRepositoryImpl
    with RepositoryGuardMixin
    implements ContactVerificationRepository {
  ContactVerificationRepositoryImpl(this._remoteDataSource);

  final ContactVerificationRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, int>> sendCode(VerificationChannel channel) {
    return guard(() => _remoteDataSource.sendCode(channel));
  }

  @override
  Future<Either<Failure, void>> verifyCode(VerificationChannel channel, String code) {
    return guard(() => _remoteDataSource.verifyCode(channel, code));
  }
}
