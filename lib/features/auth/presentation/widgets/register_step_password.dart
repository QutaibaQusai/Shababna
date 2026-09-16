import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/validators/app_validators.dart';
import '../../../../core/shared/widgets/app_text_field.dart';
import '../../../../core/theme/app_spacing.dart';

class RegisterStepPassword extends StatelessWidget {
  const RegisterStepPassword({
    super.key,
    required this.formKey,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.stepPasswordTitle, style: context.textTheme.headlineMedium),
          SizedBox(height: AppSpacing.md),
          AppTextField(
            label: context.l10n.passwordLabel,
            controller: passwordController,
            obscureText: true,
            prefixIcon: LucideIcons.lock,
            textInputAction: TextInputAction.next,
            validator: AppValidators.combine([
              AppValidators.required(context.l10n.fieldRequiredError),
              AppValidators.minLength(8, context.l10n.passwordTooShortError),
            ]),
          ),
          SizedBox(height: AppSpacing.sm),
          AppTextField(
            label: context.l10n.confirmPasswordLabel,
            controller: confirmPasswordController,
            obscureText: true,
            prefixIcon: LucideIcons.lock,
            textInputAction: TextInputAction.done,
            validator: AppValidators.combine([
              AppValidators.required(context.l10n.fieldRequiredError),
              AppValidators.match(
                () => passwordController.text,
                context.l10n.passwordsDoNotMatchError,
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
