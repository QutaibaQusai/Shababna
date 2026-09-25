import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

class EmailChangeResult {
  const EmailChangeResult({required this.verificationRequired, required this.newEmail});

  final bool verificationRequired;
  final String newEmail;
}

abstract interface class ProfileEmailRepository {
  Future<Either<Failure, EmailChangeResult>> changeEmail({
    required String currentPassword,
    required String newEmail,
  });

  Future<Either<Failure, void>> verifyEmailChange(String code);

  Future<Either<Failure, EmailChangeResult>> resendEmailChangeCode();
}
