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
    ),
    scaffoldBackgroundColor: AppColors.backgroundLight,
    appBarTheme: _buildAppBarTheme(
      backgroundColor: AppColors.backgroundLight,
      foregroundColor: AppColors.textPrimaryLight,
    ),
    elevatedButtonTheme: _buildElevatedButtonTheme(
      background: AppColors.primaryColor,
      foreground: AppColors.surfaceLight,
    ),
    outlinedButtonTheme: _buildOutlinedButtonTheme(
      borderColor: AppColors.primaryColor,
      foreground: AppColors.primaryColor,
    ),
    textButtonTheme: _buildTextButtonTheme(AppColors.infoColor),
    iconButtonTheme: _buildIconButtonTheme(),
    inputDecorationTheme: _buildInputDecorationTheme(
      labelColor: AppColors.textSecondaryLight,
      fillColor: AppColors.surfaceLight,
      errorColor: AppColors.errorColor,
    ),
    cardTheme: _buildCardTheme(color: AppColors.surfaceLight),
    navigationBarTheme: _buildNavigationBarTheme(
      background: AppColors.surfaceLight,
      selected: AppColors.infoColor,
      unselected: AppColors.neutralColor,
    ),
    switchTheme: _buildSwitchTheme(
      track: AppColors.primaryColor,
      unselectedTrack: AppColors.neutralColor,
    ),
    dialogTheme: _buildDialogTheme(
      backgroundColor: AppColors.surfaceLight,
      titleColor: AppColors.textPrimaryLight,
      contentColor: AppColors.textSecondaryLight,
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
    ),
    scaffoldBackgroundColor: AppColors.backgroundDark,
    appBarTheme: _buildAppBarTheme(
      backgroundColor: AppColors.backgroundDark,
      foregroundColor: AppColors.textPrimaryDark,
    ),
    elevatedButtonTheme: _buildElevatedButtonTheme(
      background: AppColors.primaryColor,
      foreground: AppColors.textPrimaryDark,
    ),
    outlinedButtonTheme: _buildOutlinedButtonTheme(
      borderColor: AppColors.primaryColor,
      foreground: AppColors.primaryColor,
    ),
    textButtonTheme: _buildTextButtonTheme(AppColors.infoColor),
    iconButtonTheme: _buildIconButtonTheme(),
    inputDecorationTheme: _buildInputDecorationTheme(
      labelColor: AppColors.textSecondaryDark,
      fillColor: AppColors.surfaceDark,
      errorColor: AppColors.errorColor,
    ),
    cardTheme: _buildCardTheme(color: AppColors.surfaceDark),
    navigationBarTheme: _buildNavigationBarTheme(
      background: AppColors.surfaceDark,
      selected: AppColors.infoColor,
      unselected: AppColors.neutralColor,
    ),
    switchTheme: _buildSwitchTheme(
      track: AppColors.primaryColor,
      unselectedTrack: AppColors.neutralColor,
    ),
    dialogTheme: _buildDialogTheme(
      backgroundColor: AppColors.surfaceDark,
      titleColor: AppColors.textPrimaryDark,
      contentColor: AppColors.textSecondaryDark,
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
  }) => TextTheme(
    displayLarge: AppTypography.largeTitle(color: primary),
    displayMedium: AppTypography.title1(color: primary),
    displaySmall: AppTypography.title2(color: primary),
    headlineLarge: AppTypography.title3(color: primary),
    headlineMedium: AppTypography.headline(color: primary),
    headlineSmall: AppTypography.headline(color: primary),
    titleLarge: AppTypography.headline(color: primary),
    titleMedium: AppTypography.callout(color: primary),
    titleSmall: AppTypography.subheadline(color: primary),
    bodyLarge: AppTypography.body(color: primary),
    bodyMedium: AppTypography.callout(color: primary),
    bodySmall: AppTypography.footnote(color: secondary),
    labelLarge: AppTypography.buttonLabel(color: primary),
    labelMedium: AppTypography.caption1(color: secondary),
    labelSmall: AppTypography.caption2(color: secondary),
  );

  static AppBarTheme _buildAppBarTheme({
    required Color backgroundColor,
    required Color foregroundColor,
  }) => AppBarTheme(
    backgroundColor: backgroundColor,
    foregroundColor: foregroundColor,
    elevation: AppShadows.none,
    scrolledUnderElevation: AppShadows.none,
    centerTitle: true,
    titleTextStyle: AppTypography.headline(color: foregroundColor),
  );

  static ElevatedButtonThemeData _buildElevatedButtonTheme({
    required Color background,
    required Color foreground,
  }) => ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: background,
      foregroundColor: foreground,
      disabledBackgroundColor: background.withValues(alpha: 0.4),
      overlayColor: Colors.transparent,
      minimumSize: Size(double.infinity, AppSizes.buttonHeight),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.mdRadius),
      elevation: AppShadows.low,
      textStyle: AppTypography.buttonLabel(),
    ),
  );

  static OutlinedButtonThemeData _buildOutlinedButtonTheme({
    required Color borderColor,
    required Color foreground,
  }) => OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: foreground,
      overlayColor: Colors.transparent,
      minimumSize: Size(double.infinity, AppSizes.buttonHeight),
      side: AppBorders.side(borderColor),
      shape: RoundedRectangleBorder(borderRadius: AppRadius.mdRadius),
      textStyle: AppTypography.buttonLabel(),
    ),
  );

  static TextButtonThemeData _buildTextButtonTheme(Color color) =>
      TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: color,
          overlayColor: Colors.transparent,
          textStyle: AppTypography.buttonLabel(),
        ),
      );

  static IconButtonThemeData _buildIconButtonTheme() => IconButtonThemeData(
    style: IconButton.styleFrom(overlayColor: Colors.transparent),
  );

  static InputDecorationTheme _buildInputDecorationTheme({
    required Color labelColor,
    required Color fillColor,
    required Color errorColor,
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
      labelStyle: AppTypography.body(color: labelColor),
      hintStyle: AppTypography.body(color: labelColor),
      errorStyle: AppTypography.footnote(color: errorColor),
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
      return AppTypography.caption2(color: isSelected ? selected : unselected);
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
  }) => DialogThemeData(
    backgroundColor: backgroundColor,
    elevation: AppShadows.medium,
    shape: RoundedRectangleBorder(borderRadius: AppRadius.lgRadius),
    titleTextStyle: AppTypography.headline(color: titleColor),
    contentTextStyle: AppTypography.subheadline(color: contentColor),
  );

  static ProgressIndicatorThemeData _buildProgressIndicatorTheme({
    required Color color,
    required Color trackColor,
  }) =>
      ProgressIndicatorThemeData(color: color, circularTrackColor: trackColor);
}
