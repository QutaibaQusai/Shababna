import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../extensions/context_extensions.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_sizes.dart';
import '../../theme/app_spacing.dart';

enum AppToastType { success, error, warning, info }

class AppToast {
  AppToast._();

  static OverlayEntry? _currentEntry;

  static void show(
    BuildContext context, {
    required String message,
    AppToastType type = AppToastType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    _currentEntry?.remove();
    _currentEntry = null;

    final overlay = Overlay.of(context, rootOverlay: true);
    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _ToastBanner(
        message: message,
        type: type,
        duration: duration,
        onDismiss: () {
          if (_currentEntry == entry) {
            _currentEntry = null;
            entry.remove();
          }
        },
      ),
    );
    _currentEntry = entry;
    overlay.insert(entry);
  }

  static void success(BuildContext context, String message) =>
      show(context, message: message, type: AppToastType.success);

  static void error(BuildContext context, String message) =>
      show(context, message: message, type: AppToastType.error);

  static void warning(BuildContext context, String message) =>
      show(context, message: message, type: AppToastType.warning);

  static void info(BuildContext context, String message) =>
      show(context, message: message, type: AppToastType.info);

  static Color _colorFor(AppToastType type) => switch (type) {
        AppToastType.success => AppColors.successColor,
        AppToastType.error => AppColors.errorColor,
        AppToastType.warning => AppColors.warningColor,
        AppToastType.info => AppColors.infoColor,
      };

  static IconData _iconFor(AppToastType type) => switch (type) {
        AppToastType.success => LucideIcons.checkCircle,
        AppToastType.error => LucideIcons.xCircle,
        AppToastType.warning => LucideIcons.triangleAlert,
        AppToastType.info => LucideIcons.info,
      };
}

class _ToastBanner extends StatefulWidget {
  const _ToastBanner({
    required this.message,
    required this.type,
    required this.duration,
    required this.onDismiss,
  });

  final String message;
  final AppToastType type;
  final Duration duration;
  final VoidCallback onDismiss;

  @override
  State<_ToastBanner> createState() => _ToastBannerState();
}

class _ToastBannerState extends State<_ToastBanner> with TickerProviderStateMixin {
  late final AnimationController _entryController;
  late final AnimationController _expandController;

  late final Animation<Offset> _offsetAnimation;
  late final Animation<double> _opacityAnimation;
  late final Animation<double> _scaleAnimation;

  late final Animation<double> _expandAnimation;
  late final Animation<double> _textFadeAnimation;

  Timer? _autoDismissTimer;

  @override
  void initState() {
    super.initState();

    _entryController = AnimationController(
      duration: const Duration(milliseconds: 400),
      reverseDuration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _expandController = AnimationController(
      duration: const Duration(milliseconds: 400),
      reverseDuration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(begin: const Offset(0, -1.5), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _entryController,
        curve: Curves.easeOutBack,
        reverseCurve: Curves.easeInBack,
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _entryController, curve: Curves.easeOutBack),
    );

    _expandAnimation = CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );

    _textFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _expandController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
        reverseCurve: const Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );

    _startSequence();
  }

  void _startSequence() {
    _entryController.forward().then((_) {
      if (!mounted) return;
      _expandController.forward();
    });

    _autoDismissTimer = Timer(widget.duration, _dismiss);
  }

  void _dismiss() {
    if (!mounted) return;
    _autoDismissTimer?.cancel();

    _expandController.reverse().then((_) {
      if (!mounted) return;
      _entryController.reverse().then((_) {
        if (!mounted) return;
        widget.onDismiss();
      });
    });
  }

  @override
  void dispose() {
    _autoDismissTimer?.cancel();
    _entryController.dispose();
    _expandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = AppToast._colorFor(widget.type);
    final icon = AppToast._iconFor(widget.type);
    final maxWidth = MediaQuery.sizeOf(context).width - (AppSpacing.lg * 2);

    return Semantics(
      liveRegion: true,
      child: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: SlideTransition(
              position: _offsetAnimation,
              child: FadeTransition(
                opacity: _opacityAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _dismiss,
                      borderRadius: AppRadius.pillRadius,
                      child: Container(
                        height: AppSizes.toastHeight,
                        constraints: BoxConstraints(maxWidth: maxWidth),
                        decoration: BoxDecoration(
                          color: context.colorScheme.inverseSurface,
                          borderRadius: AppRadius.pillRadius,
                          boxShadow: [
                            BoxShadow(
                              color: context.colorScheme.shadow.withValues(alpha: 0.15),
                              blurRadius: AppSpacing.md,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm,
                                vertical: AppSpacing.sm,
                              ),
                              child: Icon(icon, color: color, size: AppSizes.iconField),
                            ),
                            Flexible(
                              child: SizeTransition(
                                axis: Axis.horizontal,
                                sizeFactor: _expandAnimation,
                                alignment: AlignmentDirectional.centerStart,
                                child: FadeTransition(
                                  opacity: _textFadeAnimation,
                                  child: Padding(
                                    padding: EdgeInsetsDirectional.only(end: AppSpacing.md),
                                    child: Text(
                                      widget.message,
                                      style: context.textTheme.bodySmall?.copyWith(
                                        color: context.colorScheme.onInverseSurface,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
