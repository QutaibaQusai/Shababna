import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';

class TaskDetailsSkeleton extends StatelessWidget {
  const TaskDetailsSkeleton({super.key});

  static const _bannerAspectRatio = 5.0;
  static const _infoRowCount = 3;
  static const _sectionLines = [4, 3];

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(AppSpacing.screenMargin),
        children: [
          AspectRatio(
            aspectRatio: _bannerAspectRatio,
            child: Bone(borderRadius: AppRadius.mdRadius),
          ),
          SizedBox(height: AppSpacing.md),
          const Bone.text(words: 4),
          SizedBox(height: AppSpacing.xs),
          const Bone.text(words: 3),
          for (var i = 0; i < _infoRowCount; i++) ...[
            SizedBox(height: AppSpacing.sm),
            const Bone.text(words: 4),
          ],
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
