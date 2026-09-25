import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/shared/widgets/app_text_field.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';

class FieldCard extends StatelessWidget {
  const FieldCard({
    super.key,
    required this.label,
    required this.icon,
    required this.value,
    this.isVerified = false,
    this.valueDirection,
    this.onTap,
  });

  final String label;
  final IconData icon;
  final String? value;
  final bool isVerified;
  final TextDirection? valueDirection;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: label,
      controller: TextEditingController(text: value ?? '-'),
      readOnly: true,
      prefixIcon: icon,
      onTap: onTap,
      suffix: Icon(
        context.isRTL ? LucideIcons.chevronLeft : LucideIcons.chevronRight,
        size: AppSizes.iconField,
      ),
    );
  }
}
