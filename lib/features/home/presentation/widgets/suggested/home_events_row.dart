import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/shared/widgets/app_network_image.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/repositories/home_repository.dart';
import '../shared/home_formatters.dart';

class HomeEventsRow extends StatelessWidget {
  const HomeEventsRow({super.key, required this.events});

  static const cardWidthFactor = 0.42;
  static const cardAspectRatio = 3 / 4;

  final List<HomeEvent> events;

  static double cardWidth(BuildContext context) =>
      MediaQuery.sizeOf(context).width * cardWidthFactor;

  @override
  Widget build(BuildContext context) {
    final width = cardWidth(context);

    return SizedBox(
      height: width / cardAspectRatio,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin),
        itemCount: events.length,
        separatorBuilder: (_, _) => SizedBox(width: AppSpacing.xs),
        itemBuilder: (context, index) => SizedBox(
          width: width,
          child: _EventCard(event: events[index]),
        ),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({required this.event});

  static const _scrimStops = [0.35, 1.0];
  static const _scrim = [Colors.transparent, Color(0xE6000000)];
  static const _muted = Color(0xCCFFFFFF);

  final HomeEvent event;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    return Material(
      color: Colors.black,
      borderRadius: AppRadius.lgRadius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(AppRoutes.eventDetailsPath(event.id)),
        child: Stack(
          fit: StackFit.expand,
          children: [
            AppNetworkImage(url: event.imageUrl, size: AppSizes.iconLg * 2),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: _scrimStops,
                  colors: _scrim,
                ),
              ),
            ),
            PositionedDirectional(
              start: AppSpacing.xs,
              end: AppSpacing.xs,
              bottom: AppSpacing.xs,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (event.typeName.isNotEmpty) ...[
                    Text(
                      event.typeName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.labelSmall?.copyWith(color: _muted),
                    ),
                    SizedBox(height: AppSpacing.xxs),
                  ],
                  Text(
                    event.title(context.isArabic),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.titleSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xxs),
                  Text(
                    HomeFormatters.dateRange(context, event.from, event.to),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.labelSmall?.copyWith(color: _muted),
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
