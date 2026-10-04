import 'package:flutter/material.dart';

import '../../theme/app_radius.dart';
import '../../theme/app_sizes.dart';
import '../../theme/app_spacing.dart';
import '../views/media_viewer/app_media.dart';
import '../views/media_viewer/media_video_tile.dart';
import '../views/media_viewer/show_media_browser.dart';
import 'app_network_image.dart';

class AppMediaSlider extends StatelessWidget {
  const AppMediaSlider({super.key, required this.media});

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
            physics: _SnapScrollPhysics(itemExtent: itemWidth + gap),
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

class _SnapScrollPhysics extends ScrollPhysics {
  const _SnapScrollPhysics({required this.itemExtent, super.parent});

  final double itemExtent;

  @override
  _SnapScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return _SnapScrollPhysics(itemExtent: itemExtent, parent: buildParent(ancestor));
  }

  double _targetPixels(ScrollMetrics position, Tolerance tolerance, double velocity) {
    var item = position.pixels / itemExtent;
    if (velocity < -tolerance.velocity) {
      item -= 0.5;
    } else if (velocity > tolerance.velocity) {
      item += 0.5;
    }
    return (item.roundToDouble() * itemExtent).clamp(
      position.minScrollExtent,
      position.maxScrollExtent,
    );
  }

  @override
  Simulation? createBallisticSimulation(ScrollMetrics position, double velocity) {
    final atStart = velocity <= 0 && position.pixels <= position.minScrollExtent;
    final atEnd = velocity >= 0 && position.pixels >= position.maxScrollExtent;
    if (atStart || atEnd) return super.createBallisticSimulation(position, velocity);

    final tolerance = toleranceFor(position);
    final target = _targetPixels(position, tolerance, velocity);
    if (target == position.pixels) return null;
    return ScrollSpringSimulation(spring, position.pixels, target, velocity, tolerance: tolerance);
  }

  @override
  bool get allowImplicitScrolling => false;
}
