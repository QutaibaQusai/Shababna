import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/config/app_assets.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/state/form_status.dart';
import '../../../../core/validators/app_validators.dart';
import '../../../../core/shared/widgets/app_button.dart';
import '../../../../core/shared/widgets/app_loading_overlay.dart';
import '../../../../core/shared/widgets/app_text_field.dart';
import '../../../../core/theme/app_spacing.dart';
import '../cubit/login_cubit.dart';
import '../cubit/login_state.dart';
import '../widgets/auth_error_banner.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LoginCubit>(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<LoginCubit>().login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<LoginCubit, LoginState>(
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
                      SizedBox(height: AppSpacing.xl),
                      Image.asset(AppAssets.illustrationSignIn, height: 180),
                      SizedBox(height: AppSpacing.lg),
                      Text(
                        context.l10n.loginTitle,
                        textAlign: TextAlign.center,
                        style: context.textTheme.displaySmall,
                      ),
                      SizedBox(height: AppSpacing.xs),
                      Text(
                        context.l10n.loginSubtitle,
                        textAlign: TextAlign.center,
                        style: context.textTheme.bodyMedium,
                      ),
                      SizedBox(height: AppSpacing.lg),
                      AuthErrorBanner(message: state.errorMessage),
                      AppTextField(
                        label: context.l10n.emailLabel,
                        hint: context.l10n.emailHint,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: LucideIcons.mail,
                        textInputAction: TextInputAction.next,
                        validator: AppValidators.combine([
                          AppValidators.required(context.l10n.fieldRequiredError),
                          AppValidators.email(context.l10n.invalidEmailError),
                        ]),
                      ),
                      SizedBox(height: AppSpacing.sm),
                      AppTextField(
                        label: context.l10n.passwordLabel,
                        controller: _passwordController,
                        obscureText: true,
                        prefixIcon: LucideIcons.lock,
                        textInputAction: TextInputAction.done,
                        validator: AppValidators.required(context.l10n.fieldRequiredError),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: AppButton.text(
                          label: context.l10n.forgotPasswordLink,
                          onPressed: () => context.push(AppRoutes.forgotPassword),
                        ),
                      ),
                      SizedBox(height: AppSpacing.xs),
                      AppButton.primary(
                        label: context.l10n.loginButton,
                        onPressed: _submit,
                      ),
                      SizedBox(height: AppSpacing.sm),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(context.l10n.noAccountPrompt),
                          AppButton.text(
                            label: context.l10n.registerLink,
                            onPressed: () => context.push(AppRoutes.register),
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
    );
  }
}
