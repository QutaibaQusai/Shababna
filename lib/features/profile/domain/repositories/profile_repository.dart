import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';

enum ProfileGender { male, female }

enum ProfileAttachment { picture, cv, nationalId }

class ProfileReference extends Equatable {
  const ProfileReference({required this.id, required this.name});

  final String id;
  final String name;

  @override
  List<Object?> get props => [id];
}

class ProfileEducation extends Equatable {
  const ProfileEducation({
    required this.id,
    required this.name,
    required this.isMajorRequired,
  });

  final String id;
  final String name;
  final bool isMajorRequired;

  @override
  List<Object?> get props => [id];
}

class VolunteerTier extends Equatable {
  const VolunteerTier({
    required this.id,
    required this.name,
    required this.color,
    required this.minimumHours,
    required this.maximumHours,
    required this.lightIconUrl,
    required this.darkIconUrl,
  });

  final String id;
  final String name;
  final int color;
  final double minimumHours;
  final double? maximumHours;
  final String lightIconUrl;
  final String darkIconUrl;

  @override
  List<Object?> get props => [id];
}

class NextVolunteerTier extends Equatable {
  const NextVolunteerTier({
    required this.id,
    required this.name,
    required this.color,
    required this.requiredHours,
    required this.remainingHours,
    required this.lightIconUrl,
    required this.darkIconUrl,
  });

  final String id;
  final String name;
  final int color;
  final double requiredHours;
  final double remainingHours;
  final String lightIconUrl;
  final String darkIconUrl;

  @override
  List<Object?> get props => [id];
}

class Profile {
  const Profile({
    required this.id,
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
    required this.volunteeringHours,
    required this.tier,
    required this.nextTier,
    required this.tierProgressPercentage,
  });

  final String id;
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
  final DateTime? dateOfBirth;
  final ProfileGender? gender;
  final ProfileEducation? education;
  final String? major;
  final String? universityName;
  final bool isFirstTimeVolunteer;
  final bool hasNationalIdPicture;
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
  final double volunteeringHours;
  final VolunteerTier? tier;
  final NextVolunteerTier? nextTier;
  final int tierProgressPercentage;

  String fullName(bool isArabic) => isArabic ? fullNameAr : fullNameEn;

  Profile copyWith({String? phoneNumber, String? email, bool? emailConfirmed}) {
    return Profile(
      id: id,
      fullNameEn: fullNameEn,
      fullNameAr: fullNameAr,
      email: email ?? this.email,
      emailConfirmed: emailConfirmed ?? this.emailConfirmed,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePictureUrl: profilePictureUrl,
      hasProfilePicture: hasProfilePicture,
      completionPercentage: completionPercentage,
      hasCv: hasCv,
      cvFileName: cvFileName,
      nationality: nationality,
      city: city,
      dateOfBirth: dateOfBirth,
      gender: gender,
      education: education,
      major: major,
      universityName: universityName,
      isFirstTimeVolunteer: isFirstTimeVolunteer,
      hasNationalIdPicture: hasNationalIdPicture,
      isProfileComplete: isProfileComplete,
      nearestLandmark: nearestLandmark,
      district: district,
      neighborhood: neighborhood,
      detailedAddress: detailedAddress,
      volunteerAwards: volunteerAwards,
      isAvailableToVolunteer: isAvailableToVolunteer,
      estimatedWeeklyHours: estimatedWeeklyHours,
      willSignVolunteerServiceAgreement: willSignVolunteerServiceAgreement,
      willProvideNcc: willProvideNcc,
      volunteeringTypes: volunteeringTypes,
      otherVolunteeringSubjects: otherVolunteeringSubjects,
      volunteeringHours: volunteeringHours,
      tier: tier,
      nextTier: nextTier,
      tierProgressPercentage: tierProgressPercentage,
    );
  }
}

class ProfileDetails extends Equatable {
  const ProfileDetails({
    this.nationality,
    this.city,
    this.dateOfBirth,
    this.gender,
    this.education,
    this.major = '',
    this.universityName = '',
    this.isFirstTimeVolunteer = false,
    this.nearestLandmark = '',
    this.district = '',
    this.neighborhood = '',
    this.detailedAddress = '',
    this.volunteerAwards = false,
    this.isAvailableToVolunteer = false,
    this.estimatedWeeklyHours = '',
    this.willSignVolunteerServiceAgreement = false,
    this.willProvideNcc = false,
    this.volunteeringTypes = const [],
    this.otherVolunteeringSubjects = '',
  });

  factory ProfileDetails.fromProfile(Profile profile) {
    return ProfileDetails(
      nationality: profile.nationality,
      city: profile.city,
      dateOfBirth: profile.dateOfBirth,
      gender: profile.gender,
      education: profile.education,
      major: profile.major ?? '',
      universityName: profile.universityName ?? '',
      isFirstTimeVolunteer: profile.isFirstTimeVolunteer,
      nearestLandmark: profile.nearestLandmark ?? '',
      district: profile.district ?? '',
      neighborhood: profile.neighborhood ?? '',
      detailedAddress: profile.detailedAddress ?? '',
      volunteerAwards: profile.volunteerAwards ?? false,
      isAvailableToVolunteer: profile.isAvailableToVolunteer ?? false,
      estimatedWeeklyHours: profile.estimatedWeeklyHours?.toString() ?? '',
      willSignVolunteerServiceAgreement: profile.willSignVolunteerServiceAgreement ?? false,
      willProvideNcc: profile.willProvideNcc ?? false,
      volunteeringTypes: profile.volunteeringTypes,
      otherVolunteeringSubjects: profile.otherVolunteeringSubjects ?? '',
    );
  }

  final ProfileReference? nationality;
  final ProfileReference? city;
  final DateTime? dateOfBirth;
  final ProfileGender? gender;
  final ProfileEducation? education;
  final String major;
  final String universityName;
  final bool isFirstTimeVolunteer;
  final String nearestLandmark;
  final String district;
  final String neighborhood;
  final String detailedAddress;
  final bool volunteerAwards;
  final bool isAvailableToVolunteer;
  final String estimatedWeeklyHours;
  final bool willSignVolunteerServiceAgreement;
  final bool willProvideNcc;
  final List<ProfileReference> volunteeringTypes;
  final String otherVolunteeringSubjects;

  bool get isMajorRequired => education?.isMajorRequired ?? false;

  ProfileDetails copyWith({
    ProfileReference? nationality,
    ProfileReference? city,
    DateTime? dateOfBirth,
    ProfileGender? gender,
    ProfileEducation? education,
    String? major,
    String? universityName,
    bool? isFirstTimeVolunteer,
    String? nearestLandmark,
    String? district,
    String? neighborhood,
    String? detailedAddress,
    bool? volunteerAwards,
    bool? isAvailableToVolunteer,
    String? estimatedWeeklyHours,
    bool? willSignVolunteerServiceAgreement,
    bool? willProvideNcc,
    List<ProfileReference>? volunteeringTypes,
    String? otherVolunteeringSubjects,
  }) {
    return ProfileDetails(
      nationality: nationality ?? this.nationality,
      city: city ?? this.city,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      education: education ?? this.education,
      major: major ?? this.major,
      universityName: universityName ?? this.universityName,
      isFirstTimeVolunteer: isFirstTimeVolunteer ?? this.isFirstTimeVolunteer,
      nearestLandmark: nearestLandmark ?? this.nearestLandmark,
      district: district ?? this.district,
      neighborhood: neighborhood ?? this.neighborhood,
      detailedAddress: detailedAddress ?? this.detailedAddress,
      volunteerAwards: volunteerAwards ?? this.volunteerAwards,
      isAvailableToVolunteer: isAvailableToVolunteer ?? this.isAvailableToVolunteer,
      estimatedWeeklyHours: estimatedWeeklyHours ?? this.estimatedWeeklyHours,
      willSignVolunteerServiceAgreement:
          willSignVolunteerServiceAgreement ?? this.willSignVolunteerServiceAgreement,
      willProvideNcc: willProvideNcc ?? this.willProvideNcc,
      volunteeringTypes: volunteeringTypes ?? this.volunteeringTypes,
      otherVolunteeringSubjects: otherVolunteeringSubjects ?? this.otherVolunteeringSubjects,
    );
  }

  @override
  List<Object?> get props => [
        nationality,
        city,
        dateOfBirth,
        gender,
        education,
        isMajorRequired ? major.trim() : '',
        universityName.trim(),
        isFirstTimeVolunteer,
        nearestLandmark.trim(),
        district.trim(),
        neighborhood.trim(),
        detailedAddress.trim(),
        volunteerAwards,
        isAvailableToVolunteer,
        estimatedWeeklyHours.trim(),
        willSignVolunteerServiceAgreement,
        willProvideNcc,
        volunteeringTypes.map((item) => item.id).toSet(),
        otherVolunteeringSubjects.trim(),
      ];
}

abstract interface class ProfileRepository {
  Future<Either<Failure, Profile>> getProfile();

  Future<Either<Failure, Profile>> updateDetails(ProfileDetails details);

  Future<Either<Failure, void>> updatePhoneNumber(String phoneNumber);

  Future<Either<Failure, Profile>> uploadAttachment(ProfileAttachment attachment, String filePath);

  Future<Either<Failure, void>> deleteAttachment(ProfileAttachment attachment);

  Future<Either<Failure, void>> deleteAccount({
    required String currentPassword,
    String? reason,
  });
}
