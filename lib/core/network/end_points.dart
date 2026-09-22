class EndPoints {
  EndPoints._();

  static const String login = '/api/v1/auth/login';
  static const String checkRegistration = '/api/v1/auth/check-registration';
  static const String verifyRegistrationCode = '/api/v1/auth/verify-registration-code';
  static const String register = '/api/v1/auth/register';
  static const String forgotPassword = '/api/v1/auth/forgot-password';
  static const String verifyResetCode = '/api/v1/auth/verify-reset-code';
  static const String resetPassword = '/api/v1/auth/reset-password';
  static const String refresh = '/api/v1/auth/refresh';
  static const String logout = '/api/v1/auth/logout';
  static const String logoutAll = '/api/v1/auth/logout-all';

  static const String countryPhoneCodes = '/api/v1/countries/phone-codes';

  static const String profile = '/api/v1/profile';

  static const String generalContent = '/api/v1/configuration/general-content';
}
