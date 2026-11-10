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
import '../../cubit/register/register_verify_cubit.dart';
import '../../cubit/register/register_verify_state.dart';
import '../../widgets/register/register_step_contact.dart';
import '../../widgets/register/register_step_indicator.dart';
import '../../widgets/register/register_step_password.dart';
import '../../widgets/register/register_step_verify_email.dart';
import '../../../../../core/shared/widgets/app_bottom_safe_area.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<RegisterCubit>()..loadPhoneCodes()),
        BlocProvider(create: (_) => sl<RegisterVerifyCubit>()),
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
  static const _stepCount = 3;
  static const _contactStep = 0;
  static const _codeStep = 1;
  static const _passwordStep = 2;
  static const _defaultCountryCode = 'JO';
  static const _stepDuration = Duration(milliseconds: 250);

  final _pageController = PageController();
  final _stepFormKeys = List.generate(_stepCount, (_) => GlobalKey<FormState>());
  int _currentStep = _contactStep;

  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _otpController = TextEditingController();

  CountryPhoneCode? _selectedPhoneCode;

  @override
  void dispose() {
    _pageController.dispose();
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

  String get _composedPhoneNumber => PhoneNumber.toE164(
        callingCode: _selectedPhoneCode!.callingCode,
        input: _phoneNumberController.text,
      );

  void _advance() {
    setState(() => _currentStep++);
    _pageController.nextPage(duration: _stepDuration, curve: Curves.easeOut);
  }

  void _goNext() {
    if (!(_stepFormKeys[_currentStep].currentState?.validate() ?? false)) return;

    switch (_currentStep) {
      case _contactStep:
        _sendCode();
      case _codeStep:
        _verifyCode();
      case _passwordStep:
        _register();
    }
  }

  void _sendCode() {
    context.read<RegisterVerifyCubit>().sendCode(
          email: _emailController.text.trim(),
          phoneNumber: _composedPhoneNumber,
        );
  }

  void _verifyCode() {
    context.read<RegisterVerifyCubit>().verify(
          email: _emailController.text.trim(),
          phoneNumber: _composedPhoneNumber,
          code: _otpController.text.trim(),
        );
  }

  void _resendCode() {
    context.read<RegisterVerifyCubit>().resend(
          email: _emailController.text.trim(),
          phoneNumber: _composedPhoneNumber,
        );
  }

  void _register() {
    context.read<RegisterCubit>().submit(
          email: _emailController.text.trim(),
          phoneNumber: _composedPhoneNumber,
          password: _passwordController.text,
          confirmPassword: _confirmPasswordController.text,
          verificationToken: context.read<RegisterVerifyCubit>().state.verificationToken!,
        );
  }

  void _returnToLogin() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.login);
    }
  }

  void _goBack() {
    if (_currentStep == _contactStep) {
      _returnToLogin();
      return;
    }
    setState(() => _currentStep--);
    _pageController.previousPage(duration: _stepDuration, curve: Curves.easeOut);
  }

  void _onRegisterStatusChanged(BuildContext context, RegisterState state) {
    if (state.status == FormStatus.success) {
      AppToast.success(context, context.l10n.registrationCompleteMessage);
      _returnToLogin();
    } else if (state.status == FormStatus.failure && state.errorMessage != null) {
      AppToast.error(context, state.errorMessage!);
    }
  }

  void _onRegisterVerifyStateChanged(BuildContext context, RegisterVerifyState state) {
    if (state.status == FormStatus.success) {
      _advance();
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
        _contactStep => context.l10n.sendCodeButton,
        _codeStep => context.l10n.verifyButton,
        _ => context.l10n.createAccountButton,
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
        BlocListener<RegisterVerifyCubit, RegisterVerifyState>(
          listenWhen: (previous, current) =>
              previous.status != current.status ||
              previous.resendMessage != current.resendMessage,
          listener: _onRegisterVerifyStateChanged,
        ),
      ],
      child: BlocBuilder<RegisterCubit, RegisterState>(
        builder: (context, state) {
          final isVerifying =
              context.watch<RegisterVerifyCubit>().state.status == FormStatus.submitting;

          return AppLoadingOverlay(
            isLoading: state.status == FormStatus.submitting || isVerifying,
            child: Scaffold(
              appBar: AppAppBar(
                title: context.l10n.registerTitle,
                onBack: _goBack,
              ),
              body: AppBottomSafeArea(
                top: true,
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
                            RegisterStepContact(
                              formKey: _stepFormKeys[_contactStep],
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
                            RegisterStepVerifyEmail(
                              formKey: _stepFormKeys[_codeStep],
                              codeController: _otpController,
                              email: _emailController.text.trim(),
                              onCompleted: _goNext,
                              onResend: _resendCode,
                            ),
                            RegisterStepPassword(
                              formKey: _stepFormKeys[_passwordStep],
                              passwordController: _passwordController,
                              confirmPasswordController: _confirmPasswordController,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: AppSpacing.sm),
                      AppButton.primary(
                        label: _primaryLabel(context),
                        onPressed: _goNext,
                      ),
                      if (_currentStep != _codeStep)
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(context.l10n.alreadyHaveAccountPrompt),
                              AppButton.text(
                                label: context.l10n.loginLink,
                                onPressed: _returnToLogin,
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
