import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../core/theme/app_spacing.dart';

class TaskDetailsSkeleton extends StatelessWidget {
  const TaskDetailsSkeleton({super.key});

  static const _sections = [(lines: 4, words: 6), (lines: 3, words: 4), (lines: 2, words: 5)];

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(AppSpacing.screenMargin),
        children: [
          const Bone.text(words: 4),
          SizedBox(height: AppSpacing.xs),
          const Bone.text(words: 3),
          for (final section in _sections) ...[
            SizedBox(height: AppSpacing.md),
            const Bone.text(words: 2),
            SizedBox(height: AppSpacing.sm),
            for (var i = 0; i < section.lines; i++) ...[
              if (i > 0) SizedBox(height: AppSpacing.xs),
              Bone.text(words: section.words),
            ],
          ],
        ],
      ),
    );
  }
}
