class CheckRegistrationRequestModel {
  const CheckRegistrationRequestModel({required this.email, required this.phoneNumber});

  static const _emailVerificationChannel = 'Email';

  final String email;
  final String phoneNumber;

  Map<String, dynamic> toJson() => {
    'email': email,
    'phoneNumber': phoneNumber,
    'verificationChannel': _emailVerificationChannel,
  };
}
