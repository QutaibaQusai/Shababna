import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/shared/widgets/app_network_image.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/repositories/volunteering_opportunities_repository.dart';
import 'volunteering_opportunity_section_title.dart';

class VolunteeringOpportunityDonorsSection extends StatelessWidget {
  const VolunteeringOpportunityDonorsSection({super.key, required this.donors});

  final List<VolunteeringOpportunityDonor> donors;

  @override
  Widget build(BuildContext context) {
    final margin = AppSpacing.screenMargin;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: margin),
          child: VolunteeringOpportunitySectionTitle(
            title: context.l10n.volunteeringOpportunitySupportedByTitle,
          ),
        ),
        SizedBox(height: AppSpacing.xs),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: margin),
          child: Row(
            children: [
              for (var i = 0; i < donors.length; i++) ...[
                if (i > 0) SizedBox(width: AppSpacing.md),
                _DonorCard(donor: donors[i]),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _DonorCard extends StatelessWidget {
  const _DonorCard({required this.donor});

  final VolunteeringOpportunityDonor donor;

  @override
  Widget build(BuildContext context) {
    final logoSize = AppSizes.volunteeringOpportunityDonorLogoSize;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: AppRadius.xsRadius,
          child: ColoredBox(
            color: Colors.white,
            child: SizedBox.square(
              dimension: logoSize,
              child: AppNetworkImage(url: donor.imageUrl, size: logoSize / 2, fit: BoxFit.contain),
            ),
          ),
        ),
        SizedBox(width: AppSpacing.xs),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: AppSizes.volunteeringOpportunityDonorNameMaxWidth),
          child: Text(
            donor.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
