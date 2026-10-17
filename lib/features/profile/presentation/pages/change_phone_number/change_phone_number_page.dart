import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../core/di/service_locator.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/shared/widgets/app_app_bar.dart';
import '../../../../../core/shared/widgets/app_button.dart';
import '../../../../../core/shared/widgets/app_error_widget.dart';
import '../../../../../core/shared/widgets/app_loading_overlay.dart';
import '../../../../../core/shared/widgets/app_phone_field.dart';
import '../../../../../core/shared/widgets/app_toast.dart';
import '../../../../../core/state/form_status.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/utils/phone_number.dart';
import '../../../../../core/validators/app_validators.dart';
import '../../../domain/repositories/profile_lookups_repository.dart';
import '../../cubit/change_phone_number/change_phone_number_cubit.dart';
import '../../cubit/change_phone_number/change_phone_number_state.dart';
import '../../cubit/profile/profile_cubit.dart';
import '../../utils/phone_number_parts.dart';
import '../../../../../core/shared/widgets/app_page_header.dart';
import '../../../../../core/shared/widgets/app_bottom_safe_area.dart';

class ChangePhoneNumberPage extends StatelessWidget {
  const ChangePhoneNumberPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sl<ProfileCubit>()),
        BlocProvider(create: (_) => sl<ChangePhoneNumberCubit>()..loadPhoneCodes()),
      ],
      child: const _ChangePhoneNumberView(),
    );
  }
}

class _ChangePhoneNumberView extends StatefulWidget {
  const _ChangePhoneNumberView();

  @override
  State<_ChangePhoneNumberView> createState() => _ChangePhoneNumberViewState();
}

class _ChangePhoneNumberViewState extends State<_ChangePhoneNumberView> {
  static const _defaultCountryCode = 'JO';

  final _formKey = GlobalKey<FormState>();
  final _numberController = TextEditingController();
  late final String? _currentPhoneNumber = context.read<ProfileCubit>().state.profile?.phoneNumber;
  PhoneCode? _selectedCode;

  @override
  void initState() {
    super.initState();
    _prefill(context.read<ChangePhoneNumberCubit>().state.phoneCodes);
    _numberController.addListener(_onNumberChanged);
  }

  @override
  void dispose() {
    _numberController
      ..removeListener(_onNumberChanged)
      ..dispose();
    super.dispose();
  }

  void _onNumberChanged() => setState(() {});

  void _prefill(List<PhoneCode> codes) {
    if (_selectedCode != null || codes.isEmpty) return;
    final parts = PhoneNumberParts.split(_currentPhoneNumber, codes);
    _selectedCode = parts?.code ??
        codes.firstWhere(
          (code) => code.countryCode == _defaultCountryCode,
          orElse: () => codes.first,
        );
    _numberController.text = parts?.nationalNumber ?? '';
  }

  String? get _composedNumber {
    final code = _selectedCode;
    final input = _numberController.text.trim();
    if (code == null || input.isEmpty) return null;
    return PhoneNumber.toE164(callingCode: code.callingCode, input: input);
  }

  bool get _hasChanged {
    final composed = _composedNumber;
    return composed != null && composed != _currentPhoneNumber;
  }

  void _submit() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final composed = _composedNumber;
    if (composed == null) return;
    context.read<ChangePhoneNumberCubit>().submit(composed);
  }

  void _onStatusChanged(BuildContext context, ChangePhoneNumberState state) {
    if (state.status == FormStatus.success) {
      AppToast.success(context, context.l10n.changePhoneNumberSuccessMessage);
      context.pop();
    } else if (state.status == FormStatus.failure) {
      AppToast.error(context, state.errorMessage ?? context.l10n.somethingWentWrong);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ChangePhoneNumberCubit, ChangePhoneNumberState>(
          listenWhen: (previous, current) => previous.phoneCodes != current.phoneCodes,
          listener: (context, state) => setState(() => _prefill(state.phoneCodes)),
        ),
        BlocListener<ChangePhoneNumberCubit, ChangePhoneNumberState>(
          listenWhen: (previous, current) => previous.status != current.status,
          listener: _onStatusChanged,
        ),
      ],
      child: BlocBuilder<ChangePhoneNumberCubit, ChangePhoneNumberState>(
        builder: (context, state) {
          return AppLoadingOverlay(
            isLoading: state.isSubmitting,
            child: Scaffold(
              appBar: AppAppBar(
                title: context.l10n.changePhoneNumberTitle,
                onBack: () => context.pop(),
              ),
              body: AppBottomSafeArea(
                top: true,
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.screenMargin),
                  child: _buildBody(context, state),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, ChangePhoneNumberState state) {
    if (state.hasPhoneCodesError && state.phoneCodes.isEmpty) {
      return AppErrorWidget(
        message: state.phoneCodesError ?? context.l10n.somethingWentWrong,
        onRetry: () => context.read<ChangePhoneNumberCubit>().loadPhoneCodes(),
      );
    }

    final isLoading = state.phoneCodes.isEmpty;
    final required = AppValidators.required(context.l10n.fieldRequiredError);
    final selectedCode = _selectedCode;

    return Skeletonizer(
      enabled: isLoading,
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
                      title: context.l10n.changePhoneNumberTitle,
                      subtitle: context.l10n.changePhoneNumberSubtitle,
                    ),
                    SizedBox(height: AppSpacing.md),
                    if (isLoading)
                      Container(
                        height: AppSizes.buttonHeight,
                        decoration: BoxDecoration(
                          color: context.colorScheme.surface,
                          borderRadius: AppRadius.mdRadius,
                        ),
                      )
                    else
                      AppPhoneField<PhoneCode>(
                        label: context.l10n.phoneNumberLabel,
                        numberController: _numberController,
                        countries: state.phoneCodes,
                        selectedCountry: selectedCode,
                        onCountrySelected: (code) => setState(() => _selectedCode = code),
                        countryItemLabel: (code) =>
                            '${code.flag}  ${code.countryName} (${code.callingCode})',
                        countrySelectedLabel: (code) => '${code.flag} ',
                        searchHint: context.l10n.searchCountryHint,
                        countryValidator: required,
                        numberValidator: AppValidators.combine([
                          required,
                          AppValidators.nationalNumber(
                            invalidMessage: context.l10n.invalidPhoneNumberError,
                            lengthMessage: context.l10n.phoneNumberLengthError,
                            prefixMessage: (prefixes) =>
                                context.l10n.phoneNumberPrefixError(prefixes.join(' / ')),
                            length: selectedCode?.nationalNumberLength,
                            prefixes: selectedCode?.mobilePrefixes,
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
            label: context.l10n.saveButton,
            onPressed: !isLoading && _hasChanged && !state.isSubmitting ? _submit : null,
          ),
        ],
      ),
    );
  }
}
