import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/theme/app_sizes.dart';

class OnboardingIllustration extends StatelessWidget {
  const OnboardingIllustration({super.key, required this.asset});

  static const _entranceDuration = Duration(milliseconds: 500);
  static const _entranceScale = 0.92;

  final String asset;

  @override
  Widget build(BuildContext context) {
    final height = AppSizes.onboardingIllustrationHeight;
    final colors = context.colorScheme;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: _entranceDuration,
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.scale(scale: _entranceScale + (1 - _entranceScale) * value, child: child),
      ),
      child: SvgPicture(
        SvgAssetLoader(
          asset,
          colorMapper: _IllustrationColorMapper(
            primary: colors.primary,
            isDark: context.isDark,
            ink: colors.onSurface,
            surface: colors.surfaceContainerHighest,
          ),
        ),
        height: height,
        fit: BoxFit.contain,
        placeholderBuilder: (_) => SizedBox(height: height),
      ),
    );
  }
}

class _IllustrationColorMapper extends ColorMapper {
  const _IllustrationColorMapper({
    required this.primary,
    required this.isDark,
    required this.ink,
    required this.surface,
  });

  static const _placeholder = 0xFF6C63FF;
  static const _inks = {0xFF2F2E41, 0xFF3F3D56, 0xFF2F2E43};
  static const _lightGreys = {0xFFF2F2F2, 0xFFE6E6E6, 0xFFF0F0F0, 0xFFE4E4E4, 0xFFE6E7E8, 0xFFCCCCCC};

  final Color primary;
  final bool isDark;
  final Color ink;
  final Color surface;

  @override
  Color substitute(String? id, String elementName, String attributeName, Color color) {
    final value = color.toARGB32() | 0xFF000000;
    if (value == _placeholder) return primary.withValues(alpha: color.a);
    if (!isDark) return color;
    if (_inks.contains(value)) return ink.withValues(alpha: color.a);
    if (_lightGreys.contains(value)) return surface.withValues(alpha: color.a);
    return color;
  }

  @override
  bool operator ==(Object other) =>
      other is _IllustrationColorMapper &&
      other.primary == primary &&
      other.isDark == isDark &&
      other.ink == ink &&
      other.surface == surface;

  @override
  int get hashCode => Object.hash(primary, isDark, ink, surface);
}
