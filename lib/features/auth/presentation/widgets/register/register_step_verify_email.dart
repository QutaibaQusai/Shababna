import 'package:flutter/material.dart';

import '../../../../../core/config/app_config.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/shared/widgets/app_cooldown_timer.dart';
import '../../../../../core/shared/widgets/app_otp_field.dart';
import '../../../../../core/shared/widgets/app_page_header.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/validators/app_validators.dart';

class RegisterStepVerifyEmail extends StatelessWidget {
  const RegisterStepVerifyEmail({
    super.key,
    required this.formKey,
    required this.codeController,
    required this.email,
    required this.onCompleted,
    required this.onResend,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController codeController;
  final String email;
  final VoidCallback onCompleted;
  final VoidCallback onResend;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppPageHeader(
              title: context.l10n.verifyEmailTitle,
              subtitle: context.l10n.verifyEmailSubtitle(email),
            ),
            SizedBox(height: AppSpacing.md),
            AppOtpField(
              controller: codeController,
              autofocus: true,
              onCompleted: (_) => onCompleted(),
              validator: AppValidators.exactLength(
                AppConfig.otpLength,
                context.l10n.invalidCodeError(AppConfig.otpLength),
              ),
            ),
            SizedBox(height: AppSpacing.md),
            Center(child: Text(context.l10n.resendCodePrompt)),
            Center(
              child: AppCooldownTimer(
                label: context.l10n.resendCodeButton,
                onPressed: onResend,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
