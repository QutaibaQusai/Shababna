import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/shared/widgets/app_picker_field.dart';
import '../../../../../core/shared/widgets/app_text_field.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/validators/app_validators.dart';
import '../../../domain/repositories/auth_repository.dart';

class PhoneNumberField extends StatelessWidget {
  const PhoneNumberField({
    super.key,
    required this.numberController,
    required this.phoneCodes,
    required this.selectedCode,
    required this.onCodeSelected,
    this.isLoadingCodes = false,
    this.codesError,
    this.onRetryLoadCodes,
  });

  final TextEditingController numberController;
  final List<CountryPhoneCode> phoneCodes;
  final CountryPhoneCode? selectedCode;
  final ValueChanged<CountryPhoneCode> onCodeSelected;
  final bool isLoadingCodes;
  final String? codesError;
  final VoidCallback? onRetryLoadCodes;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: AppPickerField<CountryPhoneCode>(
            label: context.l10n.phoneNumberLabel,
            items: phoneCodes,
            itemLabel: (code) => '${code.flag}  ${code.countryName} (${code.callingCode})',
            selectedLabel: (code) => '${code.flag} ${code.callingCode}',
            onSelected: onCodeSelected,
            selectedItem: selectedCode,
            isLoading: isLoadingCodes,
            errorMessage: codesError,
            onRetry: onRetryLoadCodes,
            sheetTitle: context.l10n.selectCountryTitle,
            searchHint: context.l10n.searchCountryHint,
            validator: AppValidators.required(context.l10n.fieldRequiredError),
          ),
        ),
        SizedBox(width: AppSpacing.xs),
        Expanded(
          child: AppTextField(
            label: '',
            controller: numberController,
            keyboardType: TextInputType.phone,
            prefixIcon: LucideIcons.phone,
            textInputAction: TextInputAction.done,
            validator: AppValidators.combine([
              AppValidators.required(context.l10n.fieldRequiredError),
              AppValidators.digitsOnly(context.l10n.invalidPhoneNumberError),
            ]),
          ),
        ),
      ],
    );
  }
}
