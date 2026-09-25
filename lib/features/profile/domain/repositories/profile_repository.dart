import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

class Profile {
  const Profile({
    required this.fullNameEn,
    required this.fullNameAr,
    required this.email,
    required this.emailConfirmed,
    required this.phoneNumber,
    required this.profilePictureUrl,
    required this.hasProfilePicture,
    required this.completionPercentage,
  });

  final String fullNameEn;
  final String fullNameAr;
  final String email;
  final bool emailConfirmed;
  final String? phoneNumber;
  final String? profilePictureUrl;
  final bool hasProfilePicture;
  final int completionPercentage;
}

abstract interface class ProfileRepository {
  Future<Either<Failure, Profile>> getProfile();
}
