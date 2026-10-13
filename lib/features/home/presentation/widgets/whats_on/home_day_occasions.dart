import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/repositories/home_repository.dart';

class HomeDayOccasions extends StatelessWidget {
  const HomeDayOccasions({super.key, required this.occasions});

  static const _duration = Duration(milliseconds: 250);

  final List<HomeOccasion> occasions;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: _duration,
      curve: Curves.easeOut,
      alignment: AlignmentDirectional.topCenter,
      child: occasions.isEmpty
          ? const SizedBox(width: double.infinity)
          : Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.screenMargin,
                0,
                AppSpacing.screenMargin,
                AppSpacing.sm,
              ),
              child: Column(
                children: [
                  for (var i = 0; i < occasions.length; i++) ...[
                    if (i > 0) SizedBox(height: AppSpacing.xs),
                    _OccasionCard(occasion: occasions[i]),
                  ],
                ],
              ),
            ),
    );
  }
}

class _OccasionCard extends StatelessWidget {
  const _OccasionCard({required this.occasion});

  final HomeOccasion occasion;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.isArabic;
    final description = occasion.description(isArabic);

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            occasion.title(isArabic),
            style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          if (description.isNotEmpty) ...[
            SizedBox(height: AppSpacing.xxs),
            Text(
              description,
              style: context.textTheme.bodySmall?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
