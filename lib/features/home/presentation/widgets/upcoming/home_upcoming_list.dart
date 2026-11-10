import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/repositories/home_repository.dart';
import '../shared/home_formatters.dart';
import '../shared/home_list_tile.dart';

class HomeUpcomingList extends StatelessWidget {
  const HomeUpcomingList({super.key, required this.volunteeringOpportunities});

  final List<HomeVolunteeringOpportunity> volunteeringOpportunities;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.isArabic;

    return Column(
      children: [
        for (var i = 0; i < volunteeringOpportunities.length; i++) ...[
          if (i > 0) SizedBox(height: AppSpacing.xs),
          HomeListTile(
            imageUrl: volunteeringOpportunities[i].imageUrl,
            title: volunteeringOpportunities[i].title(isArabic),
            subtitle: volunteeringOpportunities[i].typeName,
            meta: HomeFormatters.dateRange(
              context,
              volunteeringOpportunities[i].from,
              volunteeringOpportunities[i].to,
            ),
            onTap: () => context.push(
              AppRoutes.volunteeringOpportunityDetailsPath(
                volunteeringOpportunities[i].id,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
