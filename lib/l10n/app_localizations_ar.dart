// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'شبابنا';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get somethingWentWrong => 'حدث خطأ ما';

  @override
  String get noItemsFound => 'لا توجد عناصر';

  @override
  String get loginTitle => 'أهلاً بعودتك';

  @override
  String get loginSubtitle => 'سجّل الدخول للمتابعة';

  @override
  String get emailLabel => 'البريد الإلكتروني';

  @override
  String get emailHint => 'example@email.com';

  @override
  String get passwordLabel => 'كلمة المرور';

  @override
  String get loginButton => 'تسجيل الدخول';

  @override
  String get forgotPasswordLink => 'نسيت كلمة المرور؟';

  @override
  String get noAccountPrompt => 'ليس لديك حساب؟';

  @override
  String get registerLink => 'إنشاء حساب';

  @override
  String get registerTitle => 'إنشاء حساب';

  @override
  String get stepNameTitle => 'اسمك';

  @override
  String get fullNameArLabel => 'الاسم الكامل (بالعربية)';

  @override
  String get fullNameEnLabel => 'الاسم الكامل (بالإنجليزية)';

  @override
  String get stepContactTitle => 'بيانات التواصل';

  @override
  String get phoneNumberLabel => 'رقم الهاتف';

  @override
  String get stepPasswordTitle => 'تعيين كلمة المرور';

  @override
  String get confirmPasswordLabel => 'تأكيد كلمة المرور';

  @override
  String get nextButton => 'التالي';

  @override
  String get backButton => 'رجوع';

  @override
  String get createAccountButton => 'إنشاء الحساب';

  @override
  String get alreadyHaveAccountPrompt => 'لديك حساب بالفعل؟';

  @override
  String get loginLink => 'تسجيل الدخول';

  @override
  String get verifyEmailTitle => 'تأكيد البريد الإلكتروني';

  @override
  String verifyEmailSubtitle(String email) {
    return 'أدخل الرمز المُرسل إلى $email';
  }

  @override
  String get verificationCodeLabel => 'رمز التحقق';

  @override
  String get verifyButton => 'تأكيد';

  @override
  String get resendCodePrompt => 'لم يصلك الرمز؟';

  @override
  String get resendCodeButton => 'إعادة إرسال الرمز';

  @override
  String get emailVerifiedMessage =>
      'تم تأكيد البريد الإلكتروني. يمكنك تسجيل الدخول الآن.';

  @override
  String get forgotPasswordTitle => 'نسيت كلمة المرور';

  @override
  String get forgotPasswordSubtitle =>
      'أدخل بريدك الإلكتروني وسنرسل لك رمزاً لإعادة تعيين كلمة المرور';

  @override
  String get sendCodeButton => 'إرسال الرمز';

  @override
  String get resetPasswordTitle => 'إعادة تعيين كلمة المرور';

  @override
  String resetPasswordSubtitle(String email) {
    return 'أدخل الرمز المُرسل إلى $email واختر كلمة مرور جديدة';
  }

  @override
  String get newPasswordLabel => 'كلمة المرور الجديدة';

  @override
  String get resetPasswordButton => 'إعادة تعيين كلمة المرور';

  @override
  String get passwordResetSuccessMessage =>
      'تم إعادة تعيين كلمة المرور. يمكنك تسجيل الدخول الآن.';

  @override
  String get fieldRequiredError => 'هذا الحقل مطلوب';

  @override
  String get invalidEmailError => 'أدخل بريداً إلكترونياً صحيحاً';

  @override
  String get passwordTooShortError =>
      'يجب أن تتكون كلمة المرور من 8 أحرف على الأقل';

  @override
  String get passwordsDoNotMatchError => 'كلمتا المرور غير متطابقتين';

  @override
  String get invalidPhoneNumberError => 'أدخل رقم هاتف صحيح';

  @override
  String get selectCountryTitle => 'اختر الدولة';

  @override
  String get searchCountryHint => 'ابحث عن الدولة أو الرمز';
}
