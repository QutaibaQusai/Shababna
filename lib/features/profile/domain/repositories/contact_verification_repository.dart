import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../auth/domain/verification_channel.dart';

abstract interface class ContactVerificationRepository {
  Future<Either<Failure, int>> sendCode(VerificationChannel channel);

  Future<Either<Failure, void>> verifyCode(VerificationChannel channel, String code);
}
