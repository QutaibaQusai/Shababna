import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/config/app_config.dart';
import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../core/shared/widgets/app_button.dart';
import '../../../../../../core/shared/widgets/app_cooldown_timer.dart';
import '../../../../../../core/shared/widgets/app_otp_field.dart';
import '../../../../../../core/shared/widgets/app_page_header.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/validators/app_validators.dart';
import '../../../../domain/verification_channel.dart';
import '../../../cubit/login_verification/login_verification_cubit.dart';
import '../../../cubit/login_verification/login_verification_state.dart';

class LoginVerificationForm extends StatefulWidget {
  const LoginVerificationForm({super.key});

  @override
  State<LoginVerificationForm> createState() => _LoginVerificationFormState();
}

class _LoginVerificationFormState extends State<LoginVerificationForm> {
  static const _leftToRightIsolate = '\u2066';
  static const _popDirectionalIsolate = '\u2069';

  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<LoginVerificationCubit>().verify(_codeController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocConsumer<LoginVerificationCubit, LoginVerificationState>(
      listenWhen: (previous, current) => current.errorMessage != null,
      listener: (_, _) => _codeController.clear(),
      builder: (context, state) {
        final isPhone = state.channel == VerificationChannel.phone;
        final destination = '$_leftToRightIsolate${state.destination}$_popDirectionalIsolate';

        return SingleChildScrollView(
          padding: EdgeInsets.all(AppSpacing.screenMargin),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppPageHeader(
                  title: isPhone ? l10n.verifyPhoneTitle : l10n.verifyEmailTitle,
                  subtitle: l10n.verifyEmailSubtitle(destination),
                ),
                SizedBox(height: AppSpacing.md),
                AppOtpField(
                  controller: _codeController,
                  autofocus: true,
                  onCompleted: (_) => _submit(),
                  validator: AppValidators.exactLength(
                    AppConfig.otpLength,
                    l10n.invalidCodeError(AppConfig.otpLength),
                  ),
                ),
                SizedBox(height: AppSpacing.md),
                AppButton.primary(label: l10n.verifyButton, onPressed: _submit),
                SizedBox(height: AppSpacing.sm),
                Center(child: Text(l10n.resendCodePrompt)),
                Center(
                  child: AppCooldownTimer(
                    key: ValueKey(state.cooldownVersion),
                    label: l10n.resendCodeButton,
                    cooldownSeconds: state.cooldownSeconds,
                    onPressed: context.read<LoginVerificationCubit>().resend,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
