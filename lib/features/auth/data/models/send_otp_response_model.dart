import '../../domain/login_verification.dart';

class SendOtpResponseModel {
  const SendOtpResponseModel({required this.resendAfterSeconds});

  factory SendOtpResponseModel.fromJson(Map<String, dynamic> json) {
    return SendOtpResponseModel(resendAfterSeconds: readSeconds(json['resendAfterSeconds']) ?? 0);
  }

  final int resendAfterSeconds;
}
