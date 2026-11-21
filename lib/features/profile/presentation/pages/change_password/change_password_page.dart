import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/shared/widgets/app_app_bar.dart';
import '../../../../../core/shared/widgets/app_button.dart';
import '../../../../../core/shared/widgets/app_error_box.dart';
import '../../../../../core/shared/widgets/app_loading_overlay.dart';
import '../../../../../core/shared/widgets/app_page_header.dart';
import '../../../../../core/shared/widgets/app_text_field.dart';
import '../../../../../core/shared/widgets/app_toast.dart';
import '../../../../../core/state/form_status.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/validators/app_validators.dart';
import '../../cubit/change_password/change_password_cubit.dart';
import '../../cubit/change_password/change_password_state.dart';
import '../../../../../core/shared/widgets/app_bottom_safe_area.dart';

class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ChangePasswordCubit>(),
      child: const _ChangePasswordView(),
    );
  }
}

class _ChangePasswordView extends StatefulWidget {
  const _ChangePasswordView();

  @override
  State<_ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<_ChangePasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<ChangePasswordCubit>().submit(
          currentPassword: _currentPasswordController.text,
          newPassword: _newPasswordController.text,
          confirmPassword: _confirmPasswordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChangePasswordCubit, ChangePasswordState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == FormStatus.success) {
          AppToast.success(context, context.l10n.changePasswordSuccessMessage);
          context.pop();
        }
      },
      child: BlocBuilder<ChangePasswordCubit, ChangePasswordState>(
        builder: (context, state) {
          return AppLoadingOverlay(
            isLoading: state.status == FormStatus.submitting,
            child: Scaffold(
              appBar: AppAppBar(
                title: context.l10n.changePasswordTitle,
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
                                  title: context.l10n.changePasswordTitle,
                                  subtitle: context.l10n.changePasswordSubtitle,
                                ),
                                SizedBox(height: AppSpacing.md),
                                AppTextField(
                                  label: context.l10n.currentPasswordLabel,
                                  controller: _currentPasswordController,
                                  obscureText: true,
                                  prefixIcon: LucideIcons.lock,
                                  textInputAction: TextInputAction.next,
                                  autofocus: true,
                                  onChanged: (_) => context.read<ChangePasswordCubit>().clearError(),
                                  validator: AppValidators.required(context.l10n.fieldRequiredError),
                                ),
                                SizedBox(height: AppSpacing.sm),
                                AppTextField(
                                  label: context.l10n.newPasswordLabel,
                                  controller: _newPasswordController,
                                  obscureText: true,
                                  prefixIcon: LucideIcons.lock,
                                  textInputAction: TextInputAction.next,
                                  onChanged: (_) => context.read<ChangePasswordCubit>().clearError(),
                                  validator: AppValidators.required(context.l10n.fieldRequiredError),
                                ),
                                SizedBox(height: AppSpacing.sm),
                                AppTextField(
                                  label: context.l10n.confirmPasswordLabel,
                                  controller: _confirmPasswordController,
                                  obscureText: true,
                                  prefixIcon: LucideIcons.lock,
                                  textInputAction: TextInputAction.done,
                                  onChanged: (_) => context.read<ChangePasswordCubit>().clearError(),
                                  validator: AppValidators.combine([
                                    AppValidators.required(context.l10n.fieldRequiredError),
                                    AppValidators.match(
                                      () => _newPasswordController.text,
                                      context.l10n.passwordsDoNotMatchError,
                                    ),
                                  ]),
                                ),
                                if (state.status == FormStatus.failure) ...[
                                  SizedBox(height: AppSpacing.sm),
                                  AppErrorBox(
                                    message: state.errorMessage ?? context.l10n.somethingWentWrong,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: AppSpacing.sm),
                      AppButton.primary(
                        label: context.l10n.changePasswordButton,
                        onPressed: () => _submit(context),
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
