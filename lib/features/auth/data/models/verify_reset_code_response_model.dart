class VerifyResetCodeResponseModel {
  const VerifyResetCodeResponseModel({required this.resetToken});

  factory VerifyResetCodeResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifyResetCodeResponseModel(resetToken: json['resetToken'] as String);
  }

  final String resetToken;
}
