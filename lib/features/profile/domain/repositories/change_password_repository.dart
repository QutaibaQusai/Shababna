import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

abstract interface class ChangePasswordRepository {
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  });
}
