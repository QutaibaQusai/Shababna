import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../core/shared/widgets/app_picker_field.dart';
import '../../../../../../core/shared/widgets/app_text_field.dart';
import '../../../../../../core/theme/app_sizes.dart';
import '../../../../../../core/theme/app_spacing.dart';
import '../../../../../../core/validators/app_validators.dart';
import '../../../../domain/auth_identifier.dart';
import '../../../../domain/repositories/auth_repository.dart';
import '../../../cubit/phone_codes/phone_codes_cubit.dart';
import '../../../cubit/phone_codes/phone_codes_state.dart';

enum _IdentifierMode { localPhone, internationalPhone, email }

class LoginIdentifierField extends StatelessWidget {
  const LoginIdentifierField({super.key, required this.controller});

  static const _resizeDuration = Duration(milliseconds: 200);

  final TextEditingController controller;

  static _IdentifierMode _modeOf(String text) {
    if (AuthIdentifier.isEmailInput(text)) return _IdentifierMode.email;
    if (PhoneIdentifier.isInternationalInput(text)) return _IdentifierMode.internationalPhone;
    return _IdentifierMode.localPhone;
  }

  FormFieldValidator<String> _validator(BuildContext context, CountryPhoneCode? country) {
    final l10n = context.l10n;
    final email = AppValidators.email(l10n.invalidEmailError);
    final localPhone = AppValidators.nationalNumber(
      invalidMessage: l10n.invalidPhoneNumberError,
      lengthMessage: l10n.phoneNumberLengthError,
      prefixMessage: (prefixes) => l10n.phoneNumberPrefixError(prefixes.join(' / ')),
      length: country?.nationalNumberLength,
      prefixes: country?.mobilePrefixes,
    );

    return (value) {
      final text = value?.trim() ?? '';
      if (text.isEmpty) return l10n.fieldRequiredError;
      return switch (_modeOf(text)) {
        _IdentifierMode.email => email(text),
        _IdentifierMode.internationalPhone =>
          PhoneIdentifier.tryParse(text) == null ? l10n.invalidPhoneNumberError : null,
        _IdentifierMode.localPhone => localPhone(PhoneIdentifier.normalize(text)),
      };
    };
  }

  @override
  Widget build(BuildContext context) {
    final phoneCodes = context.watch<PhoneCodesCubit>().state;
    final validator = _validator(context, phoneCodes.selected);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppFieldLabel(label: context.l10n.identifierLabel),
        SizedBox(height: AppSpacing.xs),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (context, value, _) {
            final mode = _modeOf(value.text);
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedSize(
                  duration: _resizeDuration,
                  child: mode == _IdentifierMode.localPhone
                      ? Padding(
                          padding: EdgeInsetsDirectional.only(end: AppSpacing.xs),
                          child: _CountryCodePicker(state: phoneCodes),
                        )
                      : const SizedBox.shrink(),
                ),
                Expanded(
                  child: AppTextField(
                    label: '',
                    controller: controller,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: mode == _IdentifierMode.email
                        ? LucideIcons.mail
                        : LucideIcons.phone,
                    textInputAction: TextInputAction.next,
                    validator: validator,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _CountryCodePicker extends StatelessWidget {
  const _CountryCodePicker({required this.state});

  final PhoneCodesState state;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PhoneCodesCubit>();

    return SizedBox(
      width: AppSizes.countryCodePickerWidth,
      child: AppPickerField<CountryPhoneCode>(
        label: '',
        items: state.codes,
        selectedItem: state.selected,
        itemLabel: (code) => '${code.flag}  ${code.countryName} (${code.callingCode})',
        selectedLabel: (code) => '${code.flag} ',
        onSelected: cubit.select,
        isLoading: state.isLoading,
        errorMessage: state.errorMessage,
        onRetry: cubit.retry,
        searchHint: context.l10n.searchCountryHint,
        validator: AppValidators.required(context.l10n.fieldRequiredError),
      ),
    );
  }
}
