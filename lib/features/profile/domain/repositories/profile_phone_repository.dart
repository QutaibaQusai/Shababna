import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

abstract interface class ProfilePhoneRepository {
  Future<Either<Failure, void>> updatePhoneNumber(String phoneNumber);
}
