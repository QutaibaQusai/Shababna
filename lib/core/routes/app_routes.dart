class AppRoutes {
  AppRoutes._();

  static const String home = '/home';
  static const String homeName = 'home';

  static const String login = '/login';
  static const String loginName = 'login';

  static const String register = '/register';
  static const String registerName = 'register';

  static const String forgotPassword = '/forgot-password';
  static const String forgotPasswordName = 'forgot-password';

  static const String verifyResetCode = '/verify-reset-code';
  static const String verifyResetCodeName = 'verify-reset-code';

  static const String resetPassword = '/reset-password';
  static const String resetPasswordName = 'reset-password';

  static const String legalContent = '/legal-content';
  static const String legalContentName = 'legal-content';

  static const Set<String> publicRoutes = {
    login,
    register,
    forgotPassword,
    verifyResetCode,
    resetPassword,
  };
}
