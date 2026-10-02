import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/shared/widgets/app_network_image.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/repositories/events_repository.dart';
import '../shared/event_info_row.dart';

class EventCard extends StatelessWidget {
  const EventCard({super.key, required this.event, required this.isTall});

  static const _tallAspectRatio = 3 / 4;
  static const _squareAspectRatio = 1.0;
  static const _titleMaxLines = 3;

  static bool isTallAt(int index) => index % 4 == 0 || index % 4 == 3;

  final EventSummary event;
  final bool isTall;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return Material(
      color: colorScheme.surface,
      borderRadius: AppRadius.mdRadius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(AppRoutes.eventDetailsPath(event.id)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: isTall ? _tallAspectRatio : _squareAspectRatio,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  AppNetworkImage(url: event.imageUrl, size: AppSizes.iconLg * 2),
                  PositionedDirectional(
                    top: AppSpacing.xs,
                    start: AppSpacing.xs,
                    child: _DateTile(date: event.from),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(AppSpacing.xs),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.type.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.labelSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xxs),
                  Text(
                    event.title(context.isArabic),
                    maxLines: _titleMaxLines,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs),
                  if (event.address.isNotEmpty) ...[
                    EventInfoRow(icon: LucideIcons.mapPin, text: event.address),
                    SizedBox(height: AppSpacing.xxs),
                  ],
                  EventInfoRow(
                    icon: LucideIcons.clock,
                    text: context.l10n.eventHours(event.hours),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateTile extends StatelessWidget {
  const _DateTile({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final locale = context.locale.toLanguageTag();
    final colorScheme = context.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(color: colorScheme.surface, borderRadius: AppRadius.mdRadius),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: AppSpacing.xxs),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              DateFormat.d(locale).format(date),
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                height: 1.1,
              ),
            ),
            Text(
              DateFormat.MMM(locale).format(date),
              style: context.textTheme.labelSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
