import 'package:dartz/dartz.dart';

import '../../../../core/data/repository_guard_mixin.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/change_password_repository.dart';
import '../datasources/change_password_remote_data_source.dart';
import '../models/change_password_request_model.dart';

class ChangePasswordRepositoryImpl with RepositoryGuardMixin implements ChangePasswordRepository {
  ChangePasswordRepositoryImpl(this._remoteDataSource);

  final ChangePasswordRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) {
    return guard(() {
      return _remoteDataSource.changePassword(
        ChangePasswordRequestModel(
          currentPassword: currentPassword,
          newPassword: newPassword,
          confirmPassword: confirmPassword,
        ),
      );
    });
  }
}
