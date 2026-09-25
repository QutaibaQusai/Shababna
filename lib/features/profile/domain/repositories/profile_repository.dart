import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

enum ProfileGender { male, female }

class ProfileReference {
  const ProfileReference({required this.id, required this.name});

  final String id;
  final String name;
}

class ProfileEducation {
  const ProfileEducation({
    required this.id,
    required this.name,
    required this.isMajorRequired,
  });

  final String id;
  final String name;
  final bool isMajorRequired;
}

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
    required this.hasCv,
    required this.cvFileName,
    required this.nationality,
    required this.city,
    required this.dateOfBirth,
    required this.gender,
    required this.education,
    required this.major,
    required this.universityName,
    required this.isFirstTimeVolunteer,
    required this.hasNationalIdPicture,
    required this.nationalIdPictureUrl,
    required this.isProfileComplete,
    required this.nearestLandmark,
    required this.district,
    required this.neighborhood,
    required this.detailedAddress,
    required this.volunteerAwards,
    required this.isAvailableToVolunteer,
    required this.estimatedWeeklyHours,
    required this.willSignVolunteerServiceAgreement,
    required this.willProvideNcc,
    required this.volunteeringTypes,
    required this.otherVolunteeringSubjects,
  });

  final String fullNameEn;
  final String fullNameAr;
  final String email;
  final bool emailConfirmed;
  final String? phoneNumber;
  final String? profilePictureUrl;
  final bool hasProfilePicture;
  final int completionPercentage;
  final bool hasCv;
  final String? cvFileName;
  final ProfileReference? nationality;
  final ProfileReference? city;
  final String? dateOfBirth;
  final ProfileGender? gender;
  final ProfileEducation? education;
  final String? major;
  final String? universityName;
  final bool isFirstTimeVolunteer;
  final bool hasNationalIdPicture;
  final String? nationalIdPictureUrl;
  final bool isProfileComplete;
  final String? nearestLandmark;
  final String? district;
  final String? neighborhood;
  final String? detailedAddress;
  final bool? volunteerAwards;
  final bool? isAvailableToVolunteer;
  final int? estimatedWeeklyHours;
  final bool? willSignVolunteerServiceAgreement;
  final bool? willProvideNcc;
  final List<ProfileReference> volunteeringTypes;
  final String? otherVolunteeringSubjects;
}

abstract interface class ProfileRepository {
  Future<Either<Failure, Profile>> getProfile();

  Future<Either<Failure, Profile>> updateDetails({
    String? nationalityId,
    String? cityId,
    String? dateOfBirth,
    ProfileGender? gender,
    String? educationId,
    String? major,
    String? universityName,
    bool? isFirstTimeVolunteer,
    String? nearestLandmark,
    String? district,
    String? neighborhood,
    String? detailedAddress,
    bool? volunteerAwards,
    bool? isAvailableToVolunteer,
    int? estimatedWeeklyHours,
    bool? willSignVolunteerServiceAgreement,
    bool? willProvideNcc,
    List<String>? volunteeringTypeIds,
    String? otherVolunteeringSubjects,
  });
}
