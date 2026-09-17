import 'package:flutter/material.dart';

import '../../config/app_assets.dart';
import '../../extensions/context_extensions.dart';
import '../../theme/app_sizes.dart';
import '../../theme/app_spacing.dart';

class AppLoadingOverlay extends StatefulWidget {
  const AppLoadingOverlay({super.key, required this.isLoading, required this.child});

  final bool isLoading;
  final Widget child;

  @override
  State<AppLoadingOverlay> createState() => _AppLoadingOverlayState();
}

class _AppLoadingOverlayState extends State<AppLoadingOverlay> {
  @override
  void didUpdateWidget(AppLoadingOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading && !oldWidget.isLoading) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AbsorbPointer(absorbing: widget.isLoading, child: widget.child),
        if (widget.isLoading)
          Positioned.fill(
            child: ColoredBox(
              color: context.colorScheme.scrim.withValues(alpha: 0.4),
              child: Center(
                child: SizedBox(
                  width: AppSizes.loadingIndicatorSize,
                  height: AppSizes.loadingIndicatorSize,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const SizedBox.expand(child: CircularProgressIndicator(strokeWidth: 3)),
                      Padding(
                        padding: EdgeInsets.all(AppSpacing.xs),
                        child: ClipOval(
                          child: Image.asset(AppAssets.logoIcon, fit: BoxFit.cover),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
