class VerifyRegistrationCodeResponseModel {
  const VerifyRegistrationCodeResponseModel({required this.verificationToken});

  factory VerifyRegistrationCodeResponseModel.fromJson(Map<String, dynamic> json) {
    return VerifyRegistrationCodeResponseModel(
      verificationToken: json['verificationToken'] as String,
    );
  }

  final String verificationToken;
}
