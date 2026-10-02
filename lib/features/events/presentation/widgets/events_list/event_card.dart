import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/shared/widgets/app_network_image.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/repositories/events_repository.dart';
import '../shared/event_date_range.dart';
import '../shared/event_info_row.dart';
import '../shared/event_pill.dart';

class EventCard extends StatelessWidget {
  const EventCard({super.key, required this.event});

  static const imageAspectRatio = 16 / 9;

  final EventSummary event;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () => context.push(AppRoutes.eventDetailsPath(event.id)),
        borderRadius: AppRadius.xlRadius,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: AppRadius.xlRadius,
              child: AspectRatio(
                aspectRatio: imageAspectRatio,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    AppNetworkImage(url: event.imageUrl, size: AppSizes.iconLg * 2),
                    PositionedDirectional(
                      top: AppSpacing.xs,
                      end: AppSpacing.xs,
                      child: EventPill(
                        label: context.l10n.eventHours(event.hours),
                        icon: LucideIcons.clock,
                        color: colorScheme.onSurface,
                        background: colorScheme.surface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: AppSpacing.xs),
            Text(
              event.type.name,
              style: context.textTheme.labelMedium?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: AppSpacing.xxs),
            Text(
              event.title(context.isArabic),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
            ),
            SizedBox(height: AppSpacing.xs),
            EventInfoRow(
              icon: LucideIcons.calendarDays,
              text: eventDateRange(context, event.from, event.to),
            ),
            if (event.address.isNotEmpty) ...[
              SizedBox(height: AppSpacing.xxs),
              EventInfoRow(icon: LucideIcons.mapPin, text: event.address),
            ],
          ],
        ),
      ),
    );
  }
}
