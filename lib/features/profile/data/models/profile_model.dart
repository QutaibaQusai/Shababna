class ProfileReferenceModel {
  const ProfileReferenceModel({required this.id, required this.name});

  factory ProfileReferenceModel.fromJson(Map<String, dynamic> json) {
    return ProfileReferenceModel(
      id: json['id'] as String,
      name: json['name'] as String,
    );
  }

  final String id;
  final String name;
}

class ProfileEducationModel {
  const ProfileEducationModel({
    required this.id,
    required this.name,
    required this.isMajorRequired,
  });

  factory ProfileEducationModel.fromJson(Map<String, dynamic> json) {
    return ProfileEducationModel(
      id: json['id'] as String,
      name: json['name'] as String,
      isMajorRequired: json['isMajorRequired'] as bool,
    );
  }

  final String id;
  final String name;
  final bool isMajorRequired;
}

class ProfileModel {
  const ProfileModel({
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
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String,
      fullNameEn: json['fullNameEn'] as String,
      fullNameAr: json['fullNameAr'] as String,
      email: json['email'] as String,
      emailConfirmed: json['emailConfirmed'] as bool,
      phoneNumber: json['phoneNumber'] as String?,
      profilePictureUrl: json['profilePictureUrl'] as String?,
      hasProfilePicture: json['hasProfilePicture'] as bool,
      completionPercentage: _parsePercentage(json['profileCompletionPercentage']),
      hasCv: json['hasCv'] as bool,
      cvFileName: json['cvFileName'] as String?,
      nationality: json['nationality'] == null
          ? null
          : ProfileReferenceModel.fromJson(json['nationality'] as Map<String, dynamic>),
      city: json['city'] == null
          ? null
          : ProfileReferenceModel.fromJson(json['city'] as Map<String, dynamic>),
      dateOfBirth: json['dateOfBirth'] as String?,
      gender: json['gender'] as String?,
      education: json['education'] == null
          ? null
          : ProfileEducationModel.fromJson(json['education'] as Map<String, dynamic>),
      major: json['major'] as String?,
      universityName: json['universityName'] as String?,
      isFirstTimeVolunteer: json['isFirstTimeVolunteer'] as bool? ?? false,
      hasNationalIdPicture: json['hasNationalIdPicture'] as bool? ?? false,
      isProfileComplete: json['isProfileComplete'] as bool? ?? false,
      nearestLandmark: json['nearestLandmark'] as String?,
      district: json['district'] as String?,
      neighborhood: json['neighborhood'] as String?,
      detailedAddress: json['detailedAddress'] as String?,
      volunteerAwards: json['volunteerAwards'] as bool?,
      isAvailableToVolunteer: json['isAvailableToVolunteer'] as bool?,
      estimatedWeeklyHours: _parseInt(json['estimatedWeeklyHours']),
      willSignVolunteerServiceAgreement: json['willSignVolunteerServiceAgreement'] as bool?,
      willProvideNcc: json['willProvideNcc'] as bool?,
      volunteeringTypes: (json['volunteeringTypes'] as List? ?? [])
          .map((item) => ProfileReferenceModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      otherVolunteeringSubjects: json['otherVolunteeringSubjects'] as String?,
    );
  }

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
  final ProfileReferenceModel? nationality;
  final ProfileReferenceModel? city;
  final String? dateOfBirth;
  final String? gender;
  final ProfileEducationModel? education;
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
  final List<ProfileReferenceModel> volunteeringTypes;
  final String? otherVolunteeringSubjects;

  static int _parsePercentage(Object? value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static int? _parseInt(Object? value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }
}
