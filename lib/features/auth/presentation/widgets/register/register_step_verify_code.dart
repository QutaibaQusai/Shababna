import 'package:flutter/material.dart';

import '../../../../../core/config/app_config.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/shared/widgets/app_cooldown_timer.dart';
import '../../../../../core/shared/widgets/app_otp_field.dart';
import '../../../../../core/shared/widgets/app_page_header.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/validators/app_validators.dart';
import '../../../domain/verification_channel.dart';

class RegisterStepVerifyCode extends StatelessWidget {
  const RegisterStepVerifyCode({
    super.key,
    required this.formKey,
    required this.codeController,
    required this.channel,
    required this.destination,
    required this.onCompleted,
    required this.onResend,
  });

  static const _leftToRightIsolate = '\u2066';
  static const _popDirectionalIsolate = '\u2069';

  final GlobalKey<FormState> formKey;
  final TextEditingController codeController;
  final VerificationChannel channel;
  final String destination;
  final VoidCallback onCompleted;
  final VoidCallback onResend;

  @override
  Widget build(BuildContext context) {
    final isPhone = channel == VerificationChannel.phone;
    final shownDestination = isPhone
        ? '$_leftToRightIsolate$destination$_popDirectionalIsolate'
        : destination;

    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppPageHeader(
              title: isPhone ? context.l10n.verifyPhoneTitle : context.l10n.verifyEmailTitle,
              subtitle: context.l10n.verifyEmailSubtitle(shownDestination),
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
              child: AppCooldownTimer(label: context.l10n.resendCodeButton, onPressed: onResend),
            ),
          ],
        ),
      ),
    );
  }
}
