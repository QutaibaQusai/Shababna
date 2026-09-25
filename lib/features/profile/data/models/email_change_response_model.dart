class EmailChangeResponseModel {
  const EmailChangeResponseModel({required this.verificationRequired, required this.newEmail});

  factory EmailChangeResponseModel.fromJson(Map<String, dynamic> json) {
    return EmailChangeResponseModel(
      verificationRequired: json['verificationRequired'] as bool,
      newEmail: json['newEmail'] as String,
    );
  }

  final bool verificationRequired;
  final String newEmail;
}
