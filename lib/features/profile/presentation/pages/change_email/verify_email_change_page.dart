import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/app_config.dart';
import '../../../../../core/di/service_locator.dart';
import '../../../../../core/extensions/context_extensions.dart';
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
import '../../cubit/change_email/verify_email_change_cubit.dart';
import '../../cubit/change_email/verify_email_change_state.dart';

class VerifyEmailChangePage extends StatelessWidget {
  const VerifyEmailChangePage({super.key, required this.newEmail});

  final String newEmail;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<VerifyEmailChangeCubit>(),
      child: _VerifyEmailChangeView(newEmail: newEmail),
    );
  }
}

class _VerifyEmailChangeView extends StatefulWidget {
  const _VerifyEmailChangeView({required this.newEmail});

  final String newEmail;

  @override
  State<_VerifyEmailChangeView> createState() => _VerifyEmailChangeViewState();
}

class _VerifyEmailChangeViewState extends State<_VerifyEmailChangeView> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<VerifyEmailChangeCubit>().verify(_codeController.text.trim());
  }

  void _onStateChanged(BuildContext context, VerifyEmailChangeState state) {
    if (state.status == FormStatus.success) {
      AppToast.success(context, context.l10n.changeEmailSuccessMessage);
      context.pop(true);
    } else if (state.status == FormStatus.failure && state.errorMessage != null) {
      AppToast.error(context, state.errorMessage!);
    } else if (state.resendFailed && state.resendMessage != null) {
      AppToast.error(context, state.resendMessage!);
    } else if (!state.resendFailed && state.resendCount > 0) {
      AppToast.info(context, context.l10n.codeResentMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VerifyEmailChangeCubit, VerifyEmailChangeState>(
      listenWhen: (previous, current) =>
          previous.status != current.status || previous.resendCount != current.resendCount,
      listener: _onStateChanged,
      child: BlocBuilder<VerifyEmailChangeCubit, VerifyEmailChangeState>(
        builder: (context, state) {
          return AppLoadingOverlay(
            isLoading: state.status == FormStatus.submitting,
            child: Scaffold(
              appBar: AppAppBar(
                title: context.l10n.changeEmailTitle,
                onBack: () => context.pop(),
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
                                  title: context.l10n.verifyEmailChangeTitle,
                                  subtitle: context.l10n.verifyResetCodeSubtitle(widget.newEmail),
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
                                    onPressed: () =>
                                        context.read<VerifyEmailChangeCubit>().resend(),
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
