import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:video_player/video_player.dart';

import '../../extensions/context_extensions.dart';
import '../../theme/app_sizes.dart';
import '../../theme/app_spacing.dart';

class AppVideoPlayer extends StatefulWidget {
  const AppVideoPlayer({super.key, required this.url, required this.isActive});

  final String url;
  final bool isActive;

  @override
  State<AppVideoPlayer> createState() => _AppVideoPlayerState();
}

class _AppVideoPlayerState extends State<AppVideoPlayer> {
  static const _placeholderAspectRatio = 16 / 9;

  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool _hasFailed = false;
  int _initToken = 0;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void didUpdateWidget(AppVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _disposeControllers();
      _hasFailed = false;
      _initialize();
    } else if (oldWidget.isActive && !widget.isActive) {
      _videoController?.pause();
    }
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  void _disposeControllers() {
    _initToken++;
    _chewieController?.dispose();
    _chewieController = null;
    _videoController?.dispose();
    _videoController = null;
  }

  Future<void> _initialize() async {
    final token = _initToken;
    final controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));

    try {
      await controller.initialize();
    } catch (_) {
      await controller.dispose();
      if (mounted && token == _initToken) setState(() => _hasFailed = true);
      return;
    }

    if (!mounted || token != _initToken) {
      await controller.dispose();
      return;
    }

    final colorScheme = context.colorScheme;
    setState(() {
      _videoController = controller;
      _chewieController = ChewieController(
        videoPlayerController: controller,
        aspectRatio: controller.value.aspectRatio,
        autoPlay: false,
        looping: false,
        allowFullScreen: false,
        allowPlaybackSpeedChanging: false,
        showOptions: false,
        materialProgressColors: ChewieProgressColors(
          playedColor: colorScheme.primary,
          handleColor: colorScheme.primary,
          bufferedColor: colorScheme.primary.withValues(alpha: 0.3),
          backgroundColor: colorScheme.onSurface.withValues(alpha: 0.2),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final chewieController = _chewieController;

    if (_hasFailed) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              LucideIcons.videoOff,
              size: AppSizes.iconLg,
              color: context.colorScheme.onSurfaceVariant,
            ),
            SizedBox(height: AppSpacing.xs),
            Text(
              context.l10n.somethingWentWrong,
              style: context.textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    if (chewieController == null) {
      return Center(
        child: AspectRatio(
          aspectRatio: _placeholderAspectRatio,
          child: Skeletonizer.zone(child: Bone(width: double.infinity, height: double.infinity)),
        ),
      );
    }

    return Semantics(
      label: context.l10n.mediaPlayVideo,
      child: Chewie(controller: chewieController),
    );
  }
}
