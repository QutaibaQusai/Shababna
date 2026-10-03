import '../../domain/repositories/profile_repository.dart';

enum ProfileMissingField {
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

  static Set<ProfileMissingField> parse(List<String> keys) =>
      keys.map(fromApi).nonNulls.toSet();

  bool isFilled(ProfileDetails details, {required bool hasNationalIdPicture}) => switch (this) {
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
