import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/config/app_assets.dart';
import '../../../../core/theme/app_sizes.dart';

class HomeBackgroundDecoration extends StatelessWidget {
  const HomeBackgroundDecoration({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: SvgPicture.asset(
              AppAssets.homeDecorationLeft,
              width: AppSizes.homeDecorationLeftWidth,
              excludeFromSemantics: true,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: SvgPicture.asset(
              AppAssets.homeDecorationRight,
              width: AppSizes.homeDecorationRightWidth,
              excludeFromSemantics: true,
            ),
          ),
        ],
      ),
    );
  }
}
