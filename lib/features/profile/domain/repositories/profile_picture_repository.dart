import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import 'profile_repository.dart';

abstract interface class ProfilePictureRepository {
  Future<Either<Failure, Profile>> updatePicture(String filePath);
  Future<Either<Failure, void>> deletePicture();
}
