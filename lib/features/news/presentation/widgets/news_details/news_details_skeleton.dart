import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';
import 'news_media_slider.dart';

class NewsDetailsSkeleton extends StatelessWidget {
  const NewsDetailsSkeleton({super.key});

  static const _bodyLines = 6;

  @override
  Widget build(BuildContext context) {
    final margin = EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin);

    return Skeletonizer(
      enabled: true,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: margin,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Bone.circle(size: AppSizes.iconMd),
                      SizedBox(width: AppSpacing.xs),
                      const Text('21 September 2026'),
                    ],
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Text(
                    'Shababna volunteers plant trees across the kingdom',
                    style: context.textTheme.headlineSmall,
                  ),
                ],
              ),
            ),
            SizedBox(height: AppSpacing.md),
            LayoutBuilder(
              builder: (context, constraints) {
                final width =
                    constraints.maxWidth * NewsMediaSlider.peekWidthFactor - AppSpacing.screenMargin;
                return Padding(
                  padding: EdgeInsetsDirectional.only(start: AppSpacing.screenMargin),
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Bone(
                      width: width,
                      height: width / NewsMediaSlider.itemAspectRatio,
                      borderRadius: AppRadius.smRadius,
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: EdgeInsets.all(AppSpacing.screenMargin),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var i = 0; i < _bodyLines; i++) ...[
                    const Text(
                      'More than two hundred volunteers spent the weekend restoring green areas.',
                    ),
                    SizedBox(height: AppSpacing.xs),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
