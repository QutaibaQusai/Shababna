import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';

class SocialMediaSkeleton extends StatelessWidget {
  const SocialMediaSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          6,
          (index) => Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.sm),
            child: Row(
              children: [
                Icon(Icons.circle, size: AppSizes.iconMd, color: context.colorScheme.onSurfaceVariant),
                SizedBox(width: AppSpacing.sm),
                Text('Platform Name Placeholder', style: context.textTheme.bodyLarge),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
