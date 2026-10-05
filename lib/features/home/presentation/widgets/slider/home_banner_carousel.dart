import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/routes/app_routes.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../domain/repositories/home_repository.dart';
import '../shared/home_authorized_image.dart';

class HomeBannerCarousel extends StatefulWidget {
  const HomeBannerCarousel({super.key, required this.slides});

  static const aspectRatio = 16 / 9;

  static String heroTag(String slideId) => 'home-slide-$slideId';

  final List<HomeSlide> slides;

  @override
  State<HomeBannerCarousel> createState() => _HomeBannerCarouselState();
}

class _HomeBannerCarouselState extends State<HomeBannerCarousel> {
  static const _autoPlayInterval = Duration(seconds: 5);
  static const _pageDuration = Duration(milliseconds: 450);
  static const _dotDuration = Duration(milliseconds: 250);

  final _controller = PageController();
  Timer? _timer;
  int _page = 0;

  bool get _hasMany => widget.slides.length > 1;

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _startAutoPlay() {
    _timer?.cancel();
    if (!_hasMany) return;
    _timer = Timer.periodic(_autoPlayInterval, (_) => _next());
  }

  void _stopAutoPlay() => _timer?.cancel();

  void _next() {
    if (!_controller.hasClients) return;
    final next = (_page + 1) % widget.slides.length;
    _controller.animateToPage(next, duration: _pageDuration, curve: Curves.easeOutCubic);
  }

  @override
  Widget build(BuildContext context) {
    final margin = AppSpacing.screenMargin;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: margin),
          child: AspectRatio(
            aspectRatio: HomeBannerCarousel.aspectRatio,
            child: Listener(
              onPointerDown: (_) => _stopAutoPlay(),
              onPointerUp: (_) => _startAutoPlay(),
              onPointerCancel: (_) => _startAutoPlay(),
              child: ClipRRect(
                borderRadius: AppRadius.lgRadius,
                child: PageView.builder(
                  controller: _controller,
                  itemCount: widget.slides.length,
                  onPageChanged: (page) => setState(() => _page = page),
                  itemBuilder: (context, index) => _Slide(slide: widget.slides[index]),
                ),
              ),
            ),
          ),
        ),
        if (_hasMany) ...[
          SizedBox(height: AppSpacing.xs),
          _Dots(count: widget.slides.length, current: _page, duration: _dotDuration),
        ],
      ],
    );
  }
}

class _Slide extends StatelessWidget {
  const _Slide({required this.slide});

  static const _scrimStops = [0.4, 1.0];
  static const _scrim = [Colors.transparent, Color(0xD9000000)];
  static const _muted = Color(0xCCFFFFFF);

  final HomeSlide slide;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.isArabic;
    final title = slide.title(isArabic).trim();
    final description = slide.description(isArabic).trim();

    return GestureDetector(
      onTap: () => context.push(AppRoutes.homeSlidePath(slide.id), extra: slide),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Hero(
            tag: HomeBannerCarousel.heroTag(slide.id),
            child: HomeAuthorizedImage(url: slide.imageUrl),
          ),
          if (title.isNotEmpty || description.isNotEmpty) ...[
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: _scrimStops,
                  colors: _scrim,
                ),
              ),
            ),
            PositionedDirectional(
              start: AppSpacing.sm,
              end: AppSpacing.sm,
              bottom: AppSpacing.sm,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title.isNotEmpty)
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  if (description.isNotEmpty) ...[
                    SizedBox(height: AppSpacing.xxs),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.labelMedium?.copyWith(color: _muted),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.current, required this.duration});

  final int count;
  final int current;
  final Duration duration;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var index = 0; index < count; index++) ...[
          if (index > 0) SizedBox(width: AppSpacing.xxs),
          AnimatedContainer(
            duration: duration,
            curve: Curves.easeOut,
            width: index == current
                ? AppSizes.onboardingDotActiveWidth
                : AppSizes.onboardingDotSize,
            height: AppSizes.onboardingDotHeight,
            decoration: BoxDecoration(
              color: index == current ? colors.primary : colors.outlineVariant,
              borderRadius: AppRadius.pillRadius,
            ),
          ),
        ],
      ],
    );
  }
}
