import 'package:flutter/material.dart';

import '../../extensions/context_extensions.dart';
import '../../theme/app_sizes.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.containerColor,
    this.iconColor,
    this.semanticLabel,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final Color? containerColor;
  final Color? iconColor;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final fieldColor = context.colorScheme.surfaceContainerHighest;

    return Semantics(
      button: true,
      label: semanticLabel,
      excludeSemantics: semanticLabel != null,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: AppSizes.iconButtonSize,
          height: AppSizes.iconButtonSize,
          decoration: BoxDecoration(
            color: containerColor ?? fieldColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(
              icon,
              size: AppSizes.iconMd,
              color:
                  iconColor ??
                  (containerColor != null
                      ? context.colorScheme.onPrimary
                      : context.colorScheme.onSurface),
            ),
          ),
        ),
      ),
    );
  }
}
