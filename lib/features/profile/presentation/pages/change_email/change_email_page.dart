import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/shared/widgets/app_app_bar.dart';
import '../../../../../core/shared/widgets/app_button.dart';
import '../../../../../core/shared/widgets/app_loading_overlay.dart';
import '../../../../../core/shared/widgets/app_page_header.dart';
import '../../../../../core/shared/widgets/app_text_field.dart';
import '../../../../../core/shared/widgets/app_toast.dart';
import '../../../../../core/state/form_status.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/validators/app_validators.dart';
import '../../cubit/change_email/change_email_cubit.dart';
import '../../cubit/change_email/change_email_state.dart';

class ChangeEmailPage extends StatelessWidget {
  const ChangeEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ChangeEmailCubit>(),
      child: const _ChangeEmailView(),
    );
  }
}

class _ChangeEmailView extends StatefulWidget {
  const _ChangeEmailView();

  @override
  State<_ChangeEmailView> createState() => _ChangeEmailViewState();
}

class _ChangeEmailViewState extends State<_ChangeEmailView> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newEmailController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newEmailController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<ChangeEmailCubit>().submit(
          currentPassword: _currentPasswordController.text,
          newEmail: _newEmailController.text.trim(),
        );
  }

  Future<void> _onStateChanged(BuildContext context, ChangeEmailState state) async {
    if (state.status != FormStatus.success) {
      if (state.status == FormStatus.failure) {
        AppToast.error(context, state.errorMessage ?? context.l10n.somethingWentWrong);
      }
      return;
    }

    if (!state.verificationRequired) {
      AppToast.success(context, context.l10n.changeEmailSuccessMessage);
      context.pop(true);
      return;
    }

    final verified = await context.push<bool>(
      AppRoutes.verifyEmailChange,
      extra: state.newEmail,
    );
    if (verified == true && context.mounted) context.pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChangeEmailCubit, ChangeEmailState>(
      listener: _onStateChanged,
      child: BlocBuilder<ChangeEmailCubit, ChangeEmailState>(
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
                                  title: context.l10n.changeEmailTitle,
                                  subtitle: context.l10n.changeEmailSubtitle,
                                ),
                                SizedBox(height: AppSpacing.md),
                                AppTextField(
                                  label: context.l10n.currentPasswordLabel,
                                  controller: _currentPasswordController,
                                  obscureText: true,
                                  prefixIcon: LucideIcons.lock,
                                  textInputAction: TextInputAction.next,
                                  autofocus: true,
                                  validator: AppValidators.required(context.l10n.fieldRequiredError),
                                ),
                                SizedBox(height: AppSpacing.sm),
                                AppTextField(
                                  label: context.l10n.newEmailLabel,
                                  controller: _newEmailController,
                                  keyboardType: TextInputType.emailAddress,
                                  prefixIcon: LucideIcons.mail,
                                  textInputAction: TextInputAction.done,
                                  validator: AppValidators.combine([
                                    AppValidators.required(context.l10n.fieldRequiredError),
                                    AppValidators.email(context.l10n.invalidEmailError),
                                  ]),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: AppSpacing.sm),
                      AppButton.primary(
                        label: context.l10n.confirmButton,
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
