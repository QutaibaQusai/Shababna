import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';

class EventsListSkeleton extends StatelessWidget {
  const EventsListSkeleton({super.key});

  static const _ratios = [3 / 4, 1.0, 1.0, 3 / 4, 3 / 4, 1.0, 1.0, 3 / 4];

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: MasonryGridView.count(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(AppSpacing.screenMargin),
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.sm,
        itemCount: _ratios.length,
        itemBuilder: (context, index) => AspectRatio(
          aspectRatio: _ratios[index],
          child: Bone(borderRadius: AppRadius.mdRadius),
        ),
      ),
    );
  }
}
