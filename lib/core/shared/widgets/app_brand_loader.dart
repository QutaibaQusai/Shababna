import 'package:flutter/material.dart';

import '../../config/app_assets.dart';

class AppBrandLoader extends StatelessWidget {
  const AppBrandLoader({super.key, required this.size, this.strokeWidth = 3});

  static const _logoInsetFactor = 0.11;

  final double size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.expand(child: CircularProgressIndicator(strokeWidth: strokeWidth)),
          Padding(
            padding: EdgeInsets.all(size * _logoInsetFactor),
            child: ClipOval(child: Image.asset(AppAssets.logoIcon, fit: BoxFit.cover)),
          ),
        ],
      ),
    );
  }
}
