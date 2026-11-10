import '../../../../l10n/app_localizations.dart';
import '../../domain/repositories/profile_repository.dart';

enum ProfileMissingField {
  fullNameAr,
  fullNameEn,
  gender,
  dateOfBirth,
  nationality,
  city,
  education,
  major,
  nearestLandmark,
  district,
  neighborhood,
  detailedAddress,
  volunteerAwards,
  isAvailableToVolunteer,
  willSignVolunteerServiceAgreement,
  willProvideNcc,
  estimatedWeeklyHours,
  volunteeringTypes,
  nationalIdPicture;

  static ProfileMissingField? fromApi(String key) => switch (key) {
    'fullNameAr' => fullNameAr,
    'fullNameEn' => fullNameEn,
    'gender' => gender,
    'dateOfBirth' => dateOfBirth,
    'nationality' => nationality,
    'city' => city,
    'education' => education,
    'major' => major,
    'nearestLandmark' => nearestLandmark,
    'district' => district,
    'neighborhood' => neighborhood,
    'detailedAddress' => detailedAddress,
    'volunteerAwards' => volunteerAwards,
    'isAvailableToVolunteer' => isAvailableToVolunteer,
    'willSignVolunteerServiceAgreement' => willSignVolunteerServiceAgreement,
    'willProvideNcc' => willProvideNcc,
    'estimatedWeeklyHours' => estimatedWeeklyHours,
    'volunteeringTypeIds' => volunteeringTypes,
    'nationalIdPicture' => nationalIdPicture,
    _ => null,
  };

  String label(AppLocalizations l10n) => switch (this) {
    fullNameAr => l10n.fullNameArLabel,
    fullNameEn => l10n.fullNameEnLabel,
    gender => l10n.genderLabel,
    dateOfBirth => l10n.dateOfBirthLabel,
    nationality => l10n.nationalityLabel,
    city => l10n.cityLabel,
    education => l10n.educationLabel,
    major => l10n.majorLabel,
    nearestLandmark => l10n.nearestLandmarkLabel,
    district => l10n.districtLabel,
    neighborhood => l10n.neighborhoodLabel,
    detailedAddress => l10n.detailedAddressLabel,
    volunteerAwards => l10n.volunteerAwardsLabel,
    isAvailableToVolunteer => l10n.isAvailableToVolunteerLabel,
    willSignVolunteerServiceAgreement => l10n.willSignVolunteerServiceAgreementLabel,
    willProvideNcc => l10n.willProvideNccLabel,
    estimatedWeeklyHours => l10n.estimatedWeeklyHoursLabel,
    volunteeringTypes => l10n.volunteeringTypesLabel,
    nationalIdPicture => l10n.nationalIdPictureLabel,
  };

  static Set<ProfileMissingField> parse(List<String> keys) =>
      keys.map(fromApi).nonNulls.toSet();

  bool isFilled(ProfileDetails details, {required bool hasNationalIdPicture}) => switch (this) {
    fullNameAr => details.fullNameAr.trim().isNotEmpty,
    fullNameEn => details.fullNameEn.trim().isNotEmpty,
    gender => details.gender != null,
    dateOfBirth => details.dateOfBirth != null,
    nationality => details.nationality != null,
    city => details.city != null,
    education => details.education != null,
    major => details.major.trim().isNotEmpty,
    nearestLandmark => details.nearestLandmark.trim().isNotEmpty,
    district => details.district.trim().isNotEmpty,
    neighborhood => details.neighborhood.trim().isNotEmpty,
    detailedAddress => details.detailedAddress.trim().isNotEmpty,
    volunteerAwards => details.volunteerAwards,
    isAvailableToVolunteer => details.isAvailableToVolunteer,
    willSignVolunteerServiceAgreement => details.willSignVolunteerServiceAgreement,
    willProvideNcc => details.willProvideNcc,
    estimatedWeeklyHours => details.estimatedWeeklyHours.trim().isNotEmpty,
    volunteeringTypes => details.volunteeringTypes.isNotEmpty,
    nationalIdPicture => hasNationalIdPicture,
  };
}
