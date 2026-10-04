import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_spacing.dart';

class TaskListSkeleton extends StatelessWidget {
  const TaskListSkeleton({super.key});

  static const _summaryAspectRatio = 3.0;
  static const _cardAspectRatio = 4.0;
  static const _tabCount = 4;
  static const _cardCount = 5;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(AppSpacing.screenMargin),
        children: [
          AspectRatio(
            aspectRatio: _summaryAspectRatio,
            child: Bone(borderRadius: AppRadius.mdRadius),
          ),
          SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              for (var i = 0; i < _tabCount; i++) ...[
                if (i > 0) SizedBox(width: AppSpacing.sm),
                const Bone.text(words: 1),
              ],
            ],
          ),
          for (var i = 0; i < _cardCount; i++) ...[
            SizedBox(height: i == 0 ? AppSpacing.screenMargin : AppSpacing.xs),
            AspectRatio(
              aspectRatio: _cardAspectRatio,
              child: Bone(borderRadius: AppRadius.mdRadius),
            ),
          ],
        ],
      ),
    );
  }
}
