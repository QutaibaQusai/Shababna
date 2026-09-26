import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Shababna'**
  String get appName;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @noItemsFound.
  ///
  /// In en, this message translates to:
  /// **'No items found'**
  String get noItemsFound;

  /// No description provided for @confirmButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmButton;

  /// No description provided for @yesLabel.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yesLabel;

  /// No description provided for @noLabel.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get noLabel;

  /// No description provided for @cameraOption.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get cameraOption;

  /// No description provided for @galleryOption.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get galleryOption;

  /// No description provided for @codeResentMessage.
  ///
  /// In en, this message translates to:
  /// **'Code resent'**
  String get codeResentMessage;

  /// No description provided for @changePhoneNumberTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Phone Number'**
  String get changePhoneNumberTitle;

  /// No description provided for @changePhoneNumberSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the number you want to use for your account'**
  String get changePhoneNumberSubtitle;

  /// No description provided for @changePhoneNumberSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Phone number updated successfully'**
  String get changePhoneNumberSuccessMessage;

  /// No description provided for @changeEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Email'**
  String get changeEmailTitle;

  /// No description provided for @changeEmailSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your current password and the new email address'**
  String get changeEmailSubtitle;

  /// No description provided for @changeEmailSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Email updated successfully'**
  String get changeEmailSuccessMessage;

  /// No description provided for @newEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'New email'**
  String get newEmailLabel;

  /// No description provided for @verifyEmailChangeTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify your new email'**
  String get verifyEmailChangeTitle;

  /// No description provided for @profilePictureLabel.
  ///
  /// In en, this message translates to:
  /// **'Profile Picture'**
  String get profilePictureLabel;

  /// No description provided for @editProfilePictureSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Profile picture updated successfully'**
  String get editProfilePictureSuccessMessage;

  /// No description provided for @choosePhotoButton.
  ///
  /// In en, this message translates to:
  /// **'Choose Photo'**
  String get choosePhotoButton;

  /// No description provided for @replacePhotoButton.
  ///
  /// In en, this message translates to:
  /// **'Replace Photo'**
  String get replacePhotoButton;

  /// No description provided for @removePhotoButton.
  ///
  /// In en, this message translates to:
  /// **'Remove Photo'**
  String get removePhotoButton;

  /// No description provided for @editCvSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'CV updated successfully'**
  String get editCvSuccessMessage;

  /// No description provided for @uploadCvButton.
  ///
  /// In en, this message translates to:
  /// **'Upload CV'**
  String get uploadCvButton;

  /// No description provided for @replaceCvButton.
  ///
  /// In en, this message translates to:
  /// **'Replace CV'**
  String get replaceCvButton;

  /// No description provided for @removeCvButton.
  ///
  /// In en, this message translates to:
  /// **'Remove CV'**
  String get removeCvButton;

  /// No description provided for @editNationalIdSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'National ID picture updated successfully'**
  String get editNationalIdSuccessMessage;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navNews.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get navNews;

  /// No description provided for @navEvents.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get navEvents;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'My Account'**
  String get navProfile;

  /// No description provided for @profileMenuLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get profileMenuLanguage;

  /// No description provided for @profileMenuLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred language'**
  String get profileMenuLanguageSubtitle;

  /// No description provided for @profileMenuTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get profileMenuTheme;

  /// No description provided for @profileMenuThemeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred appearance'**
  String get profileMenuThemeSubtitle;

  /// No description provided for @profileMenuNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get profileMenuNotifications;

  /// No description provided for @profileMenuNotificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage notifications and general app updates.'**
  String get profileMenuNotificationsSubtitle;

  /// No description provided for @profileMenuAccountSecurity.
  ///
  /// In en, this message translates to:
  /// **'Account Security'**
  String get profileMenuAccountSecurity;

  /// No description provided for @accountSecuritySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your password and account protection'**
  String get accountSecuritySubtitle;

  /// No description provided for @changePasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePasswordTitle;

  /// No description provided for @changePasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a strong password to keep your account secure'**
  String get changePasswordSubtitle;

  /// No description provided for @currentPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get currentPasswordLabel;

  /// No description provided for @changePasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get changePasswordButton;

  /// No description provided for @changePasswordSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Password updated successfully'**
  String get changePasswordSuccessMessage;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccountTitle;

  /// No description provided for @profileMenuContactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get profileMenuContactUs;

  /// No description provided for @profileMenuContactInfo.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get profileMenuContactInfo;

  /// No description provided for @profileMenuAboutUs.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get profileMenuAboutUs;

  /// No description provided for @profileMenuSocialMedia.
  ///
  /// In en, this message translates to:
  /// **'Social Media'**
  String get profileMenuSocialMedia;

  /// No description provided for @socialMediaEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'No social media links available'**
  String get socialMediaEmptyMessage;

  /// No description provided for @socialMediaFacebook.
  ///
  /// In en, this message translates to:
  /// **'Facebook'**
  String get socialMediaFacebook;

  /// No description provided for @socialMediaTwitter.
  ///
  /// In en, this message translates to:
  /// **'Twitter'**
  String get socialMediaTwitter;

  /// No description provided for @socialMediaInstagram.
  ///
  /// In en, this message translates to:
  /// **'Instagram'**
  String get socialMediaInstagram;

  /// No description provided for @socialMediaThreads.
  ///
  /// In en, this message translates to:
  /// **'Threads'**
  String get socialMediaThreads;

  /// No description provided for @socialMediaSnapchat.
  ///
  /// In en, this message translates to:
  /// **'Snapchat'**
  String get socialMediaSnapchat;

  /// No description provided for @socialMediaLinkedIn.
  ///
  /// In en, this message translates to:
  /// **'LinkedIn'**
  String get socialMediaLinkedIn;

  /// No description provided for @socialMediaTikTok.
  ///
  /// In en, this message translates to:
  /// **'TikTok'**
  String get socialMediaTikTok;

  /// No description provided for @socialMediaYoutube.
  ///
  /// In en, this message translates to:
  /// **'YouTube'**
  String get socialMediaYoutube;

  /// No description provided for @webViewDefaultTitle.
  ///
  /// In en, this message translates to:
  /// **'More Details'**
  String get webViewDefaultTitle;

  /// No description provided for @profileMenuPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get profileMenuPrivacyPolicy;

  /// No description provided for @profileMenuTermsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get profileMenuTermsAndConditions;

  /// No description provided for @profileMenuLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get profileMenuLogout;

  /// No description provided for @logoutSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutSheetTitle;

  /// No description provided for @logoutSheetConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutSheetConfirmation;

  /// No description provided for @logoutConfirmButton.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutConfirmButton;

  /// No description provided for @cancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get languageArabic;

  /// No description provided for @actionSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get actionSearch;

  /// No description provided for @doneButton.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get doneButton;

  /// No description provided for @editProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfileTitle;

  /// No description provided for @editProfileSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get editProfileSuccessMessage;

  /// No description provided for @completeYourProfileLabel.
  ///
  /// In en, this message translates to:
  /// **'Complete your profile'**
  String get completeYourProfileLabel;

  /// No description provided for @saveButton.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveButton;

  /// No description provided for @personalInfoSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInfoSectionTitle;

  /// No description provided for @genderLabel.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get genderLabel;

  /// No description provided for @genderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get genderMale;

  /// No description provided for @genderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get genderFemale;

  /// No description provided for @dateOfBirthLabel.
  ///
  /// In en, this message translates to:
  /// **'Date of birth'**
  String get dateOfBirthLabel;

  /// No description provided for @nationalityLabel.
  ///
  /// In en, this message translates to:
  /// **'Nationality'**
  String get nationalityLabel;

  /// No description provided for @cityLabel.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get cityLabel;

  /// No description provided for @educationLabel.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get educationLabel;

  /// No description provided for @majorLabel.
  ///
  /// In en, this message translates to:
  /// **'Major'**
  String get majorLabel;

  /// No description provided for @universityNameLabel.
  ///
  /// In en, this message translates to:
  /// **'University name'**
  String get universityNameLabel;

  /// No description provided for @addressSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get addressSectionTitle;

  /// No description provided for @nearestLandmarkLabel.
  ///
  /// In en, this message translates to:
  /// **'Nearest landmark'**
  String get nearestLandmarkLabel;

  /// No description provided for @districtLabel.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get districtLabel;

  /// No description provided for @neighborhoodLabel.
  ///
  /// In en, this message translates to:
  /// **'Neighborhood'**
  String get neighborhoodLabel;

  /// No description provided for @detailedAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Detailed address'**
  String get detailedAddressLabel;

  /// No description provided for @volunteeringSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Volunteering'**
  String get volunteeringSectionTitle;

  /// No description provided for @isFirstTimeVolunteerLabel.
  ///
  /// In en, this message translates to:
  /// **'First-time volunteer'**
  String get isFirstTimeVolunteerLabel;

  /// No description provided for @volunteerAwardsLabel.
  ///
  /// In en, this message translates to:
  /// **'Volunteer awards'**
  String get volunteerAwardsLabel;

  /// No description provided for @isAvailableToVolunteerLabel.
  ///
  /// In en, this message translates to:
  /// **'Available to volunteer'**
  String get isAvailableToVolunteerLabel;

  /// No description provided for @willSignVolunteerServiceAgreementLabel.
  ///
  /// In en, this message translates to:
  /// **'Will sign volunteer service agreement'**
  String get willSignVolunteerServiceAgreementLabel;

  /// No description provided for @willProvideNccLabel.
  ///
  /// In en, this message translates to:
  /// **'Will provide non-criminal certificate'**
  String get willProvideNccLabel;

  /// No description provided for @estimatedWeeklyHoursLabel.
  ///
  /// In en, this message translates to:
  /// **'Estimated weekly hours'**
  String get estimatedWeeklyHoursLabel;

  /// No description provided for @volunteeringTypesLabel.
  ///
  /// In en, this message translates to:
  /// **'Volunteering types'**
  String get volunteeringTypesLabel;

  /// No description provided for @otherVolunteeringSubjectsLabel.
  ///
  /// In en, this message translates to:
  /// **'Other volunteering subjects'**
  String get otherVolunteeringSubjectsLabel;

  /// No description provided for @documentsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Documents'**
  String get documentsSectionTitle;

  /// No description provided for @cvLabel.
  ///
  /// In en, this message translates to:
  /// **'CV'**
  String get cvLabel;

  /// No description provided for @nationalIdPictureLabel.
  ///
  /// In en, this message translates to:
  /// **'National ID picture'**
  String get nationalIdPictureLabel;

  /// No description provided for @documentUploadedStatus.
  ///
  /// In en, this message translates to:
  /// **'Uploaded'**
  String get documentUploadedStatus;

  /// No description provided for @documentNotUploadedStatus.
  ///
  /// In en, this message translates to:
  /// **'Not uploaded'**
  String get documentNotUploadedStatus;

  /// No description provided for @actionNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get actionNotifications;

  /// No description provided for @comingSoonMessage.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get comingSoonMessage;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Shababna'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Discover volunteering opportunities, track your impact, and earn certificates for every contribution.'**
  String get loginSubtitle;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'you@example.com'**
  String get emailHint;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for @forgotPasswordLink.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPasswordLink;

  /// No description provided for @noAccountPrompt.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccountPrompt;

  /// No description provided for @registerLink.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerLink;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get registerTitle;

  /// No description provided for @stepNameTitle.
  ///
  /// In en, this message translates to:
  /// **'Your name'**
  String get stepNameTitle;

  /// No description provided for @stepNameSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tell us your full name in Arabic and English'**
  String get stepNameSubtitle;

  /// No description provided for @fullNameArLabel.
  ///
  /// In en, this message translates to:
  /// **'Full name (Arabic)'**
  String get fullNameArLabel;

  /// No description provided for @fullNameEnLabel.
  ///
  /// In en, this message translates to:
  /// **'Full name (English)'**
  String get fullNameEnLabel;

  /// No description provided for @stepContactTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact details'**
  String get stepContactTitle;

  /// No description provided for @stepContactSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll use this to verify your account and keep you updated'**
  String get stepContactSubtitle;

  /// No description provided for @phoneNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumberLabel;

  /// No description provided for @stepPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Set a password'**
  String get stepPasswordTitle;

  /// No description provided for @stepPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a strong password to secure your account'**
  String get stepPasswordSubtitle;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPasswordLabel;

  /// No description provided for @nextButton.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextButton;

  /// No description provided for @backButton.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get backButton;

  /// No description provided for @createAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccountButton;

  /// No description provided for @alreadyHaveAccountPrompt.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccountPrompt;

  /// No description provided for @loginLink.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginLink;

  /// No description provided for @verifyEmailTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify your email'**
  String get verifyEmailTitle;

  /// No description provided for @verifyEmailSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the code sent to {email}'**
  String verifyEmailSubtitle(String email);

  /// No description provided for @verifyButton.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verifyButton;

  /// No description provided for @resendCodePrompt.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the code?'**
  String get resendCodePrompt;

  /// No description provided for @resendCodeButton.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get resendCodeButton;

  /// No description provided for @registrationCompleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Account created. You can now log in.'**
  String get registrationCompleteMessage;

  /// No description provided for @accountRecoveryTitle.
  ///
  /// In en, this message translates to:
  /// **'Account recovery'**
  String get accountRecoveryTitle;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get forgotPasswordTitle;

  /// No description provided for @forgotPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and we\'ll send you a code to reset your password'**
  String get forgotPasswordSubtitle;

  /// No description provided for @sendCodeButton.
  ///
  /// In en, this message translates to:
  /// **'Send code'**
  String get sendCodeButton;

  /// No description provided for @invalidCodeError.
  ///
  /// In en, this message translates to:
  /// **'Enter the {length}-digit code'**
  String invalidCodeError(int length);

  /// No description provided for @verifyResetCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Check your email'**
  String get verifyResetCodeTitle;

  /// No description provided for @verifyResetCodeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the code we sent to {email}'**
  String verifyResetCodeSubtitle(String email);

  /// No description provided for @resetPasswordAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPasswordAppBarTitle;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Create a new password'**
  String get resetPasswordTitle;

  /// No description provided for @resetPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a new password for your account'**
  String get resetPasswordSubtitle;

  /// No description provided for @newPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get newPasswordLabel;

  /// No description provided for @resetPasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPasswordButton;

  /// No description provided for @passwordResetSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Password reset. You can now log in.'**
  String get passwordResetSuccessMessage;

  /// No description provided for @fieldRequiredError.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequiredError;

  /// No description provided for @invalidEmailError.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get invalidEmailError;

  /// No description provided for @passwordsDoNotMatchError.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatchError;

  /// No description provided for @invalidPhoneNumberError.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid phone number'**
  String get invalidPhoneNumberError;

  /// No description provided for @phoneNumberLengthError.
  ///
  /// In en, this message translates to:
  /// **'Phone number must be {length} digits'**
  String phoneNumberLengthError(int length);

  /// No description provided for @phoneNumberPrefixError.
  ///
  /// In en, this message translates to:
  /// **'Phone number must start with {prefixes}'**
  String phoneNumberPrefixError(String prefixes);

  /// No description provided for @searchCountryHint.
  ///
  /// In en, this message translates to:
  /// **'Search country or code'**
  String get searchCountryHint;

  /// No description provided for @contactInfoEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get contactInfoEmailLabel;

  /// No description provided for @contactInfoComplaintsEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Complaints Email'**
  String get contactInfoComplaintsEmailLabel;

  /// No description provided for @contactInfoPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get contactInfoPhoneLabel;

  /// No description provided for @contactInfoComplaintsPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Complaints Phone'**
  String get contactInfoComplaintsPhoneLabel;

  /// No description provided for @contactInfoAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get contactInfoAddressLabel;

  /// No description provided for @contactFormTitle.
  ///
  /// In en, this message translates to:
  /// **'Send us a message'**
  String get contactFormTitle;

  /// No description provided for @contactFormSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll get back to you as soon as possible'**
  String get contactFormSubtitle;

  /// No description provided for @fullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullNameLabel;

  /// No description provided for @subjectLabel.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get subjectLabel;

  /// No description provided for @messageLabel.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get messageLabel;

  /// No description provided for @contactSendButton.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get contactSendButton;

  /// No description provided for @contactSubmitSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Your message has been sent. We\'ll be in touch soon.'**
  String get contactSubmitSuccessMessage;

  /// No description provided for @discardChangesTitle.
  ///
  /// In en, this message translates to:
  /// **'Discard changes?'**
  String get discardChangesTitle;

  /// No description provided for @discardChangesMessage.
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes. If you leave now, they will be lost.'**
  String get discardChangesMessage;

  /// No description provided for @discardButton.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discardButton;

  /// No description provided for @removeButton.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get removeButton;

  /// No description provided for @uploadingLabel.
  ///
  /// In en, this message translates to:
  /// **'Uploading…'**
  String get uploadingLabel;

  /// No description provided for @weeklyHoursRangeError.
  ///
  /// In en, this message translates to:
  /// **'Enter a number between {min} and {max}'**
  String weeklyHoursRangeError(int min, int max);

  /// No description provided for @majorRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Major is required for this education level'**
  String get majorRequiredError;

  /// No description provided for @fileTooLargeError.
  ///
  /// In en, this message translates to:
  /// **'File is too large. Maximum size is {size} MB'**
  String fileTooLargeError(int size);

  /// No description provided for @emailVerifiedLabel.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get emailVerifiedLabel;

  /// No description provided for @emailNotVerifiedLabel.
  ///
  /// In en, this message translates to:
  /// **'Not verified'**
  String get emailNotVerifiedLabel;

  /// No description provided for @currentEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Current email'**
  String get currentEmailLabel;

  /// No description provided for @newEmailSameAsCurrentError.
  ///
  /// In en, this message translates to:
  /// **'New email must be different from your current email'**
  String get newEmailSameAsCurrentError;

  /// No description provided for @profileVerifyEmailSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the code we sent to {email} to confirm your new email'**
  String profileVerifyEmailSubtitle(String email);

  /// No description provided for @profileVerifyEmailButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm email'**
  String get profileVerifyEmailButton;

  /// No description provided for @profileResendEmailPrompt.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t get the code?'**
  String get profileResendEmailPrompt;

  /// No description provided for @profileResendEmailButton.
  ///
  /// In en, this message translates to:
  /// **'Send a new code'**
  String get profileResendEmailButton;

  /// No description provided for @profileEmailCodeResentMessage.
  ///
  /// In en, this message translates to:
  /// **'A new code was sent to your new email'**
  String get profileEmailCodeResentMessage;

  /// No description provided for @profileInvalidEmailCodeError.
  ///
  /// In en, this message translates to:
  /// **'Enter the {length}-digit code from your email'**
  String profileInvalidEmailCodeError(int length);

  /// No description provided for @profilePictureRemovedMessage.
  ///
  /// In en, this message translates to:
  /// **'Profile picture removed'**
  String get profilePictureRemovedMessage;

  /// No description provided for @removePhotoConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove profile picture?'**
  String get removePhotoConfirmTitle;

  /// No description provided for @removePhotoConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Your profile picture will be deleted.'**
  String get removePhotoConfirmMessage;

  /// No description provided for @cvRemovedMessage.
  ///
  /// In en, this message translates to:
  /// **'CV removed'**
  String get cvRemovedMessage;

  /// No description provided for @removeCvConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove CV?'**
  String get removeCvConfirmTitle;

  /// No description provided for @removeCvConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Your CV will be deleted from your profile.'**
  String get removeCvConfirmMessage;

  /// No description provided for @cvFormatsHint.
  ///
  /// In en, this message translates to:
  /// **'PDF, DOC or DOCX · up to {size} MB'**
  String cvFormatsHint(int size);

  /// No description provided for @nationalIdRemovedMessage.
  ///
  /// In en, this message translates to:
  /// **'National ID picture removed'**
  String get nationalIdRemovedMessage;

  /// No description provided for @removeNationalIdConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove National ID picture?'**
  String get removeNationalIdConfirmTitle;

  /// No description provided for @removeNationalIdConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Your National ID picture will be deleted.'**
  String get removeNationalIdConfirmMessage;

  /// No description provided for @removeNationalIdButton.
  ///
  /// In en, this message translates to:
  /// **'Remove National ID'**
  String get removeNationalIdButton;

  /// No description provided for @continueAsGuestButton.
  ///
  /// In en, this message translates to:
  /// **'Continue as guest'**
  String get continueAsGuestButton;

  /// No description provided for @guestGateTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get guestGateTitle;

  /// No description provided for @guestGateMessage.
  ///
  /// In en, this message translates to:
  /// **'Create a free account or sign in to use this feature and keep track of your volunteering.'**
  String get guestGateMessage;

  /// No description provided for @guestProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Shababna'**
  String get guestProfileTitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
