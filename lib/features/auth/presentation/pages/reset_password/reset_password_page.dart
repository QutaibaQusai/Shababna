import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/state/form_status.dart';
import '../../../../../core/validators/app_validators.dart';
import '../../../../../core/shared/widgets/app_app_bar.dart';
import '../../../../../core/shared/widgets/app_button.dart';
import '../../../../../core/shared/widgets/app_loading_overlay.dart';
import '../../../../../core/shared/widgets/app_text_field.dart';
import '../../../../../core/shared/widgets/app_toast.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../cubit/reset_password/reset_password_cubit.dart';
import '../../cubit/reset_password/reset_password_state.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ResetPasswordCubit>(),
      child: _ResetPasswordView(email: email),
    );
  }
}

class _ResetPasswordView extends StatefulWidget {
  const _ResetPasswordView({required this.email});

  final String email;

  @override
  State<_ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<_ResetPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<ResetPasswordCubit>().submit(
          email: widget.email,
          code: _codeController.text.trim(),
          newPassword: _newPasswordController.text,
          confirmPassword: _confirmPasswordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ResetPasswordCubit, ResetPasswordState>(
      listener: (context, state) {
        if (state.status == FormStatus.success) {
          AppToast.success(context, context.l10n.passwordResetSuccessMessage);
          context.go(AppRoutes.login);
        } else if (state.status == FormStatus.failure && state.errorMessage != null) {
          AppToast.error(context, state.errorMessage!);
        }
      },
      child: BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
        builder: (context, state) {
          return AppLoadingOverlay(
            isLoading: state.status == FormStatus.submitting,
            child: Scaffold(
              appBar: AppAppBar(
                title: context.l10n.resetPasswordTitle,
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
                                Text(
                                  context.l10n.resetPasswordSubtitle(widget.email),
                                  style: context.textTheme.bodyMedium,
                                ),
                                SizedBox(height: AppSpacing.md),
                                AppTextField(
                                  label: context.l10n.verificationCodeLabel,
                                  controller: _codeController,
                                  keyboardType: TextInputType.number,
                                  prefixIcon: LucideIcons.shieldCheck,
                                  textInputAction: TextInputAction.next,
                                  autofocus: true,
                                  validator: AppValidators.required(context.l10n.fieldRequiredError),
                                ),
                                SizedBox(height: AppSpacing.sm),
                                AppTextField(
                                  label: context.l10n.newPasswordLabel,
                                  controller: _newPasswordController,
                                  obscureText: true,
                                  prefixIcon: LucideIcons.lock,
                                  textInputAction: TextInputAction.next,
                                  validator: AppValidators.combine([
                                    AppValidators.required(context.l10n.fieldRequiredError),
                                    AppValidators.minLength(8, context.l10n.passwordTooShortError),
                                  ]),
                                ),
                                SizedBox(height: AppSpacing.sm),
                                AppTextField(
                                  label: context.l10n.confirmPasswordLabel,
                                  controller: _confirmPasswordController,
                                  obscureText: true,
                                  prefixIcon: LucideIcons.lock,
                                  textInputAction: TextInputAction.done,
                                  validator: AppValidators.combine([
                                    AppValidators.required(context.l10n.fieldRequiredError),
                                    AppValidators.match(
                                      () => _newPasswordController.text,
                                      context.l10n.passwordsDoNotMatchError,
                                    ),
                                  ]),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: AppSpacing.sm),
                      AppButton.primary(
                        label: context.l10n.resetPasswordButton,
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
