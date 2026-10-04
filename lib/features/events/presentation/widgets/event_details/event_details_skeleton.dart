import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../core/shared/widgets/app_media_slider.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';

class EventDetailsSkeleton extends StatelessWidget {
  const EventDetailsSkeleton({super.key});

  static const _sectionLines = [5, 4, 3];

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
          SizedBox(height: AppSpacing.sm),
          AspectRatio(
            aspectRatio: AppMediaSlider.itemAspectRatio,
            child: Bone(borderRadius: AppRadius.smRadius),
          ),
          for (final lines in _sectionLines) ...[
            SizedBox(height: AppSpacing.md),
            const Bone.text(words: 2),
            SizedBox(height: AppSpacing.sm),
            for (var i = 0; i < lines; i++) ...[
              if (i > 0) SizedBox(height: AppSpacing.xs),
              const Bone.text(words: 6),
            ],
          ],
        ],
      ),
    );
  }
}
