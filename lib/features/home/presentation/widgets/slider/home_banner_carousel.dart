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
  static const peekWidthFactor = 0.84;

  static String heroTag(String slideId) => 'home-slide-$slideId';

  final List<HomeSlide> slides;

  @override
  State<HomeBannerCarousel> createState() => _HomeBannerCarouselState();
}

class _HomeBannerCarouselState extends State<HomeBannerCarousel> {
  static const _autoPlayInterval = Duration(seconds: 5);
  static const _pageDuration = Duration(milliseconds: 450);
  static const _dotDuration = Duration(milliseconds: 250);

  final _controller = ScrollController();
  Timer? _timer;
  int _page = 0;

  bool get _hasMany => widget.slides.length > 1;

  double get _gap => AppSpacing.screenMargin;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_syncPage);
    _startAutoPlay();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  double _cardWidth(double viewportWidth) =>
      _hasMany ? viewportWidth * HomeBannerCarousel.peekWidthFactor : viewportWidth - _gap * 2;

  double get _itemExtent => _cardWidth(MediaQuery.sizeOf(context).width) + _gap;

  void _syncPage() {
    final position = _controller.position;
    final page = position.pixels >= position.maxScrollExtent - 1
        ? widget.slides.length - 1
        : (position.pixels / _itemExtent).round();
    if (page != _page) setState(() => _page = page);
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
    final target = (next * _itemExtent).clamp(0.0, _controller.position.maxScrollExtent);
    _controller.animateTo(target, duration: _pageDuration, curve: Curves.easeOutCubic);
  }

  @override
  Widget build(BuildContext context) {
    final cardWidth = _cardWidth(MediaQuery.sizeOf(context).width);

    return Column(
      children: [
        SizedBox(
          height: cardWidth / HomeBannerCarousel.aspectRatio,
          child: Listener(
            onPointerDown: (_) => _stopAutoPlay(),
            onPointerUp: (_) => _startAutoPlay(),
            onPointerCancel: (_) => _startAutoPlay(),
            child: ListView.separated(
              controller: _controller,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: _gap),
              physics: _hasMany
                  ? _SnapScrollPhysics(itemExtent: cardWidth + _gap)
                  : const NeverScrollableScrollPhysics(),
              itemCount: widget.slides.length,
              separatorBuilder: (_, _) => SizedBox(width: _gap),
              itemBuilder: (context, index) => SizedBox(
                width: cardWidth,
                child: ClipRRect(
                  borderRadius: AppRadius.lgRadius,
                  child: _Slide(slide: widget.slides[index]),
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

class _SnapScrollPhysics extends ScrollPhysics {
  const _SnapScrollPhysics({required this.itemExtent, super.parent});

  static const _halfItem = 0.5;

  final double itemExtent;

  @override
  _SnapScrollPhysics applyTo(ScrollPhysics? ancestor) =>
      _SnapScrollPhysics(itemExtent: itemExtent, parent: buildParent(ancestor));

  @override
  Simulation? createBallisticSimulation(ScrollMetrics position, double velocity) {
    final atStart = velocity <= 0 && position.pixels <= position.minScrollExtent;
    final atEnd = velocity >= 0 && position.pixels >= position.maxScrollExtent;
    if (atStart || atEnd) return super.createBallisticSimulation(position, velocity);

    final tolerance = toleranceFor(position);
    var item = position.pixels / itemExtent;
    if (velocity < -tolerance.velocity) item -= _halfItem;
    if (velocity > tolerance.velocity) item += _halfItem;
    final target = (item.roundToDouble() * itemExtent).clamp(
      position.minScrollExtent,
      position.maxScrollExtent,
    );
    if (target == position.pixels) return null;
    return ScrollSpringSimulation(spring, position.pixels, target, velocity, tolerance: tolerance);
  }

  @override
  bool get allowImplicitScrolling => false;
}
