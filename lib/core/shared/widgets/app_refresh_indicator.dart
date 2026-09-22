import 'dart:math' as math;

import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../extensions/context_extensions.dart';
import '../../theme/app_sizes.dart';

class AppRefreshIndicator extends StatelessWidget {
  const AppRefreshIndicator({super.key, required this.onRefresh, required this.child});

  final Future<void> Function() onRefresh;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomMaterialIndicator(
      onRefresh: onRefresh,
      backgroundColor: context.colorScheme.surface,
      indicatorBuilder: (context, controller) {
        return Transform.rotate(
          angle: controller.value * 2 * math.pi,
          child: Icon(
            LucideIcons.loaderCircle,
            color: context.colorScheme.primary,
            size: AppSizes.iconMd,
          ),
        );
      },
      child: child,
    );
  }
}
