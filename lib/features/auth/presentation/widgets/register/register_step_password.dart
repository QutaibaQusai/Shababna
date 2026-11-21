import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/validators/app_validators.dart';
import '../../../../../core/shared/widgets/app_page_header.dart';
import '../../../../../core/shared/widgets/app_text_field.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/shared/widgets/app_error_box.dart';

class RegisterStepPassword extends StatelessWidget {
  const RegisterStepPassword({
    super.key,
    required this.formKey,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.onPasswordChanged,
    this.errorMessage,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final VoidCallback onPasswordChanged;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final errorMessage = this.errorMessage;

    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppPageHeader(
              title: context.l10n.stepPasswordTitle,
              subtitle: context.l10n.stepPasswordSubtitle,
            ),
            SizedBox(height: AppSpacing.md),
            AppTextField(
              label: context.l10n.passwordLabel,
              controller: passwordController,
              obscureText: true,
              prefixIcon: LucideIcons.lock,
              textInputAction: TextInputAction.next,
              onChanged: (_) => onPasswordChanged(),
              validator: AppValidators.required(context.l10n.fieldRequiredError),
            ),
            SizedBox(height: AppSpacing.sm),
            AppTextField(
              label: context.l10n.confirmPasswordLabel,
              controller: confirmPasswordController,
              obscureText: true,
              prefixIcon: LucideIcons.lock,
              textInputAction: TextInputAction.done,
              onChanged: (_) => onPasswordChanged(),
              validator: AppValidators.combine([
                AppValidators.required(context.l10n.fieldRequiredError),
                AppValidators.match(
                  () => passwordController.text,
                  context.l10n.passwordsDoNotMatchError,
                ),
              ]),
            ),
            if (errorMessage != null) ...[
              SizedBox(height: AppSpacing.sm),
              AppErrorBox(message: errorMessage),
            ],
          ],
        ),
      ),
    );
  }
}
