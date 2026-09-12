import 'package:flutter/material.dart';

import '../../extensions/context_extensions.dart';

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
              child: const Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }
}
