import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/shared/widgets/app_app_bar.dart';
import '../../../../../core/shared/widgets/app_button.dart';
import '../../../../../core/shared/widgets/app_loading_overlay.dart';
import '../../../../../core/shared/widgets/app_toast.dart';
import '../../../../../core/state/form_status.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/phone_number.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../cubit/register/register_cubit.dart';
import '../../cubit/register/register_state.dart';
import '../../cubit/register/verify_email_cubit.dart';
import '../../cubit/register/verify_email_state.dart';
import '../../widgets/register/register_step_contact.dart';
import '../../widgets/register/register_step_indicator.dart';
import '../../widgets/register/register_step_name.dart';
import '../../widgets/register/register_step_password.dart';
import '../../widgets/register/register_step_verify_email.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<RegisterCubit>()..loadPhoneCodes()),
        BlocProvider(create: (_) => sl<VerifyEmailCubit>()),
      ],
      child: const _RegisterView(),
    );
  }
}

class _RegisterView extends StatefulWidget {
  const _RegisterView();

  @override
  State<_RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<_RegisterView> {
  static const _stepCount = 4;
  static const _passwordStep = 2;
  static const _verifyStep = 3;
  static const _defaultCountryCode = 'JO';
  static const _stepDuration = Duration(milliseconds: 250);

  final _pageController = PageController();
  final _stepFormKeys = List.generate(_stepCount, (_) => GlobalKey<FormState>());
  int _currentStep = 0;

  final _fullNameArController = TextEditingController();
  final _fullNameEnController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _otpController = TextEditingController();

  CountryPhoneCode? _selectedPhoneCode;

  @override
  void dispose() {
    _pageController.dispose();
    _fullNameArController.dispose();
    _fullNameEnController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _selectDefaultPhoneCodeIfNeeded(List<CountryPhoneCode> phoneCodes) {
    if (_selectedPhoneCode != null || phoneCodes.isEmpty) return;
    final defaultCode = phoneCodes.firstWhere(
      (code) => code.countryCode == _defaultCountryCode,
      orElse: () => phoneCodes.first,
    );
    setState(() => _selectedPhoneCode = defaultCode);
  }

  String _emailToVerify(RegisterState state) =>
      state.registeredEmail ?? _emailController.text.trim();

  void _advance() {
    setState(() => _currentStep++);
    _pageController.nextPage(duration: _stepDuration, curve: Curves.easeOut);
  }

  void _goNext() {
    if (!(_stepFormKeys[_currentStep].currentState?.validate() ?? false)) return;

    switch (_currentStep) {
      case _passwordStep:
        _register();
      case _verifyStep:
        _verifyEmail();
      default:
        _advance();
    }
  }

  void _register() {
    final phoneNumber = PhoneNumber.toE164(
      callingCode: _selectedPhoneCode!.callingCode,
      input: _phoneNumberController.text,
    );
    context.read<RegisterCubit>().submit(
          email: _emailController.text.trim(),
          phoneNumber: phoneNumber,
          fullNameEn: _fullNameEnController.text.trim(),
          fullNameAr: _fullNameArController.text.trim(),
          password: _passwordController.text,
          confirmPassword: _confirmPasswordController.text,
        );
  }

  void _verifyEmail() {
    context.read<VerifyEmailCubit>().verify(
          email: _emailToVerify(context.read<RegisterCubit>().state),
          code: _otpController.text.trim(),
        );
  }

  void _resendCode() {
    context.read<VerifyEmailCubit>().resend(
          email: _emailToVerify(context.read<RegisterCubit>().state),
        );
  }

  void _goBack() {
    if (_currentStep == 0 || _currentStep == _verifyStep) {
      context.go(AppRoutes.login);
      return;
    }
    setState(() => _currentStep--);
    _pageController.previousPage(duration: _stepDuration, curve: Curves.easeOut);
  }

  void _onRegisterStatusChanged(BuildContext context, RegisterState state) {
    if (state.status == FormStatus.success) {
      if (state.emailVerificationRequired) {
        _advance();
      } else {
        AppToast.success(context, context.l10n.registrationCompleteMessage);
        context.go(AppRoutes.login);
      }
    } else if (state.status == FormStatus.failure && state.errorMessage != null) {
      AppToast.error(context, state.errorMessage!);
    }
  }

  void _onVerifyStateChanged(BuildContext context, VerifyEmailState state) {
    if (state.status == FormStatus.success) {
      AppToast.success(context, context.l10n.emailVerifiedMessage);
      context.go(AppRoutes.login);
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

  String _primaryLabel(BuildContext context) => switch (_currentStep) {
        _passwordStep => context.l10n.createAccountButton,
        _verifyStep => context.l10n.verifyButton,
        _ => context.l10n.nextButton,
      };

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<RegisterCubit, RegisterState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: _onRegisterStatusChanged,
        ),
        BlocListener<RegisterCubit, RegisterState>(
          listenWhen: (previous, current) => previous.phoneCodes != current.phoneCodes,
          listener: (_, state) => _selectDefaultPhoneCodeIfNeeded(state.phoneCodes),
        ),
        BlocListener<VerifyEmailCubit, VerifyEmailState>(
          listenWhen: (previous, current) =>
              previous.status != current.status ||
              previous.resendMessage != current.resendMessage,
          listener: _onVerifyStateChanged,
        ),
      ],
      child: BlocBuilder<RegisterCubit, RegisterState>(
        builder: (context, state) {
          final isVerifying =
              context.watch<VerifyEmailCubit>().state.status == FormStatus.submitting;

          return AppLoadingOverlay(
            isLoading: state.status == FormStatus.submitting || isVerifying,
            child: Scaffold(
              appBar: AppAppBar(
                title: context.l10n.registerTitle,
                onBack: _goBack,
              ),
              body: SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.screenMargin),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RegisterStepIndicator(
                        currentStep: _currentStep,
                        stepCount: _stepCount,
                      ),
                      SizedBox(height: AppSpacing.sm),
                      Expanded(
                        child: PageView(
                          controller: _pageController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            RegisterStepName(
                              formKey: _stepFormKeys[0],
                              fullNameArController: _fullNameArController,
                              fullNameEnController: _fullNameEnController,
                            ),
                            RegisterStepContact(
                              formKey: _stepFormKeys[1],
                              emailController: _emailController,
                              phoneNumberController: _phoneNumberController,
                              phoneCodes: state.phoneCodes,
                              selectedPhoneCode: _selectedPhoneCode,
                              onPhoneCodeSelected: (code) =>
                                  setState(() => _selectedPhoneCode = code),
                              isLoadingPhoneCodes: state.isLoadingPhoneCodes,
                              phoneCodesError: state.phoneCodesError,
                              onRetryLoadPhoneCodes: () =>
                                  context.read<RegisterCubit>().loadPhoneCodes(),
                            ),
                            RegisterStepPassword(
                              formKey: _stepFormKeys[_passwordStep],
                              passwordController: _passwordController,
                              confirmPasswordController: _confirmPasswordController,
                            ),
                            RegisterStepVerifyEmail(
                              formKey: _stepFormKeys[_verifyStep],
                              codeController: _otpController,
                              email: _emailToVerify(state),
                              onCompleted: _goNext,
                              onResend: _resendCode,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: AppSpacing.sm),
                      AppButton.primary(
                        label: _primaryLabel(context),
                        onPressed: _goNext,
                      ),
                      if (_currentStep != _verifyStep)
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(context.l10n.alreadyHaveAccountPrompt),
                              AppButton.text(
                                label: context.l10n.loginLink,
                                onPressed: () => context.go(AppRoutes.login),
                              ),
                            ],
                          ),
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
