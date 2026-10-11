import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/repositories/volunteering_opportunities_repository.dart';

class VolunteeringOpportunityDetailsHeader extends StatelessWidget {
  const VolunteeringOpportunityDetailsHeader({super.key, required this.volunteeringOpportunity});

  final VolunteeringOpportunityDetails volunteeringOpportunity;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          volunteeringOpportunity.type.name,
          style: context.textTheme.labelLarge?.copyWith(
            color: context.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: AppSpacing.xxs),
        Text(
          volunteeringOpportunity.title(context.isArabic),
          style: context.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
