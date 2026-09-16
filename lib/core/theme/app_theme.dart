import 'package:flutter/material.dart';

import 'app_borders.dart';
import 'app_colors.dart';
import 'app_radius.dart';
import 'app_shadows.dart';
import 'app_sizes.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light({required String fontFamily}) => ThemeData(
    useMaterial3: true,
    fontFamily: fontFamily,
    brightness: Brightness.light,
    splashFactory: NoSplash.splashFactory,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    hoverColor: Colors.transparent,
    colorScheme: _lightColorScheme,
    textTheme: _buildTextTheme(
      primary: AppColors.textPrimaryLight,
      secondary: AppColors.textSecondaryLight,
      fontFamily: fontFamily,
    ),
    scaffoldBackgroundColor: AppColors.backgroundLight,
    appBarTheme: _buildAppBarTheme(
      backgroundColor: AppColors.backgroundLight,
      foregroundColor: AppColors.textPrimaryLight,
      fontFamily: fontFamily,
    ),
    elevatedButtonTheme: _buildElevatedButtonTheme(
      background: AppColors.primaryColor,
      foreground: AppColors.surfaceLight,
      fontFamily: fontFamily,
    ),
    outlinedButtonTheme: _buildOutlinedButtonTheme(
      borderColor: AppColors.primaryColor,
      foreground: AppColors.primaryColor,
      fontFamily: fontFamily,
    ),
    textButtonTheme: _buildTextButtonTheme(AppColors.infoColor, fontFamily: fontFamily),
    iconButtonTheme: _buildIconButtonTheme(),
    inputDecorationTheme: _buildInputDecorationTheme(
      labelColor: AppColors.textSecondaryLight,
      fillColor: AppColors.surfaceLight,
      errorColor: AppColors.errorColor,
      fontFamily: fontFamily,
    ),
    cardTheme: _buildCardTheme(color: AppColors.surfaceLight),
    navigationBarTheme: _buildNavigationBarTheme(
      background: AppColors.surfaceLight,
      selected: AppColors.infoColor,
      unselected: AppColors.neutralColor,
      fontFamily: fontFamily,
    ),
    switchTheme: _buildSwitchTheme(
      track: AppColors.primaryColor,
      unselectedTrack: AppColors.neutralColor,
    ),
    dialogTheme: _buildDialogTheme(
      backgroundColor: AppColors.surfaceLight,
      titleColor: AppColors.textPrimaryLight,
      contentColor: AppColors.textSecondaryLight,
      fontFamily: fontFamily,
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.borderLight,
      thickness: AppBorders.hairline,
      space: AppBorders.hairline,
    ),
    progressIndicatorTheme: _buildProgressIndicatorTheme(
      color: AppColors.primaryColor,
      trackColor: AppColors.backgroundLight,
    ),
  );

  static ThemeData dark({required String fontFamily}) => ThemeData(
    useMaterial3: true,
    fontFamily: fontFamily,
    brightness: Brightness.dark,
    splashFactory: NoSplash.splashFactory,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    hoverColor: Colors.transparent,
    colorScheme: _darkColorScheme,
    textTheme: _buildTextTheme(
      primary: AppColors.textPrimaryDark,
      secondary: AppColors.textSecondaryDark,
      fontFamily: fontFamily,
    ),
    scaffoldBackgroundColor: AppColors.backgroundDark,
    appBarTheme: _buildAppBarTheme(
      backgroundColor: AppColors.backgroundDark,
      foregroundColor: AppColors.textPrimaryDark,
      fontFamily: fontFamily,
    ),
    elevatedButtonTheme: _buildElevatedButtonTheme(
      background: AppColors.primaryColor,
      foreground: AppColors.textPrimaryDark,
      fontFamily: fontFamily,
    ),
    outlinedButtonTheme: _buildOutlinedButtonTheme(
      borderColor: AppColors.primaryColor,
      foreground: AppColors.primaryColor,
      fontFamily: fontFamily,
    ),
    textButtonTheme: _buildTextButtonTheme(AppColors.infoColor, fontFamily: fontFamily),
    iconButtonTheme: _buildIconButtonTheme(),
    inputDecorationTheme: _buildInputDecorationTheme(
      labelColor: AppColors.textSecondaryDark,
      fillColor: AppColors.surfaceDark,
      errorColor: AppColors.errorColor,
      fontFamily: fontFamily,
    ),
    cardTheme: _buildCardTheme(color: AppColors.surfaceDark),
    navigationBarTheme: _buildNavigationBarTheme(
      background: AppColors.surfaceDark,
      selected: AppColors.infoColor,
      unselected: AppColors.neutralColor,
      fontFamily: fontFamily,
    ),
    switchTheme: _buildSwitchTheme(
      track: AppColors.primaryColor,
      unselectedTrack: AppColors.neutralColor,
    ),
    dialogTheme: _buildDialogTheme(
      backgroundColor: AppColors.surfaceDark,
      titleColor: AppColors.textPrimaryDark,
      contentColor: AppColors.textSecondaryDark,
      fontFamily: fontFamily,
    ),
    dividerTheme: DividerThemeData(
      color: AppColors.borderDark,
      thickness: AppBorders.hairline,
      space: AppBorders.hairline,
    ),
    progressIndicatorTheme: _buildProgressIndicatorTheme(
      color: AppColors.primaryColor,
      trackColor: AppColors.surfaceDark,
    ),
  );

  static const ColorScheme _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primaryColor,
    onPrimary: AppColors.surfaceLight,
    secondary: AppColors.infoColor,
    onSecondary: AppColors.surfaceLight,
    surface: AppColors.surfaceLight,
    onSurface: AppColors.textPrimaryLight,
    surfaceContainerHighest: AppColors.surfaceHighestLight,
    onSurfaceVariant: AppColors.textSecondaryLight,
    error: AppColors.errorColor,
    onError: AppColors.surfaceLight,
    outline: AppColors.borderLight,
    outlineVariant: AppColors.surfaceHighestLight,
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: AppColors.backgroundDark,
    onInverseSurface: AppColors.textPrimaryDark,
    inversePrimary: AppColors.infoColor,
  );

  static const ColorScheme _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.primaryColor,
    onPrimary: AppColors.textPrimaryDark,
    secondary: AppColors.infoColor,
    onSecondary: AppColors.textPrimaryDark,
    surface: AppColors.surfaceDark,
    onSurface: AppColors.textPrimaryDark,
    surfaceContainerHighest: AppColors.surfaceHighestDark,
    onSurfaceVariant: AppColors.textSecondaryDark,
    error: AppColors.errorColor,
    onError: AppColors.textPrimaryDark,
    outline: AppColors.borderDark,
    outlineVariant: AppColors.surfaceHighestDark,
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: AppColors.backgroundLight,
    onInverseSurface: AppColors.textPrimaryLight,
    inversePrimary: AppColors.primaryColor,
  );

  static TextTheme _buildTextTheme({
    required Color primary,
    required Color secondary,
    required String fontFamily,
  }) => TextTheme(
    displayLarge: AppTypography.largeTitle(fontFamily: fontFamily, color: primary),
    displayMedium: AppTypography.title1(fontFamily: fontFamily, color: primary),
    displaySmall: AppTypography.title2(fontFamily: fontFamily, color: primary),
    headlineLarge: AppTypography.title3(fontFamily: fontFamily, color: primary),
    headlineMedium: AppTypography.headline(fontFamily: fontFamily, color: primary),
    headlineSmall: AppTypography.headline(fontFamily: fontFamily, color: primary),
    titleLarge: AppTypography.headline(fontFamily: fontFamily, color: primary),
    titleMedium: AppTypography.callout(fontFamily: fontFamily, color: primary),
    titleSmall: AppTypography.subheadline(fontFamily: fontFamily, color: primary),
    bodyLarge: AppTypography.body(fontFamily: fontFamily, color: primary),
    bodyMedium: AppTypography.callout(fontFamily: fontFamily, color: primary),
    bodySmall: AppTypography.footnote(fontFamily: fontFamily, color: secondary),
    labelLarge: AppTypography.buttonLabel(fontFamily: fontFamily, color: primary),
    labelMedium: AppTypography.caption1(fontFamily: fontFamily, color: secondary),
    labelSmall: AppTypography.caption2(fontFamily: fontFamily, color: secondary),
  );

  static AppBarTheme _buildAppBarTheme({
    required Color backgroundColor,
    required Color foregroundColor,
    required String fontFamily,
  }) => AppBarTheme(
    backgroundColor: backgroundColor,
    foregroundColor: foregroundColor,
    elevation: AppShadows.none,
    scrolledUnderElevation: AppShadows.none,
    centerTitle: true,
    titleTextStyle: AppTypography.headline(fontFamily: fontFamily, color: foregroundColor),
  );

  static ElevatedButtonThemeData _buildElevatedButtonTheme({
    required Color background,
    required Color foreground,
    required String fontFamily,
  }) => ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: background,
      foregroundColor: foreground,
      disabledBackgroundColor: background.withValues(alpha: 0.4),
      overlayColor: Colors.transparent,
      minimumSize: Size(double.infinity, AppSizes.buttonHeight),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.mdRadius),
      elevation: AppShadows.low,
      textStyle: AppTypography.buttonLabel(fontFamily: fontFamily),
    ),
  );

  static OutlinedButtonThemeData _buildOutlinedButtonTheme({
    required Color borderColor,
    required Color foreground,
    required String fontFamily,
  }) => OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: foreground,
      overlayColor: Colors.transparent,
      minimumSize: Size(double.infinity, AppSizes.buttonHeight),
      side: AppBorders.side(borderColor),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.mdRadius),
      textStyle: AppTypography.buttonLabel(fontFamily: fontFamily),
    ),
  );

  static TextButtonThemeData _buildTextButtonTheme(
    Color color, {
    required String fontFamily,
  }) => TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: color,
          overlayColor: Colors.transparent,
          textStyle: AppTypography.buttonLabel(fontFamily: fontFamily),
        ),
      );

  static IconButtonThemeData _buildIconButtonTheme() => IconButtonThemeData(
    style: IconButton.styleFrom(overlayColor: Colors.transparent),
  );

  static InputDecorationTheme _buildInputDecorationTheme({
    required Color labelColor,
    required Color fillColor,
    required Color errorColor,
    required String fontFamily,
  }) {
    final radius = AppRadius.mdRadius;
    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      border: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: AppBorders.side(errorColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: AppBorders.side(errorColor, width: AppBorders.thick),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: BorderSide.none,
      ),
      labelStyle: AppTypography.body(fontFamily: fontFamily, color: labelColor),
      hintStyle: AppTypography.body(fontFamily: fontFamily, color: labelColor),
      errorStyle: AppTypography.footnote(fontFamily: fontFamily, color: errorColor),
    );
  }

  static CardThemeData _buildCardTheme({required Color color}) => CardThemeData(
    color: color,
    elevation: AppShadows.low,
    shape: RoundedRectangleBorder(borderRadius: AppRadius.mdRadius),
    margin: EdgeInsets.zero,
  );

  static NavigationBarThemeData _buildNavigationBarTheme({
    required Color background,
    required Color selected,
    required Color unselected,
    required String fontFamily,
  }) => NavigationBarThemeData(
    backgroundColor: background,
    indicatorColor: selected.withValues(alpha: 0.12),
    height: AppSizes.bottomNavHeight,
    iconTheme: WidgetStateProperty.resolveWith((states) {
      final isSelected = states.contains(WidgetState.selected);
      return IconThemeData(color: isSelected ? selected : unselected);
    }),
    labelTextStyle: WidgetStateProperty.resolveWith((states) {
      final isSelected = states.contains(WidgetState.selected);
      return AppTypography.caption2(
        fontFamily: fontFamily,
        color: isSelected ? selected : unselected,
      );
    }),
    elevation: AppShadows.low,
  );

  static SwitchThemeData _buildSwitchTheme({
    required Color track,
    required Color unselectedTrack,
  }) => SwitchThemeData(
    trackColor: WidgetStateProperty.resolveWith((states) {
      return states.contains(WidgetState.selected) ? track : unselectedTrack;
    }),
  );

  static DialogThemeData _buildDialogTheme({
    required Color backgroundColor,
    required Color titleColor,
    required Color contentColor,
    required String fontFamily,
  }) => DialogThemeData(
    backgroundColor: backgroundColor,
    elevation: AppShadows.medium,
    shape: RoundedRectangleBorder(borderRadius: AppRadius.lgRadius),
    titleTextStyle: AppTypography.headline(fontFamily: fontFamily, color: titleColor),
    contentTextStyle: AppTypography.subheadline(fontFamily: fontFamily, color: contentColor),
  );

  static ProgressIndicatorThemeData _buildProgressIndicatorTheme({
    required Color color,
    required Color trackColor,
  }) =>
      ProgressIndicatorThemeData(color: color, circularTrackColor: trackColor);
}
