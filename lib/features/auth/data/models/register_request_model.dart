class RegisterRequestModel {
  const RegisterRequestModel({
    required this.email,
    required this.phoneNumber,
    required this.fullName,
    required this.password,
    required this.confirmPassword,
    required this.verificationToken,
  });

  final String email;
  final String phoneNumber;
  final String fullName;
  final String password;
  final String confirmPassword;
  final String verificationToken;

  Map<String, dynamic> toFormMap() => {
    'Email': email,
    'PhoneNumber': phoneNumber,
    'FullName': fullName,
    'Password': password,
    'ConfirmPassword': confirmPassword,
    'VerificationToken': verificationToken,
  };
}
