import '../../domain/verification_channel.dart';

class CheckRegistrationRequestModel {
  const CheckRegistrationRequestModel({
    required this.email,
    required this.phoneNumber,
    required this.channel,
  });

  final String email;
  final String phoneNumber;
  final VerificationChannel channel;

  Map<String, dynamic> toJson() => {
    'email': email,
    'phoneNumber': phoneNumber,
    'verificationChannel': channel.apiValue,
  };
}
