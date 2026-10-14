import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';

class NotificationsListSkeleton extends StatelessWidget {
  const NotificationsListSkeleton({super.key});

  static const _tileCount = 8;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
        itemCount: _tileCount,
        separatorBuilder: (_, _) => Divider(
          height: 1,
          indent: AppSpacing.screenMargin,
          endIndent: AppSpacing.screenMargin,
        ),
        itemBuilder: (_, _) => Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.screenMargin,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Bone.square(size: AppSizes.iconMd),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Expanded(child: Bone.text(words: 3)),
                        Bone.text(words: 1),
                      ],
                    ),
                    SizedBox(height: AppSpacing.xs),
                    const Bone.multiText(lines: 2),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
