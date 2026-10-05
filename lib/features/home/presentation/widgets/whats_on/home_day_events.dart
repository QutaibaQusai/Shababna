import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/repositories/home_repository.dart';
import '../shared/home_formatters.dart';
import '../shared/home_list_tile.dart';

class HomeDayEvents extends StatelessWidget {
  const HomeDayEvents({super.key, required this.events, required this.isLoading});

  static const _placeholderCount = 2;

  final List<HomeEvent> events;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Skeletonizer(
        enabled: true,
        child: Column(
          children: [
            for (var i = 0; i < _placeholderCount; i++) ...[
              if (i > 0) SizedBox(height: AppSpacing.xs),
              HomeListTile(
                imageUrl: '',
                title: 'Community health awareness day',
                subtitle: 'Health awareness',
                meta: 'Oct 12, 2026',
                onTap: () {},
              ),
            ],
          ],
        ),
      );
    }

    if (events.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin, vertical: AppSpacing.sm),
        child: Text(
          context.l10n.homeNoEventsOnDay,
          textAlign: TextAlign.center,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    final isArabic = context.isArabic;

    return Column(
      children: [
        for (var i = 0; i < events.length; i++) ...[
          if (i > 0) SizedBox(height: AppSpacing.xs),
          HomeListTile(
            imageUrl: events[i].imageUrl,
            title: events[i].title(isArabic),
            subtitle: events[i].typeName,
            meta: HomeFormatters.dateRange(context, events[i].from, events[i].to),
            onTap: () => context.push(AppRoutes.eventDetailsPath(events[i].id)),
          ),
        ],
      ],
    );
  }
}
