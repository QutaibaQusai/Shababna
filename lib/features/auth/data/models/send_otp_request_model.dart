import '../../domain/verification_channel.dart';

class SendOtpRequestModel {
  const SendOtpRequestModel({required this.channel, this.verificationToken});

  final VerificationChannel channel;
  final String? verificationToken;

  Map<String, dynamic> toJson() => {
    'channel': channel.apiValue,
    if (verificationToken != null) 'verificationToken': verificationToken,
  };
}
