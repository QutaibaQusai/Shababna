import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/validators/app_validators.dart';
import '../../../../../core/shared/widgets/app_page_header.dart';
import '../../../../../core/shared/widgets/app_text_field.dart';
import '../../../../../core/theme/app_spacing.dart';

class RegisterStepName extends StatelessWidget {
  const RegisterStepName({super.key, required this.formKey, required this.fullNameController});

  static const _maxNameLength = 200;

  final GlobalKey<FormState> formKey;
  final TextEditingController fullNameController;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppPageHeader(title: l10n.stepNameTitle, subtitle: l10n.stepNameSubtitle),
            SizedBox(height: AppSpacing.md),
            AppTextField(
              label: l10n.registerFullNameLabel,
              controller: fullNameController,
              prefixIcon: LucideIcons.user,
              textInputAction: TextInputAction.done,
              inputFormatters: [LengthLimitingTextInputFormatter(_maxNameLength)],
              validator: AppValidators.required(l10n.fieldRequiredError),
            ),
          ],
        ),
      ),
    );
  }
}
