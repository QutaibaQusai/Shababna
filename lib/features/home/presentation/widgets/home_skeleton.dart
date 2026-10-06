import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import 'slider/home_banner_carousel.dart';
import 'whats_on/home_date_strip.dart';
import 'suggested/home_events_row.dart';

class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key, required this.isMember});

  static const _cardCount = 3;
  static const _tileCount = 2;
  static const _newsCount = 3;

  final bool isMember;

  @override
  Widget build(BuildContext context) {
    final margin = EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin);
    final cardWidth = HomeEventsRow.cardWidth(context);
    final bannerWidth = MediaQuery.sizeOf(context).width * HomeBannerCarousel.peekWidthFactor;
    final tileHeight = AppSizes.compactThumbnailSize + AppSpacing.xs * 2;

    Widget header() => Padding(padding: margin, child: const Bone.text(words: 2));

    Widget tiles(int count) => Column(
      children: [
        for (var i = 0; i < count; i++) ...[
          if (i > 0) SizedBox(height: AppSpacing.xs),
          Padding(
            padding: margin,
            child: Bone(height: tileHeight, borderRadius: AppRadius.mdRadius),
          ),
        ],
      ],
    );

    return Skeletonizer(
      enabled: true,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(top: AppSpacing.sm),
        children: [
          Padding(
            padding: margin,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Bone.text(words: 2),
                SizedBox(height: AppSpacing.xs),
                const Bone.text(words: 3),
                if (!isMember) ...[
                  SizedBox(height: AppSpacing.sm),
                  Bone(height: AppSizes.buttonHeight, borderRadius: AppRadius.mdRadius),
                ],
              ],
            ),
          ),
          if (isMember) ...[
            SizedBox(height: AppSpacing.md),
            Padding(
              padding: EdgeInsetsDirectional.only(start: AppSpacing.screenMargin),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Bone(
                  width: bannerWidth,
                  height: bannerWidth / HomeBannerCarousel.aspectRatio,
                  borderRadius: AppRadius.lgRadius,
                ),
              ),
            ),
            SizedBox(height: AppSpacing.md),
            Padding(
              padding: margin,
              child: Row(
                children: [
                  Bone.circle(size: AppSizes.homeImpactRingRadius * 2),
                  SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Bone.text(words: 1),
                        SizedBox(height: AppSpacing.xxs),
                        const Bone.text(words: 3),
                        SizedBox(height: AppSpacing.xxs),
                        const Bone.text(words: 5),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
          SizedBox(height: AppSpacing.md),
          header(),
          SizedBox(height: AppSpacing.sm),
          SizedBox(
            height: cardWidth / HomeEventsRow.cardAspectRatio,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              padding: margin,
              itemCount: _cardCount,
              separatorBuilder: (_, _) => SizedBox(width: AppSpacing.xs),
              itemBuilder: (_, _) => Bone(width: cardWidth, borderRadius: AppRadius.lgRadius),
            ),
          ),
          SizedBox(height: AppSpacing.md),
          header(),
          SizedBox(height: AppSpacing.sm),
          SizedBox(
            height: AppSizes.homeDateCellHeight,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              padding: margin,
              itemCount: HomeDateStrip.dayCount,
              separatorBuilder: (_, _) => SizedBox(width: AppSpacing.xs),
              itemBuilder: (_, _) =>
                  Bone(width: AppSizes.homeDateCellWidth, borderRadius: AppRadius.mdRadius),
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          tiles(_tileCount),
          SizedBox(height: AppSpacing.md),
          header(),
          SizedBox(height: AppSpacing.sm),
          tiles(_newsCount),
        ],
      ),
    );
  }
}
