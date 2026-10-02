import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/shared/widgets/app_network_image.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';

class SearchResultTile extends StatelessWidget {
  const SearchResultTile({
    super.key,
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.trailing,
  });

  final Widget leading;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final trailing = this.trailing;

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.mdRadius,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.xxs),
          child: Row(
            children: [
              leading,
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
                    SizedBox(height: AppSpacing.xxs),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.labelMedium?.copyWith(
                        color: context.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (trailing != null) ...[
                      SizedBox(height: AppSpacing.xxs),
                      trailing,
                    ],
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

class SearchImageThumbnail extends StatelessWidget {
  const SearchImageThumbnail({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    final size = AppSizes.compactThumbnailSize;

    return ClipRRect(
      borderRadius: AppRadius.mdRadius,
      child: SizedBox.square(
        dimension: size,
        child: AppNetworkImage(url: url, size: size / 2),
      ),
    );
  }
}

class SearchIconThumbnail extends StatelessWidget {
  const SearchIconThumbnail({super.key, required this.icon});

  static const _tintAlpha = 0.1;

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final primary = context.colorScheme.primary;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: primary.withValues(alpha: _tintAlpha),
        borderRadius: AppRadius.mdRadius,
      ),
      child: SizedBox.square(
        dimension: AppSizes.compactThumbnailSize,
        child: Icon(icon, size: AppSizes.iconMd, color: primary),
      ),
    );
  }
}
