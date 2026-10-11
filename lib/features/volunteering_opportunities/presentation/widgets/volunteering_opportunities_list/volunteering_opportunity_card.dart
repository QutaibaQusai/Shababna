import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/shared/widgets/app_network_image.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/repositories/volunteering_opportunities_repository.dart';
import '../shared/volunteering_opportunity_date_range.dart';

class VolunteeringOpportunityCard extends StatelessWidget {
  const VolunteeringOpportunityCard({
    super.key,
    required this.volunteeringOpportunity,
    required this.isTall,
  });

  static const _tallAspectRatio = 0.55;
  static const _shortAspectRatio = 1.0;
  static const _scrimStops = [0.35, 1.0];
  static const _scrim = [Colors.transparent, Color(0xE6000000)];
  static const _muted = Color(0xCCFFFFFF);

  static bool isTallAt(int index) => index % 4 == 0 || index % 4 == 3;

  static double aspectRatioAt(int index) =>
      isTallAt(index) ? _tallAspectRatio : _shortAspectRatio;

  final VolunteeringOpportunitySummary volunteeringOpportunity;
  final bool isTall;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    return Material(
      color: Colors.black,
      borderRadius: AppRadius.lgRadius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(
          AppRoutes.volunteeringOpportunityDetailsPath(volunteeringOpportunity.id),
        ),
        child: AspectRatio(
          aspectRatio: isTall ? _tallAspectRatio : _shortAspectRatio,
          child: Stack(
            fit: StackFit.expand,
            children: [
              AppNetworkImage(url: volunteeringOpportunity.imageUrl, size: AppSizes.iconLg * 2),
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
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                    AppSpacing.xs,
                    AppSpacing.sm,
                    AppSpacing.sm,
                    AppSpacing.xs,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        volunteeringOpportunity.type.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.labelMedium?.copyWith(color: _muted),
                      ),
                      SizedBox(height: AppSpacing.xxs),
                      Text(
                        volunteeringOpportunity.title(context.isArabic),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(height: AppSpacing.xxs),
                      Text(
                        volunteeringOpportunityDateRange(
                          context,
                          volunteeringOpportunity.from,
                          volunteeringOpportunity.to,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.labelSmall?.copyWith(color: _muted),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
