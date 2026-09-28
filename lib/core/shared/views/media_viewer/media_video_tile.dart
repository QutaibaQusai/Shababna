import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../extensions/context_extensions.dart';
import '../../../theme/app_sizes.dart';

class MediaVideoTile extends StatelessWidget {
  const MediaVideoTile({super.key});

  @override
  Widget build(BuildContext context) {
    final size = AppSizes.iconButtonSize * 1.4;

    return Semantics(
      button: true,
      label: context.l10n.mediaPlayVideo,
      child: ColoredBox(
        color: context.colorScheme.surfaceContainerHighest,
        child: Center(
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(color: context.colorScheme.primary, shape: BoxShape.circle),
            child: Icon(
              LucideIcons.play,
              size: AppSizes.iconMd,
              color: context.colorScheme.onPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
