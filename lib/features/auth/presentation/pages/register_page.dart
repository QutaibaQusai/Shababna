import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/shared/widgets/app_button.dart';
import '../../../../core/shared/widgets/app_loading_overlay.dart';
import '../../../../core/state/form_status.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/repositories/auth_repository.dart';
import '../cubit/register_cubit.dart';
import '../cubit/register_state.dart';
import '../widgets/auth_error_banner.dart';
import '../widgets/register_step_contact.dart';
import '../widgets/register_step_name.dart';
import '../widgets/register_step_password.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RegisterCubit>()..loadPhoneCodes(),
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
  final _pageController = PageController();
  final _stepFormKeys = List.generate(3, (_) => GlobalKey<FormState>());
  int _currentStep = 0;

  final _fullNameArController = TextEditingController();
  final _fullNameEnController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  CountryPhoneCode? _selectedPhoneCode;

  static const _stepCount = 3;
  static const _defaultCountryCode = 'JO';

  @override
  void dispose() {
    _pageController.dispose();
    _fullNameArController.dispose();
    _fullNameEnController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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

  String _stripLeadingZero(String digits) {
    return digits.startsWith('0') ? digits.substring(1) : digits;
  }

  void _goNext() {
    if (!(_stepFormKeys[_currentStep].currentState?.validate() ?? false)) return;

    if (_currentStep == _stepCount - 1) {
      final phoneNumber =
          '${_selectedPhoneCode!.callingCode}${_stripLeadingZero(_phoneNumberController.text.trim())}';
      context.read<RegisterCubit>().submit(
            email: _emailController.text.trim(),
            phoneNumber: phoneNumber,
            fullNameEn: _fullNameEnController.text.trim(),
            fullNameAr: _fullNameArController.text.trim(),
            password: _passwordController.text,
            confirmPassword: _confirmPasswordController.text,
          );
      return;
    }

    setState(() => _currentStep++);
    _pageController.nextPage(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  void _goBack() {
    if (_currentStep == 0) {
      context.pop();
      return;
    }
    setState(() => _currentStep--);
    _pageController.previousPage(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state.status == FormStatus.success) {
          context.go(AppRoutes.verifyEmail, extra: state.registeredEmail);
        }
        _selectDefaultPhoneCodeIfNeeded(state.phoneCodes);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _goBack,
          ),
          title: Text(context.l10n.registerTitle),
        ),
        body: SafeArea(
          child: BlocBuilder<RegisterCubit, RegisterState>(
            builder: (context, state) {
              return AppLoadingOverlay(
                isLoading: state.status == FormStatus.submitting,
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.screenMargin),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AuthErrorBanner(message: state.errorMessage),
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
                              formKey: _stepFormKeys[2],
                              passwordController: _passwordController,
                              confirmPasswordController: _confirmPasswordController,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: AppSpacing.sm),
                      AppButton.primary(
                        label: _currentStep == _stepCount - 1
                            ? context.l10n.createAccountButton
                            : context.l10n.nextButton,
                        onPressed: _goNext,
                      ),
                      SizedBox(height: AppSpacing.sm),
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
              );
            },
          ),
        ),
      ),
    );
  }
}
