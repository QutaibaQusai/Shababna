import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/app_config.dart';
import '../../../../../core/di/service_locator.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/shared/widgets/app_app_bar.dart';
import '../../../../../core/shared/widgets/app_button.dart';
import '../../../../../core/shared/widgets/app_cooldown_timer.dart';
import '../../../../../core/shared/widgets/app_loading_overlay.dart';
import '../../../../../core/shared/widgets/app_otp_field.dart';
import '../../../../../core/shared/widgets/app_page_header.dart';
import '../../../../../core/shared/widgets/app_toast.dart';
import '../../../../../core/state/form_status.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/validators/app_validators.dart';
import '../../cubit/verify_reset_code/verify_reset_code_cubit.dart';
import '../../cubit/verify_reset_code/verify_reset_code_state.dart';
import '../reset_password/reset_password_args.dart';

class VerifyResetCodePage extends StatelessWidget {
  const VerifyResetCodePage({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<VerifyResetCodeCubit>(),
      child: _VerifyResetCodeView(email: email),
    );
  }
}

class _VerifyResetCodeView extends StatefulWidget {
  const _VerifyResetCodeView({required this.email});

  final String email;

  @override
  State<_VerifyResetCodeView> createState() => _VerifyResetCodeViewState();
}

class _VerifyResetCodeViewState extends State<_VerifyResetCodeView> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<VerifyResetCodeCubit>().verify(
          email: widget.email,
          code: _codeController.text.trim(),
        );
  }

  void _onStateChanged(BuildContext context, VerifyResetCodeState state) {
    if (state.status == FormStatus.success && state.resetToken != null) {
      context.go(
        AppRoutes.resetPassword,
        extra: ResetPasswordArgs(email: widget.email, resetToken: state.resetToken!),
      );
    } else if (state.status == FormStatus.failure && state.errorMessage != null) {
      AppToast.error(context, state.errorMessage!);
    } else if (state.resendMessage != null) {
      if (state.resendFailed) {
        AppToast.error(context, state.resendMessage!);
      } else {
        AppToast.info(context, state.resendMessage!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VerifyResetCodeCubit, VerifyResetCodeState>(
      listenWhen: (previous, current) =>
          previous.status != current.status ||
          previous.resendMessage != current.resendMessage,
      listener: _onStateChanged,
      child: BlocBuilder<VerifyResetCodeCubit, VerifyResetCodeState>(
        builder: (context, state) {
          return AppLoadingOverlay(
            isLoading: state.status == FormStatus.submitting,
            child: Scaffold(
              appBar: AppAppBar(
                title: context.l10n.accountRecoveryTitle,
                onBack: () => context.go(AppRoutes.forgotPassword),
              ),
              body: SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.screenMargin),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                AppPageHeader(
                                  title: context.l10n.verifyResetCodeTitle,
                                  subtitle: context.l10n.verifyResetCodeSubtitle(widget.email),
                                ),
                                SizedBox(height: AppSpacing.md),
                                AppOtpField(
                                  controller: _codeController,
                                  autofocus: true,
                                  onCompleted: (_) => _submit(),
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
                                    onPressed: () => context
                                        .read<VerifyResetCodeCubit>()
                                        .resend(email: widget.email),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: AppSpacing.sm),
                      AppButton.primary(
                        label: context.l10n.verifyButton,
                        onPressed: _submit,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
