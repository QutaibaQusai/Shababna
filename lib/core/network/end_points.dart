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
  static const String profileDetails = '/api/v1/profile/details';

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

  static const String events = '/api/v1/events';
  static String eventById(String id) => '$events/$id';
  static String eventRegister(String id) => '$events/$id/register';
  static String eventWithdraw(String id) => '$events/$id/withdraw';

  static const String search = '/api/v1/search';

  static const String eventTasks = '/api/v1/event-tasks';
  static String eventTasksOfEvent(String eventId) => '$events/$eventId/tasks';
  static String eventTask(String id) => '$eventTasks/$id';
  static String eventTaskAttachment(String id, String attachmentId) =>
      '$eventTasks/$id/attachments/$attachmentId';
  static String eventTaskForm(String id) => '$eventTasks/$id/verification-form';
  static String eventTaskSubmission(String id) => '$eventTasks/$id/submission';
  static String eventTaskSubmissionFile(String id, String fileId) =>
      '$eventTasks/$id/submission/files/$fileId';

  static const String chatbots = '/api/v1/chatbots';
  static const String chatbotQuestionsSearch = '$chatbots/questions/search';
  static String chatbotQuestions(String chatbotId) => '$chatbots/$chatbotId/questions';
  static String chatbotQuestion(String chatbotId, String questionId) =>
      '$chatbots/$chatbotId/questions/$questionId';
}
