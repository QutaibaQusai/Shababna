import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';

class VolunteeringOpportunityKeyValueRow extends StatelessWidget {
  const VolunteeringOpportunityKeyValueRow({super.key, required this.label, required this.value});

  static const _labelFlex = 2;
  static const _valueFlex = 3;

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: _labelFlex,
          child: Text(
            label,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Expanded(
          flex: _valueFlex,
          child: Text(
            value,
            style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
