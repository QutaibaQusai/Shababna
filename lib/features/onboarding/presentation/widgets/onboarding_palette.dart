import 'package:flutter/material.dart';

class OnboardingPalette {
  OnboardingPalette._();

  static const _accentLightness = 0.45;
  static const glass = Color(0x59000000);
  static const shade = Color(0x99000000);
  static const scrim = Color(0xD9000000);
  static const foreground = Colors.white;
  static const muted = Color(0xCCFFFFFF);
  static const faint = Color(0x66FFFFFF);

  static Color accent(ColorScheme colorScheme) =>
      Color.lerp(colorScheme.primary, Colors.white, _accentLightness)!;
}
