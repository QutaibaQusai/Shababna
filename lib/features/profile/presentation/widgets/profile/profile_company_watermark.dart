import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/config/app_assets.dart';
import '../../../../../core/theme/app_radius.dart';
import '../../../../../core/theme/app_sizes.dart';
import '../../../../../core/theme/app_spacing.dart';

class ProfileCompanyWatermark extends StatelessWidget {
  const ProfileCompanyWatermark({super.key});

  static const _opacity = 0.45;
  static const _companyName = 'HiTech';
  static final _companyWebsite = Uri.parse('https://www.hitechjo.com');

  Future<void> _openWebsite() async {
    await launchUrl(_companyWebsite, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: Center(
        child: Semantics(
          link: true,
          label: _companyName,
          child: Material(
            type: MaterialType.transparency,
            child: InkWell(
              onTap: _openWebsite,
              borderRadius: AppRadius.mdRadius,
              child: Opacity(
                opacity: _opacity,
                child: Image.asset(
                  isDark ? AppAssets.hitechLogoDarkMode : AppAssets.hitechLogoLightMode,
                  height: AppSizes.companyWatermarkHeight,
                  fit: BoxFit.contain,
                  semanticLabel: _companyName,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
