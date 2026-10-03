import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../extensions/context_extensions.dart';

class AppIllustration extends StatelessWidget {
  const AppIllustration({super.key, required this.asset, required this.height, this.color});

  final String asset;
  final double height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture(
      SvgAssetLoader(asset, colorMapper: _PrimaryColorMapper(color ?? context.colorScheme.primary)),
      height: height,
      placeholderBuilder: (_) => SizedBox(height: height),
    );
  }
}

class _PrimaryColorMapper extends ColorMapper {
  const _PrimaryColorMapper(this.primary);

  static const _placeholder = 0xFF6C63FF;

  final Color primary;

  @override
  Color substitute(String? id, String elementName, String attributeName, Color color) {
    final isPlaceholder = (color.toARGB32() | 0xFF000000) == _placeholder;
    return isPlaceholder ? primary.withValues(alpha: color.a) : color;
  }

  @override
  bool operator ==(Object other) => other is _PrimaryColorMapper && other.primary == primary;

  @override
  int get hashCode => primary.hashCode;
}
