import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/validators/app_validators.dart';
import '../../../../core/shared/widgets/app_text_field.dart';
import '../../../../core/theme/app_spacing.dart';

class RegisterStepContact extends StatelessWidget {
  const RegisterStepContact({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.phoneNumberController,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController phoneNumberController;

  @override
  Widget build(BuildContext context) {
    final required = AppValidators.required(context.l10n.fieldRequiredError);

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.stepContactTitle, style: context.textTheme.headlineMedium),
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
          AppTextField(
            label: context.l10n.phoneNumberLabel,
            controller: phoneNumberController,
            keyboardType: TextInputType.phone,
            prefixIcon: LucideIcons.phone,
            textInputAction: TextInputAction.done,
            validator: required,
          ),
        ],
      ),
    );
  }
}
