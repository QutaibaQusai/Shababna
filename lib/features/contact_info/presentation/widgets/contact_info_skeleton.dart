import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';
import 'contact_location_map.dart';

class ContactInfoSkeleton extends StatelessWidget {
  const ContactInfoSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...List.generate(
            5,
            (index) => Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.sm),
              child: Row(
                children: [
                  Icon(
                    Icons.circle,
                    size: AppSizes.iconMd,
                    color: context.colorScheme.onSurfaceVariant,
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Label Placeholder',
                          style: context.textTheme.bodySmall?.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(height: AppSpacing.xxs),
                        Text('Value placeholder text', style: context.textTheme.bodyLarge),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Bone(
            width: double.infinity,
            height: ContactLocationMap.height,
            borderRadius: AppRadius.lgRadius,
          ),
        ],
      ),
    );
  }
}
