import 'package:flutter/material.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/shared/widgets/app_network_image.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';

class HomeListTile extends StatelessWidget {
  const HomeListTile({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.meta,
    required this.onTap,
  });

  final String imageUrl;
  final String title;
  final String? subtitle;
  final String meta;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final subtitle = this.subtitle;
    final thumbnail = AppSizes.compactThumbnailSize;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenMargin),
      child: Material(
        color: colors.surface,
        borderRadius: AppRadius.mdRadius,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.xs),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: AppRadius.smRadius,
                  child: SizedBox.square(
                    dimension: thumbnail,
                    child: AppNetworkImage(url: imageUrl, size: thumbnail / 2),
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      if (subtitle != null && subtitle.isNotEmpty) ...[
                        SizedBox(height: AppSpacing.xxs),
                        Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: context.textTheme.bodySmall?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                      SizedBox(height: AppSpacing.xxs),
                      Text(
                        meta,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.labelSmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
