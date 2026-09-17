import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/validators/app_validators.dart';
import '../../../../../core/shared/widgets/app_page_header.dart';
import '../../../../../core/shared/widgets/app_text_field.dart';
import '../../../../../core/theme/app_spacing.dart';

class RegisterStepName extends StatelessWidget {
  const RegisterStepName({
    super.key,
    required this.formKey,
    required this.fullNameArController,
    required this.fullNameEnController,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController fullNameArController;
  final TextEditingController fullNameEnController;

  @override
  Widget build(BuildContext context) {
    final required = AppValidators.required(context.l10n.fieldRequiredError);

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppPageHeader(title: context.l10n.stepNameTitle),
          SizedBox(height: AppSpacing.md),
          AppTextField(
            label: context.l10n.fullNameArLabel,
            controller: fullNameArController,
            validator: required,
            prefixIcon: LucideIcons.user,
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: AppSpacing.sm),
          AppTextField(
            label: context.l10n.fullNameEnLabel,
            controller: fullNameEnController,
            validator: required,
            prefixIcon: LucideIcons.user,
            textInputAction: TextInputAction.done,
          ),
        ],
      ),
    );
  }
}
