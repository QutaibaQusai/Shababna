import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';

class SearchResultsSkeleton extends StatelessWidget {
  const SearchResultsSkeleton({super.key});

  static const _placeholderCount = 8;

  @override
  Widget build(BuildContext context) {
    final thumbnailSize = AppSizes.compactThumbnailSize;

    return Skeletonizer(
      enabled: true,
      child: ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.all(AppSpacing.screenMargin),
        itemCount: _placeholderCount,
        separatorBuilder: (_, _) => SizedBox(height: AppSpacing.sm),
        itemBuilder: (context, index) => Row(
          children: [
            Bone.square(size: thumbnailSize, borderRadius: AppRadius.mdRadius),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Bone.text(words: 4),
                  SizedBox(height: AppSpacing.xs),
                  const Bone.text(words: 2),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
