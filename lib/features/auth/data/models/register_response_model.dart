class RegisterResponseModel {
  const RegisterResponseModel({
    required this.userId,
    required this.email,
    required this.emailVerificationRequired,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      userId: json['userId'] as String,
      email: json['email'] as String,
      emailVerificationRequired: json['emailVerificationRequired'] as bool,
    );
  }

  final String userId;
  final String email;
  final bool emailVerificationRequired;
}
