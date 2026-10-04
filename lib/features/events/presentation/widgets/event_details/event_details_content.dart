import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/shared/views/media_viewer/app_media.dart';
import '../../../../../core/shared/views/media_viewer/show_media_browser.dart';
import '../../../../../core/shared/widgets/app_network_image.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/repositories/events_repository.dart';
import 'event_description.dart';
import 'event_details_header.dart';
import 'event_details_tabs.dart';
import 'event_donors_section.dart';
import 'event_section_title.dart';
import 'event_tasks_card.dart';

class EventDetailsContent extends StatelessWidget {
  const EventDetailsContent({super.key, required this.event});

  static const _imageAspectRatio = 16 / 9;

  final EventDetails event;

  @override
  Widget build(BuildContext context) {
    final margin = EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin);
    final description = event.description(context.isArabic);

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
      children: [
        Padding(padding: margin, child: EventDetailsHeader(event: event)),
        SizedBox(height: AppSpacing.sm),
        Padding(
          padding: margin,
          child: GestureDetector(
            onTap: event.imageUrl.isEmpty
                ? null
                : () => showMediaBrowser(context, media: [AppImageMedia(event.imageUrl)]),
            child: ClipRRect(
              borderRadius: AppRadius.lgRadius,
              child: AspectRatio(
                aspectRatio: _imageAspectRatio,
                child: AppNetworkImage(url: event.imageUrl, size: AppSizes.iconLg * 2),
              ),
            ),
          ),
        ),
        if (description.trim().isNotEmpty) ...[
          SizedBox(height: AppSpacing.md),
          Padding(
            padding: margin,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                EventSectionTitle(title: context.l10n.eventAboutTitle),
                SizedBox(height: AppSpacing.xs),
                EventDescription(html: description),
              ],
            ),
          ),
        ],
        SizedBox(height: AppSpacing.sm),
        Padding(padding: margin, child: EventDetailsTabs(event: event)),
        if (event.registrationStatus == EventRegistrationStatus.approved) ...[
          SizedBox(height: AppSpacing.md),
          Padding(
            padding: margin,
            child: EventTasksCard(onTap: () => context.push(AppRoutes.eventTasksPath(event.id))),
          ),
        ],
        if (event.donors.isNotEmpty) ...[
          SizedBox(height: AppSpacing.md),
          EventDonorsSection(donors: event.donors),
        ],
        SizedBox(height: AppSpacing.sm),
      ],
    );
  }
}
