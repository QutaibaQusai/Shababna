import 'package:flutter/material.dart';

import '../../../../../core/config/app_assets.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';

class ProfileCompanyWatermark extends StatelessWidget {
  const ProfileCompanyWatermark({super.key});

  static const _opacity = 0.45;
  static const _companyName = 'HiTech';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: Center(
        child: Opacity(
          opacity: _opacity,
          child: Image.asset(
            isDark
                ? AppAssets.hitechLogoDarkMode
                : AppAssets.hitechLogoLightMode,
            height: AppSizes.companyWatermarkHeight,
            fit: BoxFit.contain,
            semanticLabel: _companyName,
          ),
        ),
      ),
    );
  }
}
