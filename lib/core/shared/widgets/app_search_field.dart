import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../extensions/context_extensions.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_sizes.dart';
import '../../theme/app_spacing.dart';

class AppSearchField extends StatelessWidget {
  const AppSearchField({
    super.key,
    this.hint,
    this.controller,
    required this.onChanged,
    this.autofocus = false,
  });

  final String? hint;
  final TextEditingController? controller;
  final ValueChanged<String> onChanged;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      autofocus: autofocus,
      textInputAction: TextInputAction.search,
      style: context.textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(LucideIcons.search, size: AppSizes.iconField),
        contentPadding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
        border: OutlineInputBorder(
          borderRadius: AppRadius.pillRadius,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.pillRadius,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.pillRadius,
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
