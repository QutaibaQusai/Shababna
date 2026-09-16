// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Shababna';

  @override
  String get retry => 'Retry';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get noItemsFound => 'No items found';

  @override
  String get loginTitle => 'Welcome back';

  @override
  String get loginSubtitle => 'Sign in to continue';

  @override
  String get emailLabel => 'Email';

  @override
  String get emailHint => 'you@example.com';

  @override
  String get passwordLabel => 'Password';

  @override
  String get loginButton => 'Login';

  @override
  String get forgotPasswordLink => 'Forgot password?';

  @override
  String get noAccountPrompt => 'Don\'t have an account?';

  @override
  String get registerLink => 'Register';

  @override
  String get registerTitle => 'Create account';

  @override
  String get stepNameTitle => 'Your name';

  @override
  String get fullNameArLabel => 'Full name (Arabic)';

  @override
  String get fullNameEnLabel => 'Full name (English)';

  @override
  String get stepContactTitle => 'Contact details';

  @override
  String get phoneNumberLabel => 'Phone number';

  @override
  String get stepPasswordTitle => 'Set a password';

  @override
  String get confirmPasswordLabel => 'Confirm password';

  @override
  String get nextButton => 'Next';

  @override
  String get backButton => 'Back';

  @override
  String get createAccountButton => 'Create account';

  @override
  String get alreadyHaveAccountPrompt => 'Already have an account?';

  @override
  String get loginLink => 'Login';

  @override
  String get verifyEmailTitle => 'Verify your email';

  @override
  String verifyEmailSubtitle(String email) {
    return 'Enter the code sent to $email';
  }

  @override
  String get verificationCodeLabel => 'Verification code';

  @override
  String get verifyButton => 'Verify';

  @override
  String get resendCodePrompt => 'Didn\'t receive the code?';

  @override
  String get resendCodeButton => 'Resend code';

  @override
  String get emailVerifiedMessage => 'Email verified. You can now log in.';

  @override
  String get forgotPasswordTitle => 'Forgot password';

  @override
  String get forgotPasswordSubtitle =>
      'Enter your email and we\'ll send you a code to reset your password';

  @override
  String get sendCodeButton => 'Send code';

  @override
  String get resetPasswordTitle => 'Reset password';

  @override
  String resetPasswordSubtitle(String email) {
    return 'Enter the code sent to $email and choose a new password';
  }

  @override
  String get newPasswordLabel => 'New password';

  @override
  String get resetPasswordButton => 'Reset password';

  @override
  String get passwordResetSuccessMessage =>
      'Password reset. You can now log in.';

  @override
  String get fieldRequiredError => 'This field is required';

  @override
  String get invalidEmailError => 'Enter a valid email address';

  @override
  String get passwordTooShortError => 'Password must be at least 8 characters';

  @override
  String get passwordsDoNotMatchError => 'Passwords do not match';
}
