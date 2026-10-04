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
    setState(() => _confirmed = true);
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
                        child: _Thumb(
                          size: thumbSize,
                          isRtl: isRtl,
                          isConfirmed: _confirmed || _progress.value >= _confirmThreshold,
                        ),
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
  const _Thumb({required this.size, required this.isRtl, required this.isConfirmed});

  static const _iconSwapDuration = Duration(milliseconds: 300);
  static const _iconStartTurns = -0.25;

  final double size;
  final bool isRtl;
  final bool isConfirmed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final icon = isConfirmed
        ? LucideIcons.check
        : (isRtl ? LucideIcons.chevronsLeft : LucideIcons.chevronsRight);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: colors.onPrimary, borderRadius: AppRadius.smRadius),
      alignment: Alignment.center,
      child: AnimatedSwitcher(
        duration: _iconSwapDuration,
        switchInCurve: Curves.easeOutBack,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (child, animation) => RotationTransition(
          turns: Tween(begin: _iconStartTurns, end: 0.0).animate(animation),
          child: ScaleTransition(scale: animation, child: child),
        ),
        child: Icon(icon, key: ValueKey(icon), size: AppSizes.iconMd, color: colors.primary),
      ),
    );
  }
}
