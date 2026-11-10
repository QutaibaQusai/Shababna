import 'package:flutter/material.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_sizes.dart';
import '../../../../core/theme/app_spacing.dart';

class DashboardCard extends StatelessWidget {
  const DashboardCard({super.key, required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colorScheme.surface,
      borderRadius: AppRadius.lgRadius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(padding: EdgeInsets.all(AppSpacing.sm), child: child),
      ),
    );
  }
}

class DashboardIcon extends StatelessWidget {
  const DashboardIcon({super.key, required this.asset});

  final String asset;

  @override
  Widget build(BuildContext context) {
    final size = AppSizes.iconButtonSize;
    return Image.asset(asset, width: size, height: size);
  }
}
