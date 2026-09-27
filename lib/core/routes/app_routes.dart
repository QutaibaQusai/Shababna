class AppRoutes {
  AppRoutes._();

  static const String home = '/home';
  static const String homeName = 'home';

  static const String login = '/login';
  static const String loginName = 'login';
  static const String modalQuery = 'modal';
  static const String loginModal = '$login?$modalQuery=true';

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

  static const String contactInfo = '/contact-info';
  static const String contactInfoName = 'contact-info';

  static const String contactForm = '/contact-form';
  static const String contactFormName = 'contact-form';

  static const String aboutUs = '/about-us';
  static const String aboutUsName = 'about-us';

  static const String socialMedia = '/social-media';
  static const String socialMediaName = 'social-media';

  static const String webView = '/web-view';
  static const String webViewName = 'web-view';

  static const String accountSecurity = '/account-security';
  static const String accountSecurityName = 'account-security';

  static const String changePassword = '/change-password';
  static const String changePasswordName = 'change-password';

  static const String editProfile = '/edit-profile';
  static const String editProfileName = 'edit-profile';

  static const String changePhoneNumber = '/change-phone-number';
  static const String changePhoneNumberName = 'change-phone-number';

  static const String changeEmail = '/change-email';
  static const String changeEmailName = 'change-email';

  static const String verifyEmailChange = '/verify-email-change';
  static const String verifyEmailChangeName = 'verify-email-change';

  static const String news = '/news';
  static const String newsName = 'news';

  static const String newsDetails = '/news/:id';
  static const String newsDetailsName = 'news-details';
  static String newsDetailsPath(String id) => '/news/$id';

  static const Set<String> memberRoutes = {
    accountSecurity,
    changePassword,
    editProfile,
    changePhoneNumber,
    changeEmail,
    verifyEmailChange,
    contactForm,
  };

  static const Set<String> publicRoutes = {
    login,
    register,
    forgotPassword,
    verifyResetCode,
    resetPassword,
  };
}
