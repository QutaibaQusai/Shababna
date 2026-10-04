import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';

class TaskListSkeleton extends StatelessWidget {
  const TaskListSkeleton({super.key});

  static const _placeholderCount = 6;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(AppSpacing.screenMargin),
        itemCount: _placeholderCount,
        separatorBuilder: (_, _) => SizedBox(height: AppSpacing.sm),
        itemBuilder: (context, index) => Container(
          padding: EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(borderRadius: AppRadius.mdRadius),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Bone.text(words: 3),
              SizedBox(height: AppSpacing.xs),
              const Bone.text(words: 5),
              SizedBox(height: AppSpacing.xs),
              const Bone.text(words: 4),
            ],
          ),
        ),
      ),
    );
  }
}
