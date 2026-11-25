import 'token_response_model.dart';

class VerifyOtpResponseModel {
  const VerifyOtpResponseModel({this.tokens});

  factory VerifyOtpResponseModel.fromJson(Map<String, dynamic> json) {
    final tokens = json['tokens'];
    return VerifyOtpResponseModel(
      tokens: tokens is Map<String, dynamic> ? TokenResponseModel.fromJson(tokens) : null,
    );
  }

  final TokenResponseModel? tokens;
}
