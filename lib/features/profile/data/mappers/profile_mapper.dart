import '../../../../core/config/app_config.dart';
import '../../domain/repositories/profile_repository.dart';
import '../models/profile_model.dart';
import '../models/update_profile_details_request_model.dart';

extension ProfileModelMapper on ProfileModel {
  Profile toEntity() {
    return Profile(
      id: id,
      fullNameEn: fullNameEn,
      fullNameAr: fullNameAr,
      email: email,
      emailConfirmed: emailConfirmed,
      phoneNumber: phoneNumber,
      profilePictureUrl: _absoluteUrl(profilePictureUrl),
      hasProfilePicture: hasProfilePicture,
      completionPercentage: completionPercentage.clamp(0, 100),
      hasCv: hasCv,
      cvFileName: cvFileName,
      nationality: nationality == null
          ? null
          : ProfileReference(id: nationality!.id, name: nationality!.name),
      city: city == null ? null : ProfileReference(id: city!.id, name: city!.name),
      dateOfBirth: dateOfBirth == null ? null : DateTime.tryParse(dateOfBirth!),
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
      volunteeringHours: volunteeringHours,
      tier: tier == null
          ? null
          : VolunteerTier(
              id: tier!.id,
              name: tier!.name,
              color: _parseColor(tier!.color),
              minimumHours: tier!.minimumHours,
              maximumHours: tier!.maximumHours,
              lightIconUrl: tier!.lightIconUrl,
              darkIconUrl: tier!.darkIconUrl,
            ),
      nextTier: nextTier == null
          ? null
          : NextVolunteerTier(
              id: nextTier!.id,
              name: nextTier!.name,
              color: _parseColor(nextTier!.color),
              requiredHours: nextTier!.requiredHours,
              remainingHours: nextTier!.remainingHours,
              lightIconUrl: nextTier!.lightIconUrl,
              darkIconUrl: nextTier!.darkIconUrl,
            ),
      tierProgressPercentage: tierProgressPercentage,
    );
  }

  int _parseColor(String hex) {
    final digits = hex.replaceFirst('#', '');
    final value = int.parse(digits, radix: 16);
    return switch (digits.length) {
      6 => 0xFF000000 | value,
      8 => value,
      _ => throw FormatException('Invalid tier color', hex),
    };
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

extension ProfileDetailsMapper on ProfileDetails {
  UpdateProfileDetailsRequestModel toRequest() {
    return UpdateProfileDetailsRequestModel(
      fullNameEn: fullNameEn.trim(),
      fullNameAr: fullNameAr.trim(),
      nationalityId: nationality?.id,
      cityId: city?.id,
      dateOfBirth: dateOfBirth == null ? null : _isoDate(dateOfBirth!),
      gender: gender == null ? null : _genderToApiValue(gender!),
      educationId: education?.id,
      major: isMajorRequired ? _orNull(major) : null,
      universityName: _orNull(universityName),
      isFirstTimeVolunteer: isFirstTimeVolunteer,
      nearestLandmark: _orNull(nearestLandmark),
      district: _orNull(district),
      neighborhood: _orNull(neighborhood),
      detailedAddress: _orNull(detailedAddress),
      volunteerAwards: volunteerAwards,
      isAvailableToVolunteer: isAvailableToVolunteer,
      estimatedWeeklyHours: int.tryParse(estimatedWeeklyHours.trim()),
      willSignVolunteerServiceAgreement: willSignVolunteerServiceAgreement,
      willProvideNcc: willProvideNcc,
      volunteeringTypeIds: volunteeringTypes.map((item) => item.id).toSet().toList(),
      otherVolunteeringSubjects: _orNull(otherVolunteeringSubjects),
    );
  }

  String? _orNull(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  String _isoDate(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  String _genderToApiValue(ProfileGender gender) => switch (gender) {
        ProfileGender.male => 'Male',
        ProfileGender.female => 'Female',
      };
}
