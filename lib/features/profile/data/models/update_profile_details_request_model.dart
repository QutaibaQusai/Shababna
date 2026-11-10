class UpdateProfileDetailsRequestModel {
  const UpdateProfileDetailsRequestModel({
    required this.fullNameEn,
    required this.fullNameAr,
    this.nationalityId,
    this.cityId,
    this.dateOfBirth,
    this.gender,
    this.educationId,
    this.major,
    this.universityName,
    this.isFirstTimeVolunteer,
    this.nearestLandmark,
    this.district,
    this.neighborhood,
    this.detailedAddress,
    this.volunteerAwards,
    this.isAvailableToVolunteer,
    this.estimatedWeeklyHours,
    this.willSignVolunteerServiceAgreement,
    this.willProvideNcc,
    this.volunteeringTypeIds,
    this.otherVolunteeringSubjects,
  });

  final String fullNameEn;
  final String fullNameAr;
  final String? nationalityId;
  final String? cityId;
  final String? dateOfBirth;
  final String? gender;
  final String? educationId;
  final String? major;
  final String? universityName;
  final bool? isFirstTimeVolunteer;
  final String? nearestLandmark;
  final String? district;
  final String? neighborhood;
  final String? detailedAddress;
  final bool? volunteerAwards;
  final bool? isAvailableToVolunteer;
  final int? estimatedWeeklyHours;
  final bool? willSignVolunteerServiceAgreement;
  final bool? willProvideNcc;
  final List<String>? volunteeringTypeIds;
  final String? otherVolunteeringSubjects;

  Map<String, dynamic> toJson() => {
        'fullNameEn': fullNameEn,
        'fullNameAr': fullNameAr,
        'nationalityId': nationalityId,
        'cityId': cityId,
        'dateOfBirth': dateOfBirth,
        'gender': gender,
        'educationId': educationId,
        'major': major,
        'universityName': universityName,
        'isFirstTimeVolunteer': isFirstTimeVolunteer,
        'nearestLandmark': nearestLandmark,
        'district': district,
        'neighborhood': neighborhood,
        'detailedAddress': detailedAddress,
        'volunteerAwards': volunteerAwards,
        'isAvailableToVolunteer': isAvailableToVolunteer,
        'estimatedWeeklyHours': estimatedWeeklyHours,
        'willSignVolunteerServiceAgreement': willSignVolunteerServiceAgreement,
        'willProvideNcc': willProvideNcc,
        'volunteeringTypeIds': volunteeringTypeIds,
        'otherVolunteeringSubjects': otherVolunteeringSubjects,
      };
}
