class VerifyRegistrationCodeRequestModel {
  const VerifyRegistrationCodeRequestModel({
    required this.email,
    required this.phoneNumber,
    required this.code,
  });

  final String email;
  final String phoneNumber;
  final String code;

  Map<String, dynamic> toJson() => {
    'email': email,
    'phoneNumber': phoneNumber,
    'code': code,
  };
}
