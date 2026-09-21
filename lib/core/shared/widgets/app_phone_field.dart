import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../theme/app_spacing.dart';
import 'app_picker_field.dart';
import 'app_text_field.dart';

class AppPhoneField<T> extends StatelessWidget {
  const AppPhoneField({
    super.key,
    required this.label,
    required this.numberController,
    required this.countries,
    required this.selectedCountry,
    required this.onCountrySelected,
    required this.countryItemLabel,
    required this.countrySelectedLabel,
    this.isLoadingCountries = false,
    this.countriesError,
    this.onRetryLoadCountries,
    this.searchHint,
    this.countryValidator,
    this.numberValidator,
  });

  final String label;
  final TextEditingController numberController;
  final List<T> countries;
  final T? selectedCountry;
  final ValueChanged<T> onCountrySelected;
  final String Function(T country) countryItemLabel;
  final String Function(T country) countrySelectedLabel;
  final bool isLoadingCountries;
  final String? countriesError;
  final VoidCallback? onRetryLoadCountries;
  final String? searchHint;
  final FormFieldValidator<String>? countryValidator;
  final FormFieldValidator<String>? numberValidator;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: AppPickerField<T>(
            label: '',
            items: countries,
            itemLabel: countryItemLabel,
            selectedLabel: countrySelectedLabel,
            onSelected: onCountrySelected,
            selectedItem: selectedCountry,
            isLoading: isLoadingCountries,
            errorMessage: countriesError,
            onRetry: onRetryLoadCountries,
            searchHint: searchHint,
            validator: countryValidator,
          ),
        ),
        SizedBox(width: AppSpacing.xs),
        Expanded(
          child: AppTextField(
            label: label,
            controller: numberController,
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            prefixIcon: LucideIcons.phone,
            textInputAction: TextInputAction.done,
            validator: numberValidator,
          ),
        ),
      ],
    );
  }
}
