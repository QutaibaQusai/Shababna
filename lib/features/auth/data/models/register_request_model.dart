class RegisterRequestModel {
  const RegisterRequestModel({
    required this.email,
    required this.phoneNumber,
    required this.fullNameEn,
    required this.fullNameAr,
    required this.password,
    required this.confirmPassword,
    required this.verificationToken,
  });

  final String email;
  final String phoneNumber;
  final String fullNameEn;
  final String fullNameAr;
  final String password;
  final String confirmPassword;
  final String verificationToken;

  Map<String, dynamic> toFormMap() => {
        'Email': email,
        'PhoneNumber': phoneNumber,
        'FullNameEn': fullNameEn,
        'FullNameAr': fullNameAr,
        'Password': password,
        'ConfirmPassword': confirmPassword,
        'VerificationToken': verificationToken,
      };
}
