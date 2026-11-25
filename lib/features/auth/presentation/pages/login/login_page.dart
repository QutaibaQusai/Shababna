import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/config/app_assets.dart';
import '../../../../../core/di/service_locator.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/session/auth_session_cubit.dart';
import '../../../../../core/shared/widgets/app_app_bar.dart';
import '../../../../../core/shared/widgets/app_button.dart';
import '../../../../../core/shared/widgets/app_loading_overlay.dart';
import '../../../../../core/shared/widgets/app_text_field.dart';
import '../../../../../core/shared/widgets/app_toast.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/validators/app_validators.dart';
import '../../../domain/auth_identifier.dart';
import '../../../domain/login_verification.dart';
import '../../cubit/login/login_cubit.dart';
import '../../cubit/login/login_state.dart';
import '../../cubit/phone_codes/phone_codes_cubit.dart';
import '../../widgets/login/sign_in/login_identifier_field.dart';
import '../../../../../core/shared/widgets/app_bottom_safe_area.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key, this.isModal = false});

  final bool isModal;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<LoginCubit>()),
        BlocProvider.value(value: sl<PhoneCodesCubit>()..ensureLoaded()),
      ],
      child: _LoginView(isModal: isModal),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView({required this.isModal});

  final bool isModal;

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final identifier = AuthIdentifier.tryParse(
      _identifierController.text,
      callingCode: context.read<PhoneCodesCubit>().state.selected?.callingCode,
    );
    if (identifier == null) return;
    context.read<LoginCubit>().login(identifier: identifier, password: _passwordController.text);
  }

  Future<void> _continueAsGuest() async {
    final session = context.read<AuthSessionCubit>();
    if (session.state.isGuest && context.canPop()) {
      context.pop();
      return;
    }
    await session.continueAsGuest();
    if (mounted) context.go(AppRoutes.home);
  }

  Future<void> _openVerification(PendingVerification pending, String? message) async {
    if (message != null) AppToast.info(context, message);
    final loginCubit = context.read<LoginCubit>();
    final verified = await context.push<bool>(AppRoutes.loginVerification, extra: pending);
    if (verified ?? false) loginCubit.completeSignIn();
  }

  void _onLoginStateChanged(BuildContext context, LoginState state) {
    switch (state.status) {
      case LoginStatus.failure:
        final message = state.message;
        if (message != null) AppToast.error(context, message);
      case LoginStatus.needsVerification:
        final pending = state.pending;
        if (pending != null) _openVerification(pending, state.message);
      case LoginStatus.success:
        if (widget.isModal && context.canPop()) context.pop();
      case LoginStatus.initial || LoginStatus.submitting:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: _onLoginStateChanged,
      builder: (context, state) {
        return AppLoadingOverlay(
          isLoading: state.status == LoginStatus.submitting,
          child: Scaffold(
            appBar: widget.isModal
                ? AppAppBar(title: '', leadingIcon: LucideIcons.x, onBack: () => context.pop())
                : null,
            body: AppBottomSafeArea(top: true, child: _buildForm(context)),
          ),
        );
      },
    );
  }

  Widget _buildForm(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.screenMargin),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: AppSpacing.lg),
            Center(
              child: ClipRRect(
                borderRadius: AppRadius.mdRadius,
                child: Image.asset(
                  AppAssets.loginLogo,
                  width: AppSizes.loginLogoSize,
                  height: AppSizes.loginLogoSize,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: AppSpacing.md),
            Text(
              context.l10n.loginTitle,
              textAlign: TextAlign.center,
              style: context.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: AppSpacing.xs),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Text(
                context.l10n.loginSubtitle,
                textAlign: TextAlign.center,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            SizedBox(height: AppSpacing.xl),
            LoginIdentifierField(controller: _identifierController),
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
            AppButton.primary(label: context.l10n.loginButton, onPressed: _submit),
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
            AppButton.text(label: context.l10n.continueAsGuestButton, onPressed: _continueAsGuest),
          ],
        ),
      ),
    );
  }
}
