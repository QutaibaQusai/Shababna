class RegisterRequestModel {
  const RegisterRequestModel({
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.confirmPassword,
    required this.verificationToken,
  });

  final String email;
  final String phoneNumber;
  final String password;
  final String confirmPassword;
  final String verificationToken;

  Map<String, dynamic> toFormMap() => {
    'Email': email,
    'PhoneNumber': phoneNumber,
    'Password': password,
    'ConfirmPassword': confirmPassword,
    'VerificationToken': verificationToken,
  };
}
