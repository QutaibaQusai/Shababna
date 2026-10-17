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
import '../../cubit/profile/profile_cubit.dart';
import '../../../../../core/shared/widgets/app_bottom_safe_area.dart';

class VerifyEmailChangePage extends StatelessWidget {
  const VerifyEmailChangePage({super.key, required this.newEmail});

  final String newEmail;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sl<ProfileCubit>()),
        BlocProvider(create: (_) => sl<VerifyEmailChangeCubit>(param1: newEmail)),
      ],
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
  void initState() {
    super.initState();
    _codeController.addListener(_onCodeChanged);
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _onCodeChanged() => setState(() {});

  bool get _isCodeComplete => _codeController.text.trim().length == AppConfig.otpLength;

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<VerifyEmailChangeCubit>().verify(_codeController.text.trim());
  }

  void _onStatusChanged(BuildContext context, VerifyEmailChangeState state) {
    if (state.status == FormStatus.success) {
      AppToast.success(context, context.l10n.changeEmailSuccessMessage);
      context.pop(true);
    } else if (state.status == FormStatus.failure) {
      AppToast.error(context, state.errorMessage ?? context.l10n.somethingWentWrong);
    }
  }

  void _onResendChanged(BuildContext context, VerifyEmailChangeState state) {
    if (state.resendStatus == FormStatus.success) {
      AppToast.info(context, context.l10n.profileEmailCodeResentMessage);
    } else if (state.resendStatus == FormStatus.failure) {
      AppToast.error(context, state.resendError ?? context.l10n.somethingWentWrong);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<VerifyEmailChangeCubit, VerifyEmailChangeState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: _onStatusChanged,
        ),
        BlocListener<VerifyEmailChangeCubit, VerifyEmailChangeState>(
          listenWhen: (previous, current) => previous.resendStatus != current.resendStatus,
          listener: _onResendChanged,
        ),
      ],
      child: BlocBuilder<VerifyEmailChangeCubit, VerifyEmailChangeState>(
        builder: (context, state) {
          return AppLoadingOverlay(
            isLoading: state.isSubmitting,
            child: Scaffold(
              appBar: AppAppBar(
                title: context.l10n.verifyEmailChangeTitle,
                onBack: () => context.pop(),
              ),
              body: AppBottomSafeArea(
                top: true,
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
                                  subtitle:
                                      context.l10n.profileVerifyEmailSubtitle(widget.newEmail),
                                ),
                                SizedBox(height: AppSpacing.lg),
                                AppOtpField(
                                  controller: _codeController,
                                  autofocus: true,
                                  onCompleted: (_) => _submit(),
                                  validator: AppValidators.exactLength(
                                    AppConfig.otpLength,
                                    context.l10n.profileInvalidEmailCodeError(AppConfig.otpLength),
                                  ),
                                ),
                                SizedBox(height: AppSpacing.md),
                                Center(
                                  child: Text(
                                    context.l10n.profileResendEmailPrompt,
                                    style: context.textTheme.bodyMedium?.copyWith(
                                      color: context.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                                Center(
                                  child: AppCooldownTimer(
                                    label: context.l10n.profileResendEmailButton,
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
                        label: context.l10n.profileVerifyEmailButton,
                        onPressed: _isCodeComplete && !state.isSubmitting ? _submit : null,
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
