import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_sizes.dart';

class CircularNavigationButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double progress; // 0.0 to 1.0
  final bool isLastPage;

  const CircularNavigationButton({
    super.key,
    required this.onPressed,
    required this.progress,
    this.isLastPage = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Progress Indicator
        SizedBox(
          width: 80,
          height: 80,
          child: CircularProgressIndicator(
            value: progress,
            strokeWidth: 2,
            backgroundColor: context.colorScheme.primary.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(
              context.colorScheme.primary,
            ),
          ),
        ),

        // Button
        Material(
          color: context.colorScheme.primary,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onPressed,
            child: Container(
              width: 65,
              height: 65,
              alignment: Alignment.center,
              child: Transform.flip(
                flipX: !isLastPage && context.isRTL,
                child: Icon(
                  isLastPage ? LucideIcons.check : LucideIcons.arrowRight,
                  color: context.colorScheme.onPrimary,
                  size: AppSizes.iconLg,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
