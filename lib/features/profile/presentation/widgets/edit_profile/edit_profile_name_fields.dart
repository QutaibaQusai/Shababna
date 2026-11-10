import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/shared/widgets/app_text_field.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/validators/app_validators.dart';
import '../../utils/profile_missing_field.dart';
import 'edit_profile_form_scope.dart';

class EditProfileNameFields extends StatelessWidget {
  const EditProfileNameFields({
    super.key,
    required this.scope,
    required this.fullNameArController,
    required this.fullNameEnController,
  });

  static const _maxNameLength = 200;

  final EditProfileFormScope scope;
  final TextEditingController fullNameArController;
  final TextEditingController fullNameEnController;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final required = AppValidators.required(l10n.fieldRequiredError);
    final lengthLimit = [LengthLimitingTextInputFormatter(_maxNameLength)];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        scope.anchor(
          ProfileMissingField.fullNameAr,
          AppTextField(
            label: l10n.fullNameArLabel,
            hasError: scope.isMissing(ProfileMissingField.fullNameAr),
            controller: fullNameArController,
            prefixIcon: LucideIcons.user,
            textInputAction: TextInputAction.next,
            inputFormatters: lengthLimit,
            onChanged: (value) =>
                scope.edit((draft) => draft.copyWith(fullNameAr: value)),
            validator: required,
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        scope.anchor(
          ProfileMissingField.fullNameEn,
          AppTextField(
            label: l10n.fullNameEnLabel,
            hasError: scope.isMissing(ProfileMissingField.fullNameEn),
            controller: fullNameEnController,
            prefixIcon: LucideIcons.user,
            textInputAction: TextInputAction.next,
            inputFormatters: lengthLimit,
            onChanged: (value) =>
                scope.edit((draft) => draft.copyWith(fullNameEn: value)),
            validator: required,
          ),
        ),
      ],
    );
  }
}
