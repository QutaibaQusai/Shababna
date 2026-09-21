import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../extensions/context_extensions.dart';
import '../../theme/app_sizes.dart';

class AppSvgIcon extends StatelessWidget {
  const AppSvgIcon({super.key, required this.asset, this.size, this.color});

  final String asset;
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final iconTheme = IconTheme.of(context);
    final resolvedSize = size ?? iconTheme.size ?? AppSizes.iconMd;
    final resolvedColor =
        color ?? iconTheme.color ?? context.colorScheme.onSurface;

    return SvgPicture.asset(
      asset,
      width: resolvedSize,
      height: resolvedSize,
      fit: BoxFit.contain,
      excludeFromSemantics: true,
      colorFilter: ColorFilter.mode(resolvedColor, BlendMode.srcIn),
    );
  }
}
