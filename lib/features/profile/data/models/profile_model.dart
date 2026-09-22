class ProfileModel {
  const ProfileModel({
    required this.fullNameEn,
    required this.fullNameAr,
    required this.email,
    required this.emailConfirmed,
    required this.phoneNumber,
    required this.profilePictureUrl,
    required this.hasProfilePicture,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      fullNameEn: json['fullNameEn'] as String,
      fullNameAr: json['fullNameAr'] as String,
      email: json['email'] as String,
      emailConfirmed: json['emailConfirmed'] as bool,
      phoneNumber: json['phoneNumber'] as String?,
      profilePictureUrl: json['profilePictureUrl'] as String?,
      hasProfilePicture: json['hasProfilePicture'] as bool,
    );
  }

  final String fullNameEn;
  final String fullNameAr;
  final String email;
  final bool emailConfirmed;
  final String? phoneNumber;
  final String? profilePictureUrl;
  final bool hasProfilePicture;
}
