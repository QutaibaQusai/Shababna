import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import 'profile_repository.dart';

abstract interface class ProfileCvRepository {
  Future<Either<Failure, Profile>> updateCv(String filePath);
  Future<Either<Failure, void>> deleteCv();
}
