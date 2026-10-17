import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../extensions/context_extensions.dart';
import '../../../theme/app_sizes.dart';
import '../../../theme/app_spacing.dart';
import '../../widgets/app_app_bar.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_network_image.dart';
import '../../widgets/app_video_player.dart';
import 'app_media.dart';
import 'media_slide_up_route.dart';
import '../../widgets/app_bottom_safe_area.dart';

class MediaViewerPage extends StatefulWidget {
  const MediaViewerPage({super.key, required this.media, required this.initialIndex});

  final List<AppMedia> media;
  final int initialIndex;

  static Future<void> show(
    BuildContext context, {
    required List<AppMedia> media,
    required int initialIndex,
  }) {
    return Navigator.of(context)
        .push(mediaSlideUpRoute(MediaViewerPage(media: media, initialIndex: initialIndex)));
  }

  @override
  State<MediaViewerPage> createState() => _MediaViewerPageState();
}

class _MediaViewerPageState extends State<MediaViewerPage> {
  late final _controller = PageController(initialPage: widget.initialIndex);
  late int _page = widget.initialIndex;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final count = widget.media.length;

    return Scaffold(
      appBar: AppAppBar(
        title: count > 1 ? '${_page + 1} / $count' : '',
        leadingIcon: LucideIcons.x,
        onBack: () => Navigator.of(context).pop(),
      ),
      body: AppBottomSafeArea(
        child: PageView.builder(
          controller: _controller,
          itemCount: count,
          onPageChanged: (page) => setState(() => _page = page),
          itemBuilder: (context, index) => switch (widget.media[index]) {
            AppImageMedia(:final url) => InteractiveViewer(
              child: Center(
                child: AppNetworkImage(url: url, fit: BoxFit.contain, size: AppSizes.iconLg * 2),
              ),
            ),
            AppVideoMedia(:final url, isExternal: false) => AppVideoPlayer(
              url: url,
              isActive: index == _page,
            ),
            AppVideoMedia(:final url, isExternal: true) => _ExternalVideo(url: url),
          },
        ),
      ),
    );
  }
}

class _ExternalVideo extends StatelessWidget {
  const _ExternalVideo({required this.url});

  final String url;

  Future<void> _open() async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Semantics(
            button: true,
            label: context.l10n.mediaPlayVideo,
            child: InkWell(
              onTap: _open,
              customBorder: const CircleBorder(),
              child: Container(
                width: AppSizes.iconLg * 2.5,
                height: AppSizes.iconLg * 2.5,
                decoration: BoxDecoration(
                  color: context.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  LucideIcons.play,
                  size: AppSizes.iconLg,
                  color: context.colorScheme.onPrimary,
                ),
              ),
            ),
          ),
          SizedBox(height: AppSpacing.md),
          AppButton.text(label: context.l10n.mediaOpenVideo, onPressed: _open),
        ],
      ),
    );
  }
}
