import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';
import 'event_card.dart';

class EventsListSkeleton extends StatelessWidget {
  const EventsListSkeleton({super.key});

  static const _placeholderCount = 8;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: MasonryGridView.count(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(AppSpacing.screenMargin),
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.sm,
        crossAxisSpacing: AppSpacing.sm,
        itemCount: _placeholderCount,
        itemBuilder: (context, index) => AspectRatio(
          aspectRatio: EventCard.aspectRatioAt(index),
          child: Bone(borderRadius: AppRadius.lgRadius),
        ),
      ),
    );
  }
}
