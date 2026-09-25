import 'package:dartz/dartz.dart';

import '../../../../core/data/repository_guard_mixin.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/profile_email_repository.dart';
import '../datasources/profile_email_remote_data_source.dart';
import '../models/email_change_response_model.dart';

class ProfileEmailRepositoryImpl with RepositoryGuardMixin implements ProfileEmailRepository {
  ProfileEmailRepositoryImpl(this._remoteDataSource);

  final ProfileEmailRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, EmailChangeResult>> changeEmail({
    required String currentPassword,
    required String newEmail,
  }) {
    return guard(() async {
      final response = await _remoteDataSource.changeEmail(
        currentPassword: currentPassword,
        newEmail: newEmail,
      );
      return _toEntity(response);
    });
  }

  @override
  Future<Either<Failure, void>> verifyEmailChange(String code) {
    return guard(() => _remoteDataSource.verifyEmailChange(code));
  }

  @override
  Future<Either<Failure, EmailChangeResult>> resendEmailChangeCode() {
    return guard(() async {
      final response = await _remoteDataSource.resendEmailChangeCode();
      return _toEntity(response);
    });
  }

  EmailChangeResult _toEntity(EmailChangeResponseModel response) {
    return EmailChangeResult(
      verificationRequired: response.verificationRequired,
      newEmail: response.newEmail,
    );
  }
}
