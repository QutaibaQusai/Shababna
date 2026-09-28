import 'package:flutter/material.dart';

import '../../../../../core/shared/views/media_viewer/app_media.dart';
import '../../../../../core/shared/views/media_viewer/media_video_tile.dart';
import '../../../../../core/shared/views/media_viewer/show_media_browser.dart';
import '../../../../../core/shared/widgets/app_network_image.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';
import 'item_snap_scroll_physics.dart';

class NewsMediaSlider extends StatelessWidget {
  const NewsMediaSlider({super.key, required this.media});

  static const peekWidthFactor = 0.9;
  static const itemAspectRatio = 16 / 10;

  final List<AppMedia> media;

  @override
  Widget build(BuildContext context) {
    final margin = AppSpacing.screenMargin;
    final gap = AppSpacing.sm;
    final isSingle = media.length == 1;

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = isSingle
            ? constraints.maxWidth - margin * 2
            : constraints.maxWidth * peekWidthFactor - margin;

        return SizedBox(
          height: itemWidth / itemAspectRatio,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: margin),
            physics: ItemSnapScrollPhysics(itemExtent: itemWidth + gap),
            itemCount: media.length,
            separatorBuilder: (_, _) => SizedBox(width: gap),
            itemBuilder: (context, index) => SizedBox(
              width: itemWidth,
              child: _SliderItem(
                media: media[index],
                onTap: () => showMediaBrowser(context, media: media),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SliderItem extends StatelessWidget {
  const _SliderItem({required this.media, required this.onTap});

  final AppMedia media;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadius.smRadius,
      child: GestureDetector(
        onTap: onTap,
        child: switch (media) {
          AppImageMedia(:final url) => AppNetworkImage(url: url, size: AppSizes.iconLg * 2),
          AppVideoMedia() => const MediaVideoTile(),
        },
      ),
    );
  }
}
