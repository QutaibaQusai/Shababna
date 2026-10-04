import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';

class TaskFormSkeleton extends StatelessWidget {
  const TaskFormSkeleton({super.key});

  static const _fieldAspectRatio = 6.0;
  static const _fieldCount = 3;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(AppSpacing.screenMargin),
        children: [
          const Bone.text(words: 3),
          SizedBox(height: AppSpacing.xs),
          const Bone.text(words: 8),
          for (var i = 0; i < _fieldCount; i++) ...[
            SizedBox(height: AppSpacing.lg),
            const Bone.text(words: 4),
            SizedBox(height: AppSpacing.sm),
            AspectRatio(
              aspectRatio: _fieldAspectRatio,
              child: Bone(borderRadius: AppRadius.mdRadius),
            ),
          ],
        ],
      ),
    );
  }
}
