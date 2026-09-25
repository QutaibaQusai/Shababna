import '../../../../core/config/app_config.dart';
import '../../domain/repositories/profile_repository.dart';
import '../models/profile_model.dart';

extension ProfileModelMapper on ProfileModel {
  Profile toEntity() {
    return Profile(
      fullNameEn: fullNameEn,
      fullNameAr: fullNameAr,
      email: email,
      emailConfirmed: emailConfirmed,
      phoneNumber: phoneNumber,
      profilePictureUrl: _absoluteUrl(profilePictureUrl),
      hasProfilePicture: hasProfilePicture,
      completionPercentage: completionPercentage,
      hasCv: hasCv,
      cvFileName: cvFileName,
      nationality: nationality == null
          ? null
          : ProfileReference(id: nationality!.id, name: nationality!.name),
      city: city == null ? null : ProfileReference(id: city!.id, name: city!.name),
      dateOfBirth: dateOfBirth,
      gender: _genderFromApiValue(gender),
      education: education == null
          ? null
          : ProfileEducation(
              id: education!.id,
              name: education!.name,
              isMajorRequired: education!.isMajorRequired,
            ),
      major: major,
      universityName: universityName,
      isFirstTimeVolunteer: isFirstTimeVolunteer,
      hasNationalIdPicture: hasNationalIdPicture,
      nationalIdPictureUrl: _absoluteUrl(nationalIdPictureUrl),
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
      volunteeringTypes:
          volunteeringTypes.map((item) => ProfileReference(id: item.id, name: item.name)).toList(),
      otherVolunteeringSubjects: otherVolunteeringSubjects,
    );
  }

  String? _absoluteUrl(String? path) {
    if (path == null) return null;
    return path.startsWith('http') ? path : '${AppConfig.baseUrl}$path';
  }

  ProfileGender? _genderFromApiValue(String? value) => switch (value) {
        'Male' => ProfileGender.male,
        'Female' => ProfileGender.female,
        _ => null,
      };
}

String genderToApiValue(ProfileGender gender) => switch (gender) {
      ProfileGender.male => 'Male',
      ProfileGender.female => 'Female',
    };
