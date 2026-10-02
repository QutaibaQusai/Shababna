class AppShareLinks {
  AppShareLinks._();

  static const String aboutUs = '/about-us';
  static const String privacyPolicy = '/legal/privacy-policy';
  static const String termsAndConditions = '/legal/terms-and-conditions';
  static const String socialMedia = '/social-media';

  static String newsDetails(String id) => '/news/$id';
  static String eventDetails(String id) => '/events/$id';
}
