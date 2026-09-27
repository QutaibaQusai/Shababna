import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/shared/widgets/app_page_header.dart';
import '../../../../../core/shared/widgets/app_phone_field.dart';
import '../../../../../core/shared/widgets/app_text_field.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/validators/app_validators.dart';
import '../../../domain/repositories/auth_repository.dart';

class RegisterStepContact extends StatelessWidget {
  const RegisterStepContact({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.phoneNumberController,
    required this.phoneCodes,
    required this.selectedPhoneCode,
    required this.onPhoneCodeSelected,
    this.isLoadingPhoneCodes = false,
    this.phoneCodesError,
    this.onRetryLoadPhoneCodes,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController phoneNumberController;
  final List<CountryPhoneCode> phoneCodes;
  final CountryPhoneCode? selectedPhoneCode;
  final ValueChanged<CountryPhoneCode> onPhoneCodeSelected;
  final bool isLoadingPhoneCodes;
  final String? phoneCodesError;
  final VoidCallback? onRetryLoadPhoneCodes;

  @override
  Widget build(BuildContext context) {
    final required = AppValidators.required(context.l10n.fieldRequiredError);

    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppPageHeader(
              title: context.l10n.stepContactTitle,
              subtitle: context.l10n.stepContactSubtitle,
            ),
            SizedBox(height: AppSpacing.md),
            AppTextField(
              label: context.l10n.emailLabel,
              hint: context.l10n.emailHint,
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: LucideIcons.mail,
              textInputAction: TextInputAction.next,
              validator: AppValidators.combine([
                required,
                AppValidators.email(context.l10n.invalidEmailError),
              ]),
            ),
            SizedBox(height: AppSpacing.sm),
            AppPhoneField<CountryPhoneCode>(
              label: context.l10n.phoneNumberLabel,
              numberController: phoneNumberController,
              countries: phoneCodes,
              selectedCountry: selectedPhoneCode,
              onCountrySelected: onPhoneCodeSelected,
              countryItemLabel: (code) => '${code.flag}  ${code.countryName} (${code.callingCode})',
              countrySelectedLabel: (code) => '${code.flag} ',
              isLoadingCountries: isLoadingPhoneCodes,
              countriesError: phoneCodesError,
              onRetryLoadCountries: onRetryLoadPhoneCodes,
              searchHint: context.l10n.searchCountryHint,
              countryValidator: required,
              numberValidator: AppValidators.combine([
                required,
                AppValidators.nationalNumber(
                  invalidMessage: context.l10n.invalidPhoneNumberError,
                  lengthMessage: context.l10n.phoneNumberLengthError,
                  prefixMessage: (prefixes) =>
                      context.l10n.phoneNumberPrefixError(prefixes.join(' / ')),
                  length: selectedPhoneCode?.nationalNumberLength,
                  prefixes: selectedPhoneCode?.mobilePrefixes,
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
