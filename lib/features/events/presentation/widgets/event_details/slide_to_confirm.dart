import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';

class SlideToConfirm extends StatefulWidget {
  const SlideToConfirm({
    super.key,
    required this.label,
    required this.onConfirmed,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback onConfirmed;
  final bool isLoading;

  @override
  State<SlideToConfirm> createState() => _SlideToConfirmState();
}

class _SlideToConfirmState extends State<SlideToConfirm> with SingleTickerProviderStateMixin {
  static const _confirmThreshold = 0.85;
  static const _settleDuration = Duration(milliseconds: 250);
  static const _fillAlpha = 0.2;
  static const _labelFadeSpeed = 1.5;

  late final AnimationController _progress = AnimationController(
    vsync: this,
    duration: _settleDuration,
  );
  bool _confirmed = false;

  @override
  void didUpdateWidget(SlideToConfirm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isLoading && !widget.isLoading) {
      _confirmed = false;
      _progress.animateTo(0, curve: Curves.easeOutCubic);
    }
  }

  @override
  void dispose() {
    _progress.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails details, double travel, bool isRtl) {
    if (_confirmed || widget.isLoading || travel <= 0) return;
    final delta = isRtl ? -details.primaryDelta! : details.primaryDelta!;
    _progress.value = (_progress.value + delta / travel).clamp(0.0, 1.0);
  }

  void _onDragEnd() {
    if (_confirmed || widget.isLoading) return;
    if (_progress.value >= _confirmThreshold) {
      _confirm();
    } else {
      _progress.animateTo(0, curve: Curves.easeOutCubic);
    }
  }

  void _confirm() {
    _confirmed = true;
    HapticFeedback.mediumImpact();
    _progress.animateTo(1, curve: Curves.easeOutCubic);
    widget.onConfirmed();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final height = AppSizes.slideToConfirmHeight;
    final inset = AppSpacing.xxs;
    final thumbSize = height - inset * 2;

    return Semantics(
      button: true,
      label: widget.label,
      onTap: widget.isLoading || _confirmed ? null : _confirm,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final travel = constraints.maxWidth - thumbSize - inset * 2;

          return GestureDetector(
            onHorizontalDragUpdate: (details) => _onDragUpdate(details, travel, isRtl),
            onHorizontalDragEnd: (_) => _onDragEnd(),
            child: Container(
              height: height,
              padding: EdgeInsets.all(inset),
              decoration: BoxDecoration(color: colors.primary, borderRadius: AppRadius.mdRadius),
              child: AnimatedBuilder(
                animation: _progress,
                builder: (context, _) {
                  final offset = travel * _progress.value;

                  return Stack(
                    alignment: AlignmentDirectional.centerStart,
                    children: [
                      PositionedDirectional(
                        start: 0,
                        top: 0,
                        bottom: 0,
                        width: thumbSize + offset,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: colors.onPrimary.withValues(alpha: _fillAlpha),
                            borderRadius: AppRadius.mdRadius,
                          ),
                        ),
                      ),
                      Center(
                        child: Opacity(
                          opacity: (1 - _progress.value * _labelFadeSpeed).clamp(0.0, 1.0),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: thumbSize),
                            child: Text(
                              widget.label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.textTheme.titleSmall?.copyWith(
                                color: colors.onPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                      PositionedDirectional(
                        start: offset,
                        child: _Thumb(size: thumbSize, isRtl: isRtl),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb({required this.size, required this.isRtl});

  final double size;
  final bool isRtl;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: colors.onPrimary, borderRadius: AppRadius.smRadius),
      alignment: Alignment.center,
      child: Icon(
        isRtl ? LucideIcons.chevronsLeft : LucideIcons.chevronsRight,
        size: AppSizes.iconMd,
        color: colors.primary,
      ),
    );
  }
}
