import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/state/form_status.dart';
import '../../../../core/validators/app_validators.dart';
import '../../../../core/shared/widgets/app_button.dart';
import '../../../../core/shared/widgets/app_loading_overlay.dart';
import '../../../../core/shared/widgets/app_text_field.dart';
import '../../../../core/theme/app_spacing.dart';
import '../cubit/verify_email_cubit.dart';
import '../cubit/verify_email_state.dart';
import '../widgets/auth_error_banner.dart';

class VerifyEmailPage extends StatelessWidget {
  const VerifyEmailPage({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<VerifyEmailCubit>(),
      child: _VerifyEmailView(email: email),
    );
  }
}

class _VerifyEmailView extends StatefulWidget {
  const _VerifyEmailView({required this.email});

  final String email;

  @override
  State<_VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<_VerifyEmailView> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<VerifyEmailCubit>().verify(
          email: widget.email,
          code: _codeController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VerifyEmailCubit, VerifyEmailState>(
      listenWhen: (previous, current) =>
          previous.status != current.status || previous.resendMessage != current.resendMessage,
      listener: (context, state) {
        if (state.status == FormStatus.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.emailVerifiedMessage)),
          );
          context.go(AppRoutes.login);
        } else if (state.resendMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.resendMessage!)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(context.l10n.verifyEmailTitle)),
        body: SafeArea(
          child: BlocBuilder<VerifyEmailCubit, VerifyEmailState>(
            builder: (context, state) {
              return AppLoadingOverlay(
                isLoading: state.status == FormStatus.submitting,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(AppSpacing.screenMargin),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          context.l10n.verifyEmailSubtitle(widget.email),
                          style: context.textTheme.bodyMedium,
                        ),
                        SizedBox(height: AppSpacing.md),
                        AuthErrorBanner(message: state.errorMessage),
                        AppTextField(
                          label: context.l10n.verificationCodeLabel,
                          controller: _codeController,
                          keyboardType: TextInputType.number,
                          prefixIcon: LucideIcons.shieldCheck,
                          textInputAction: TextInputAction.done,
                          validator: AppValidators.required(context.l10n.fieldRequiredError),
                        ),
                        SizedBox(height: AppSpacing.sm),
                        AppButton.primary(
                          label: context.l10n.verifyButton,
                          onPressed: _submit,
                        ),
                        SizedBox(height: AppSpacing.sm),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(context.l10n.resendCodePrompt),
                            AppButton.text(
                              label: context.l10n.resendCodeButton,
                              onPressed: state.isResending
                                  ? null
                                  : () => context
                                      .read<VerifyEmailCubit>()
                                      .resend(email: widget.email),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
