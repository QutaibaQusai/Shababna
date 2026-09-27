import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';

class NewsDetailsSkeleton extends StatelessWidget {
  const NewsDetailsSkeleton({super.key});

  static const _imageHeight = 260.0;
  static const _bodyLines = 6;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(height: _imageHeight, color: context.colorScheme.surface),
            Padding(
              padding: EdgeInsets.all(AppSpacing.screenMargin),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('21 September 2026'),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    'Shababna volunteers plant trees across the kingdom',
                    style: context.textTheme.headlineSmall,
                  ),
                  SizedBox(height: AppSpacing.md),
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
