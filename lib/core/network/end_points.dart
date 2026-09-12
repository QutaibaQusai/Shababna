class EndPoints {
  EndPoints._();

  static const String login = '/api/v1/auth/login';
  static const String register = '/api/v1/auth/register';
  static const String verifyEmail = '/api/v1/auth/verify-email';
  static const String resendEmailVerification = '/api/v1/auth/resend-email-verification';
  static const String forgotPassword = '/api/v1/auth/forgot-password';
  static const String resetPassword = '/api/v1/auth/reset-password';
  static const String refresh = '/api/v1/auth/refresh';
  static const String logout = '/api/v1/auth/logout';
  static const String logoutAll = '/api/v1/auth/logout-all';
}
