import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';

import '../../config/app_config.dart';
import '../../extensions/context_extensions.dart';
import '../../theme/app_borders.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_sizes.dart';

class AppOtpField extends StatelessWidget {
  const AppOtpField({
    super.key,
    required this.controller,
    required this.validator,
    this.length = AppConfig.otpLength,
    this.autofocus = false,
    this.onCompleted,
  });

  final TextEditingController controller;
  final FormFieldValidator<String> validator;
  final int length;
  final bool autofocus;
  final ValueChanged<String>? onCompleted;

  @override
  Widget build(BuildContext context) {
    final inputTheme = context.theme.inputDecorationTheme;
    final fillColor = inputTheme.fillColor ?? context.colorScheme.surface;

    final defaultPinTheme = PinTheme(
      width: AppSizes.otpBoxSize,
      height: AppSizes.otpBoxSize,
      textStyle: context.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w600),
      decoration: BoxDecoration(color: fillColor, borderRadius: AppRadius.mdRadius),
    );

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Pinput(
        length: length,
        controller: controller,
        autofocus: autofocus,
        validator: validator,
        onCompleted: onCompleted,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        hapticFeedbackType: HapticFeedbackType.lightImpact,
        defaultPinTheme: defaultPinTheme,
        focusedPinTheme: defaultPinTheme.copyDecorationWith(
          border: Border.all(color: context.colorScheme.primary, width: AppBorders.thick),
        ),
        errorPinTheme: defaultPinTheme.copyDecorationWith(
          border: Border.all(color: context.colorScheme.error, width: AppBorders.thick),
        ),
        errorTextStyle: inputTheme.errorStyle,
      ),
    );
  }
}
