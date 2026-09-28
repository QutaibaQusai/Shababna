import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../extensions/context_extensions.dart';
import '../../../theme/app_sizes.dart';
import '../../../theme/app_spacing.dart';
import '../../widgets/app_app_bar.dart';
import '../../widgets/app_network_image.dart';
import 'app_media.dart';
import 'media_slide_up_route.dart';
import 'media_video_tile.dart';
import 'media_viewer_page.dart';

class MediaGalleryPage extends StatelessWidget {
  const MediaGalleryPage({super.key, required this.media});

  static const _itemAspectRatio = 4 / 3;

  final List<AppMedia> media;

  static Future<void> show(BuildContext context, {required List<AppMedia> media}) {
    return Navigator.of(context).push(mediaSlideUpRoute(MediaGalleryPage(media: media)));
  }

  @override
  Widget build(BuildContext context) {
    final hasVideos = media.any((item) => item is AppVideoMedia);

    return Scaffold(
      appBar: AppAppBar(
        title: hasVideos
            ? context.l10n.mediaGalleryTitle
            : context.l10n.mediaPhotosCount(media.length),
        leadingIcon: LucideIcons.x,
        onBack: () => Navigator.of(context).pop(),
      ),
      body: ListView.separated(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
        itemCount: media.length,
        separatorBuilder: (_, _) => SizedBox(height: AppSpacing.sm),
        itemBuilder: (context, index) => GestureDetector(
          onTap: () => MediaViewerPage.show(context, media: media, initialIndex: index),
          child: AspectRatio(
            aspectRatio: _itemAspectRatio,
            child: switch (media[index]) {
              AppImageMedia(:final url) => AppNetworkImage(url: url, size: AppSizes.iconLg * 2),
              AppVideoMedia() => const MediaVideoTile(),
            },
          ),
        ),
      ),
    );
  }
}
