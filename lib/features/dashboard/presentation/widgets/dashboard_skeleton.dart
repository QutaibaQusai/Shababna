import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';

class DashboardSkeleton extends StatelessWidget {
  const DashboardSkeleton({super.key});

  static const _heroAspectRatio = 1.9;
  static const _eventsAspectRatio = 1.9;
  static const _statAspectRatio = 1.2;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(AppSpacing.screenMargin),
        children: [
          const Bone.text(words: 2),
          SizedBox(height: AppSpacing.xs),
          const Bone.text(words: 5),
          SizedBox(height: AppSpacing.md),
          AspectRatio(
            aspectRatio: _heroAspectRatio,
            child: Bone(borderRadius: AppRadius.lgRadius),
          ),
          SizedBox(height: AppSpacing.sm),
          AspectRatio(
            aspectRatio: _eventsAspectRatio,
            child: Bone(borderRadius: AppRadius.lgRadius),
          ),
          SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: _statAspectRatio,
                  child: Bone(borderRadius: AppRadius.lgRadius),
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AspectRatio(
                  aspectRatio: _statAspectRatio,
                  child: Bone(borderRadius: AppRadius.lgRadius),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
