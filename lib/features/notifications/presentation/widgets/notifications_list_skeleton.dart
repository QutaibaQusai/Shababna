import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';

class NotificationsListSkeleton extends StatelessWidget {
  const NotificationsListSkeleton({super.key});

  static const _tileAspectRatio = 4.2;
  static const _tileCount = 7;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(AppSpacing.screenMargin),
        itemCount: _tileCount,
        separatorBuilder: (_, _) => SizedBox(height: AppSpacing.xs),
        itemBuilder: (_, _) => AspectRatio(
          aspectRatio: _tileAspectRatio,
          child: Bone(borderRadius: AppRadius.lgRadius),
        ),
      ),
    );
  }
}
