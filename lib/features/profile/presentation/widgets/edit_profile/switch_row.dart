import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/shared/widgets/app_switch.dart';
import '../../../../../core/theme/app_spacing.dart';

class SwitchRow extends StatelessWidget {
  const SwitchRow({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.hasError = false,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool hasError;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.textTheme.bodyMedium?.copyWith(
              color: hasError ? context.colorScheme.error : null,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
          AppSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
