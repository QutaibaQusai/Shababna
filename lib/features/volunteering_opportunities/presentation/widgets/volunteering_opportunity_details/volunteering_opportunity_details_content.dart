import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/shared/widgets/app_media_slider.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/repositories/volunteering_opportunities_repository.dart';
import '../../mappers/volunteering_opportunity_media_mapper.dart';
import 'volunteering_opportunity_description.dart';
import 'volunteering_opportunity_details_header.dart';
import 'volunteering_opportunity_details_tabs.dart';
import 'volunteering_opportunity_donors_section.dart';
import 'volunteering_opportunity_section_title.dart';

class VolunteeringOpportunityDetailsContent extends StatelessWidget {
  const VolunteeringOpportunityDetailsContent({super.key, required this.volunteeringOpportunity});

  final VolunteeringOpportunityDetails volunteeringOpportunity;

  @override
  Widget build(BuildContext context) {
    final margin = EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin);
    final description = volunteeringOpportunity.description(context.isArabic);
    final media = volunteeringOpportunity.media;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
      children: [
        Padding(
          padding: margin,
          child: VolunteeringOpportunityDetailsHeader(
            volunteeringOpportunity: volunteeringOpportunity,
          ),
        ),
        if (media.isNotEmpty) ...[SizedBox(height: AppSpacing.sm), AppMediaSlider(media: media)],
        if (description.trim().isNotEmpty) ...[
          SizedBox(height: AppSpacing.md),
          Padding(
            padding: margin,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                VolunteeringOpportunitySectionTitle(
                  title: context.l10n.volunteeringOpportunityAboutTitle,
                ),
                SizedBox(height: AppSpacing.xs),
                VolunteeringOpportunityDescription(html: description),
              ],
            ),
          ),
        ],
        SizedBox(height: AppSpacing.sm),
        Padding(
          padding: margin,
          child: VolunteeringOpportunityDetailsTabs(
            volunteeringOpportunity: volunteeringOpportunity,
          ),
        ),
        if (volunteeringOpportunity.donors.isNotEmpty) ...[
          SizedBox(height: AppSpacing.md),
          VolunteeringOpportunityDonorsSection(donors: volunteeringOpportunity.donors),
        ],
        SizedBox(height: AppSpacing.sm),
      ],
    );
  }
}
