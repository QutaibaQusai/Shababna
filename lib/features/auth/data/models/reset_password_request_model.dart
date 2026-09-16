class ResetPasswordRequestModel {
  const ResetPasswordRequestModel({
    required this.email,
    required this.code,
    required this.newPassword,
    required this.confirmPassword,
  });

  final String email;
  final String code;
  final String newPassword;
  final String confirmPassword;

  Map<String, dynamic> toJson() => {
        'email': email,
        'code': code,
        'newPassword': newPassword,
        'confirmPassword': confirmPassword,
      };
}
