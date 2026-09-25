import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import 'profile_repository.dart';

abstract interface class ProfileNationalIdRepository {
  Future<Either<Failure, Profile>> updateNationalIdPicture(String filePath);
  Future<Either<Failure, void>> deleteNationalIdPicture();
}
