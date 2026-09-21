import 'package:flutter/material.dart';

import '../../extensions/context_extensions.dart';
import '../../theme/app_sizes.dart';
import 'app_svg_icon.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required IconData this.icon,
    required this.onPressed,
    this.containerColor,
    this.iconColor,
    this.semanticLabel,
  }) : svgAsset = null;

  const AppIconButton.svg({
    super.key,
    required String this.svgAsset,
    required this.onPressed,
    this.containerColor,
    this.iconColor,
    this.semanticLabel,
  }) : icon = null;

  final IconData? icon;
  final String? svgAsset;
  final VoidCallback? onPressed;
  final Color? containerColor;
  final Color? iconColor;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final fieldColor = context.colorScheme.surfaceContainerHighest;
    final resolvedIconColor =
        iconColor ??
        (containerColor != null
            ? context.colorScheme.onPrimary
            : context.colorScheme.onSurface);

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
            child: svgAsset != null
                ? AppSvgIcon(
                    asset: svgAsset!,
                    size: AppSizes.iconMd,
                    color: resolvedIconColor,
                  )
                : Icon(icon, size: AppSizes.iconMd, color: resolvedIconColor),
          ),
        ),
      ),
    );
  }
}
