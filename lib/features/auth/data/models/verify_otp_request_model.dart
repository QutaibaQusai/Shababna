import '../../domain/verification_channel.dart';

class VerifyOtpRequestModel {
  const VerifyOtpRequestModel({
    required this.channel,
    required this.code,
    this.verificationToken,
    this.deviceId,
    this.deviceName,
  });

  final VerificationChannel channel;
  final String code;
  final String? verificationToken;
  final String? deviceId;
  final String? deviceName;

  Map<String, dynamic> toJson() => {
    'channel': channel.apiValue,
    'code': code,
    if (verificationToken != null) 'verificationToken': verificationToken,
    if (deviceId != null) 'deviceId': deviceId,
    if (deviceName != null) 'deviceName': deviceName,
  };
}
