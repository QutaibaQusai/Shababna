class RegisterRequestModel {
  const RegisterRequestModel({
    required this.email,
    required this.phoneNumber,
    required this.fullNameEn,
    required this.fullNameAr,
    required this.password,
    required this.confirmPassword,
  });

  final String email;
  final String phoneNumber;
  final String fullNameEn;
  final String fullNameAr;
  final String password;
  final String confirmPassword;

  Map<String, dynamic> toFormMap() => {
        'Email': email,
        'PhoneNumber': phoneNumber,
        'FullNameEn': fullNameEn,
        'FullNameAr': fullNameAr,
        'Password': password,
        'ConfirmPassword': confirmPassword,
      };
}
