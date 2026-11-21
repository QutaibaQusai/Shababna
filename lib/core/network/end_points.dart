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

  static const String contactInformation = '/api/v1/configuration/contact-information';
  static const String contactForms = '/api/v1/contact-forms';

  static const String socialMediaLinks = '/api/v1/configuration/social-media-links';

  static const String changePassword = '/api/v1/profile/change-password';
  static const String profileDetails = '/api/v2/profile/details';
  static const String dashboard = '/api/v2/dashboard';

  static const String countries = '/api/v1/countries';
  static const String cities = '/api/v1/cities';
  static const String educations = '/api/v1/educations';
  static const String volunteeringTypes = '/api/v1/volunteering-types';

  static const String phoneNumber = '/api/v1/profile/phone-number';
  static const String changeEmail = '/api/v1/profile/change-email';
  static const String verifyEmailChange = '/api/v1/profile/verify-email-change';
  static const String resendEmailChangeCode = '/api/v1/profile/resend-email-change-code';
  static const String profilePicture = '/api/v1/profile/picture';
  static const String cv = '/api/v1/profile/cv';
  static const String nationalId = '/api/v1/profile/national-id';

  static const String deleteAccount = '/api/v1/profile/delete-account';

  static const String news = '/api/v1/news';
  static const String newsSearch = '$news/search';
  static String newsById(String id) => '$news/$id';

  static const String holidays = '/api/v1/holidays';

  static const String notifications = '/api/v1/notifications';
  static const String notificationsUnreadCount = '$notifications/unread-count';
  static const String notificationPreferences = '$notifications/preferences';
  static const String notificationDeviceToken = '$notifications/device-token';
  static String notificationById(String id) => '$notifications/$id';
  static String notificationRead(String id) => '$notifications/$id/read';

  static const String certificates = '/api/v1/certificates';
  static String certificateById(String id) => '$certificates/$id';

  static const String volunteeringOpportunities = '/api/v1/events';
  static String volunteeringOpportunityById(String id) => '$volunteeringOpportunities/$id';
  static String volunteeringOpportunityRegister(String id) =>
      '$volunteeringOpportunities/$id/register';
  static String volunteeringOpportunityWithdraw(String id) =>
      '$volunteeringOpportunities/$id/withdraw';
  static const String volunteeringOpportunityTypes = '/api/v1/event-types';
  static const String volunteeringOpportunitiesSuggested = '$volunteeringOpportunities/suggested';
  static const String volunteeringOpportunitiesByDate = '$volunteeringOpportunities/by-date';
  static const String volunteeringOpportunitiesUpcoming = '$volunteeringOpportunities/upcoming';

  static const String sliders = '/api/v1/sliders';

  static const String search = '/api/v1/search';

  static const String volunteeringOpportunityTasks = '/api/v1/event-tasks';
  static String volunteeringOpportunityTasksOfVolunteeringOpportunity(
    String volunteeringOpportunityId,
  ) => '$volunteeringOpportunities/$volunteeringOpportunityId/tasks';
  static String volunteeringOpportunityTask(String id) => '$volunteeringOpportunityTasks/$id';
  static String volunteeringOpportunityTaskAttachment(String id, String attachmentId) =>
      '$volunteeringOpportunityTasks/$id/attachments/$attachmentId';
  static String volunteeringOpportunityTaskForm(String id) =>
      '$volunteeringOpportunityTasks/$id/verification-form';
  static String volunteeringOpportunityTaskSubmission(String id) =>
      '$volunteeringOpportunityTasks/$id/submission';
  static String volunteeringOpportunityTaskSubmissionFile(String id, String fileId) =>
      '$volunteeringOpportunityTasks/$id/submission/files/$fileId';

  static const String chatbots = '/api/v1/chatbots';
  static const String chatbotQuestionsSearch = '$chatbots/questions/search';
  static String chatbotQuestions(String chatbotId) => '$chatbots/$chatbotId/questions';
  static String chatbotQuestion(String chatbotId, String questionId) =>
      '$chatbots/$chatbotId/questions/$questionId';
}
