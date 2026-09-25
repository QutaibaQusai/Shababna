class ProfileModel {
  const ProfileModel({
    required this.fullNameEn,
    required this.fullNameAr,
    required this.email,
    required this.emailConfirmed,
    required this.phoneNumber,
    required this.profilePictureUrl,
    required this.hasProfilePicture,
    required this.completionPercentage,
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
      completionPercentage: _parsePercentage(json['profileCompletionPercentage']),
    );
  }

  final String fullNameEn;
  final String fullNameAr;
  final String email;
  final bool emailConfirmed;
  final String? phoneNumber;
  final String? profilePictureUrl;
  final bool hasProfilePicture;
  final int completionPercentage;

  static int _parsePercentage(Object? value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 100;
    return 100;
  }
}
